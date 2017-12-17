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
import Dict
import Types exposing (..)
import Ports
    exposing
        ( addToGraph
        , initGraph
        , setVisibleElements
        )
import View exposing (view)
import Subscriptions exposing (subscriptions)
import Decoders.Graph as GraphDecode exposing (fromWsDecoder)
import Decoders.Element as ElementDecode exposing (filterDecoder)
import Encoders.Common as GraphEncode exposing (userEncoder)
import Encoders.Graph as GraphEncode exposing (encoder)
import Encoders.Operations as OperationsEncode exposing (visibleElementsEncoder)
import Accessors.Graph as Graph exposing (..)
import Accessors.Operations as Operations exposing (..)
import Accessors.Snapshots as Snapshots exposing (..)


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
        , filtered = Dict.empty
        }
    , graph =
        { data = Nothing
        , isInitial = True
        , snapshot = Nothing
        }
    , edge =
        { browsed = Nothing
        , pinned = Nothing
        , filtered = Dict.empty
        }
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { phxSocket = PhxSocket.init flags.socketUrl
      , socketUrl = flags.socketUrl
      , errorMessage = Nothing
      , userToken = flags.userToken
      , operations = initOperations flags
      , snapshots = Snapshots.init
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
                    (model)
                        ! [ Task.perform (always GetNodeLabels) (Task.succeed ())
                          , Task.perform (always GetEdgeTypes) (Task.succeed ())
                          , Ports.initGraph (GraphEncode.encoder graph)
                          ]

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
                    Snapshots.addNewSnapshot snapshot model.operations model.snapshots

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
                        |> PhxSocket.on "node:local_graph"
                            channelName
                            ReceiveNodeLocalGraph
                        |> PhxSocket.on "node:labels"
                            channelName
                            ReceiveNodeLabels
                        |> PhxSocket.on "edge:types"
                            channelName
                            ReceiveEdgeTypes
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
                            PhxPush.init "node:local_graph" channelName
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
                                    (Snapshots.getCurrent
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
                            ( { model | operations = finalOps }, graphCmd )

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

        GetNodeLabels ->
            let
                phxPush =
                    PhxPush.init "node:labels" channelName
                        |> PhxPush.onOk ReceiveNodeLabels
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

        ReceiveNodeLabels raw ->
            let
                decodedLabels =
                    Json.Decode.decodeValue ElementDecode.filterDecoder raw
            in
                case decodedLabels of
                    Ok labelsList ->
                        let
                            elementFilters =
                                Dict.fromList <|
                                    List.map (\x -> ( x, True )) labelsList

                            newOps =
                                Operations.setNodeFilters
                                    elementFilters
                                    model.operations

                            newSnapshots =
                                Snapshots.setNodeFilters elementFilters
                                    model.snapshots
                        in
                            ( { model
                                | operations = newOps
                                , snapshots = newSnapshots
                              }
                            , Cmd.none
                            )

                    Err error ->
                        ( { model
                            | errorMessage =
                                Just
                                    ("Cannot decode received node labels. -["
                                        ++ error
                                        ++ "]"
                                    )
                          }
                        , Cmd.none
                        )

        GetEdgeTypes ->
            let
                phxPush =
                    PhxPush.init "edge:types" channelName
                        |> PhxPush.onOk ReceiveEdgeTypes
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

        ReceiveEdgeTypes raw ->
            let
                decodedTypes =
                    Json.Decode.decodeValue ElementDecode.filterDecoder raw
            in
                case decodedTypes of
                    Ok typesList ->
                        let
                            elementFilters =
                                Dict.fromList <|
                                    List.map (\x -> ( x, True )) typesList

                            newOps =
                                Operations.setEdgeFilters
                                    elementFilters
                                    model.operations

                            newSnapshots =
                                Snapshots.setEdgeFilters
                                    elementFilters
                                    model.snapshots
                        in
                            ( { model
                                | operations = newOps
                                , snapshots = newSnapshots
                              }
                            , Cmd.none
                            )

                    Err error ->
                        errorMessage
                            ("Cannot decode received edge types. -["
                                ++ error
                                ++ "]"
                            )
                            model

        ToggleFilter NodeElt filterName ->
            let
                newOps =
                    Operations.toggleNodeFilterState filterName model.operations

                filteredElements =
                    Graph.getFilteredNodes filterName (Snapshots.getCurrent model.snapshots).graph

                visible =
                    Operations.getNodeFilterState filterName newOps

                cmd =
                    Ports.setVisibleElements <|
                        OperationsEncode.visibleElementsEncoder
                            NodeElt
                            filteredElements
                            visible
            in
                ( { model | operations = newOps }, cmd )

        ToggleFilter EdgeElt filterName ->
            let
                newOps =
                    Operations.toggleEdgeFilterState filterName model.operations

                filteredElements =
                    Graph.getFilteredEdges filterName (Snapshots.getCurrent model.snapshots).graph

                visible =
                    Operations.getEdgeFilterState filterName newOps

                cmd =
                    Ports.setVisibleElements <|
                        OperationsEncode.visibleElementsEncoder
                            EdgeElt
                            filteredElements
                            visible
            in
                ( { model | operations = newOps }, cmd )

        ResetFilters NodeElt ->
            let
                newOps =
                    Operations.resetNodeFilters model.operations
            in
                ( { model | operations = newOps }
                , Ports.setVisibleElements <|
                    OperationsEncode.visibleElementsEncoder
                        NodeElt
                        [ "all" ]
                        True
                )

        ResetFilters EdgeElt ->
            let
                newOps =
                    Operations.resetEdgeFilters model.operations
            in
                ( { model | operations = newOps }
                , Ports.setVisibleElements <|
                    OperationsEncode.visibleElementsEncoder
                        EdgeElt
                        [ "all" ]
                        True
                )


errorMessage : String -> Model -> ( Model, Cmd Msg )
errorMessage message model =
    ( { model | errorMessage = Just message }, Cmd.none )


updateBrowsedEdge : BrowsedElement -> Model -> Model
updateBrowsedEdge element model =
    let
        browsedEdge =
            Graph.getEdge element.id (Snapshots.getCurrent model.snapshots).graph

        newOps =
            Operations.setBrowsedEdge browsedEdge model.operations
    in
        { model | operations = newOps }


updateBrowsedNode : BrowsedElement -> Model -> Model
updateBrowsedNode element model =
    let
        browsedNode =
            Graph.getNode element.id (Snapshots.getCurrent model.snapshots).graph

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
