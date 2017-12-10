module Main exposing (..)

import Html exposing (Html)
import Json.Encode exposing (Value, object, string)
import Json.Decode exposing (field, decodeString, decodeValue, string, Decoder)
import Phoenix.Socket as PhxSocket
    exposing
        ( init
        , join
        , on
        , push
        , update
        , withDebug
        )
import Phoenix.Channel as PhxChannel exposing (init, onJoin)
import Phoenix.Push as PhxPush exposing (init, onError, onOk, withPayload)
import Task
import Types exposing (..)
import Ports exposing (addToGraph, initGraph)
import View exposing (view)
import Subscriptions exposing (subscriptions)
import Decoders.Graph as GraphDecode exposing (fromWsDecoder)
import Encoders.Common as GraphEncode exposing (userEncoder)
import Encoders.Graph as GraphEncode exposing (encoder)
import Accessors.Graph as Graph exposing (..)
import Accessors.Operations as Operations exposing (..)
import Utils.ZipList as ZipList exposing (..)


main : Program Flags Model Msg
main =
    Html.programWithFlags
        { init = init
        , view = View.view
        , update = update
        , subscriptions = Subscriptions.subscriptions
        }



--- CONSTANT


channelName : String
channelName =
    "constellation:explore"



-- MODEL


initOperations : Flags -> Operations
initOperations flags =
    { node =
        { searched =
            Just
                { uuid = flags.originNodeUuid
                , labels = flags.originNodeLabels
                }
        , browsed = Nothing
        , pinned = Nothing
        }
    , graph =
        { data = Nothing
        , isInitial = True
        }
    , edge =
        { browsed = Nothing
        , pinned = Nothing
        }
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { phxSocket = PhxSocket.init flags.socketUrl
      , socketUrl = flags.socketUrl
      , errorMessage = Nothing
      , userToken = flags.userToken
      , operations = initOperations flags
      , snapshots = ZipList.init (Snapshot [] "init") []
      }
    , joinChannel
    )


joinChannel : Cmd Msg
joinChannel =
    Task.perform (always Join) (Task.succeed ())



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        -- General
        PhoenixMsg msg ->
            let
                ( phxSocket, phxCmd ) =
                    PhxSocket.update msg model.phxSocket
            in
                ( { model | phxSocket = phxSocket }
                , Cmd.map PhoenixMsg phxCmd
                )

        HandleSendError _ ->
            ( { model
                | errorMessage =
                    Just "Failed to send message to websocket. Try again later"
              }
            , Cmd.none
            )

        --Ports OUT
        SendGraph ->
            case model.operations.graph.data of
                Just graph ->
                    ( model, Ports.addToGraph (GraphEncode.encoder graph) )

                Nothing ->
                    ( model, Cmd.none )

        InitGraph ->
            case model.operations.graph.data of
                Just graph ->
                    ( model, Ports.initGraph (GraphEncode.encoder graph) )

                Nothing ->
                    ( model, Cmd.none )

        --Ports IN
        SetSearchNode (Ok searchNode) ->
            let
                newOps =
                    (Operations.setSearchedNode (Just searchNode)
                        model.operations
                    )
            in
                ( { model | operations = newOps }
                , Task.perform (always GetNodeLocalGraph) (Task.succeed ())
                )

        SetSearchNode (Err searchNode) ->
            ( model, Cmd.none )

        SetBrowsedElement (Ok browsedElement) ->
            let
                newModel =
                    case browsedElement.elementType of
                        EdgeElt ->
                            updateBrowsedEdge browsedElement model

                        NodeElt ->
                            updateBrowsedNode browsedElement model
            in
                ( newModel, Cmd.none )

        SetBrowsedElement (Err error) ->
            ( { model
                | errorMessage =
                    Just ("Failed to set browsedElement: " ++ error)
              }
            , Cmd.none
            )

        UnsetBrowsedElement (Ok elementType) ->
            let
                newOps =
                    case elementType of
                        NodeElt ->
                            Operations.setBrowsedNode Nothing model.operations

                        EdgeElt ->
                            Operations.setBrowsedEdge Nothing model.operations
            in
                ( { model | operations = newOps }, Cmd.none )

        UnsetBrowsedElement (Err error) ->
            ( { model
                | errorMessage =
                    Just ("Failed to unset browsedElement: " ++ error)
              }
            , Cmd.none
            )

        SetPinnedElement (Ok pinnedElement) ->
            let
                newModel =
                    case pinnedElement.elementType of
                        EdgeElt ->
                            updatePinnedEdge pinnedElement model

                        NodeElt ->
                            updatePinnedNode pinnedElement model
            in
                ( newModel, Cmd.none )

        SetPinnedElement (Err error) ->
            ( { model
                | errorMessage =
                    Just ("Failed to unset pinnedElement: " ++ error)
              }
            , Cmd.none
            )

        SetGraphState (Ok snapshot) ->
            let
                newSnapshots =
                    case model.operations.graph.isInitial of
                        True ->
                            ZipList.update snapshot model.snapshots

                        False ->
                            ZipList.add snapshot model.snapshots

                newOps =
                    (Operations.setGraphIsInitial False
                        >> Operations.setGraphData Nothing
                    )
                        model.operations
            in
                ( { model
                    | snapshots = newSnapshots
                    , operations = newOps
                  }
                , Cmd.none
                )

        SetGraphState (Err error) ->
            ( { model
                | errorMessage =
                    Just ("Failed to set new graph state: " ++ error)
              }
            , Cmd.none
            )

        -- Socket
        Join ->
            let
                channel =
                    PhxChannel.init channelName
                        |> PhxChannel.withPayload (userEncoder model.userToken)
                        |> PhxChannel.onJoin (always GetNodeLocalGraph)
                        |> PhxChannel.onJoinError (always JoinError)

                ( phxSocket, phxCmd ) =
                    PhxSocket.init model.socketUrl
                        |> PhxSocket.withDebug
                        |> PhxSocket.on "node_local_graph"
                            channelName
                            ReceiveNodeLocalGraph
                        |> PhxSocket.join channel
            in
                ( { model | phxSocket = phxSocket }
                , Cmd.map PhoenixMsg phxCmd
                )

        JoinError ->
            ( { model | errorMessage = Just "Impossible d'afficher le graphe." }
            , Cmd.none
            )

        GetNodeLocalGraph ->
            case model.operations.node.searched of
                Nothing ->
                    ( model, Cmd.none )

                Just searchNode ->
                    let
                        payload =
                            Json.Encode.object
                                [ ( "uuid", Json.Encode.string searchNode.uuid )
                                , ( "labels"
                                  , Json.Encode.list
                                        (List.map
                                            Json.Encode.string
                                            searchNode.labels
                                        )
                                  )
                                ]

                        phxPush =
                            PhxPush.init "node_local_graph" channelName
                                |> PhxPush.withPayload payload
                                |> PhxPush.onOk ReceiveNodeLocalGraph
                                |> PhxPush.onError HandleSendError

                        ( phxSocket, phxCmd ) =
                            PhxSocket.push phxPush model.phxSocket
                    in
                        ( { model
                            | phxSocket = phxSocket
                            , errorMessage = Nothing
                          }
                        , Cmd.map PhoenixMsg phxCmd
                        )

        ReceiveNodeLocalGraph raw ->
            let
                decodedGraph =
                    Json.Decode.decodeValue GraphDecode.fromWsDecoder raw

                localGraphCmd =
                    case model.operations.graph.isInitial of
                        True ->
                            Task.perform (always InitGraph) (Task.succeed ())

                        False ->
                            Task.perform (always SendGraph) (Task.succeed ())

                newOps =
                    Operations.setSearchedNode Nothing model.operations
            in
                case decodedGraph of
                    Ok graph ->
                        let
                            filteredGraph =
                                Graph.substractGraph graph
                                    (ZipList.current
                                        model.snapshots
                                    ).graph

                            graphCmd =
                                if List.length filteredGraph > 0 then
                                    localGraphCmd
                                else
                                    Cmd.none

                            finalOps =
                                Operations.setGraphData
                                    (Just
                                        (Graph.updateMetaData
                                            model.operations.node.searched
                                            graph
                                        )
                                    )
                                    newOps
                        in
                            ( { model
                                | operations = finalOps
                              }
                            , graphCmd
                            )

                    Err error ->
                        ( { model
                            | errorMessage =
                                Just
                                    ("Cannot decode received graph. -["
                                        ++ error
                                        ++ "]"
                                    )
                          }
                        , Cmd.none
                        )


updateBrowsedEdge : BrowsedElement -> Model -> Model
updateBrowsedEdge element model =
    let
        browsedEdge =
            Graph.getEdge element.id (ZipList.current model.snapshots).graph

        newOps =
            Operations.setBrowsedEdge browsedEdge model.operations
    in
        { model | operations = newOps }


updateBrowsedNode : BrowsedElement -> Model -> Model
updateBrowsedNode element model =
    let
        browsedNode =
            Graph.getNode element.id (ZipList.current model.snapshots).graph

        newOps =
            Operations.setBrowsedNode browsedNode model.operations
    in
        { model | operations = newOps }


updatePinnedEdge : PinnedElement -> Model -> Model
updatePinnedEdge element model =
    let
        pinnedEdge =
            case element.pin of
                True ->
                    model.operations.edge.browsed

                False ->
                    Nothing

        newOps =
            Operations.setPinnedEdge pinnedEdge model.operations
    in
        { model | operations = newOps }


updatePinnedNode : PinnedElement -> Model -> Model
updatePinnedNode element model =
    let
        pinnedNode =
            case element.pin of
                True ->
                    model.operations.node.browsed

                False ->
                    Nothing

        newOps =
            Operations.setPinnedNode pinnedNode model.operations
    in
        { model | operations = newOps }
