module Main exposing (..)

import Html exposing (Html, button, div, h5, span, text)
import Html.Attributes exposing (class, id)
import Json.Encode exposing (Value, object, string)
import Json.Decode exposing (field, decodeString, decodeValue, string, Decoder)
import Phoenix.Socket as PhxSocket
    exposing
        ( init
        , join
        , listen
        , on
        , push
        , update
        , withDebug
        )
import Phoenix.Channel as PhxChannel exposing (init, onJoin)
import Phoenix.Push as PhxPush exposing (init, onError, onOk, withPayload)
import Bootstrap.Alert as Alert
import Bootstrap.Card as Card
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Row as Row
import Bootstrap.Grid.Col as Col
import Task
import Types exposing (..)
import Ports exposing (..)
import Decoders.Graph as GraphDecode exposing (fromWsDecoder)
import Decoders.Port as PortDecoder exposing (localGraphDecoder)
import Decoders.Snapshot as Snapshot exposing (decoder)
import Encoders.Common as GraphEncode exposing (userEncoder)
import Encoders.Graph as GraphEncode exposing (encoder)
import Accessors.Node as Node exposing (..)
import Accessors.Edge as Edge exposing (..)
import Accessors.Graph as Graph exposing (..)
import Accessors.Operations as Operations exposing (..)
import Utils.ZipList as ZipList exposing (..)


main : Program Flags Model Msg
main =
    Html.programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
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

        SetBrowsedNode (Ok nodeUuid) ->
            let
                filtered_node =
                    List.head <|
                        List.filter
                            (\x ->
                                case x of
                                    Node node ->
                                        (Node.getGenericData node).id == nodeUuid

                                    Edge _ ->
                                        False
                            )
                            (ZipList.current model.snapshots).graph

                node =
                    case filtered_node of
                        Just (Node node) ->
                            Just node

                        _ ->
                            Nothing

                newOps =
                    Operations.setBrowsedNode node model.operations
            in
                ( { model | operations = newOps }, Cmd.none )

        SetBrowsedNode (Err error) ->
            ( { model
                | errorMessage =
                    Just ("Failed to set browsedNode: " ++ error)
              }
            , Cmd.none
            )

        UnsetBrowsedNode _ ->
            let
                newOps =
                    Operations.setBrowsedNode Nothing model.operations
            in
                ( { model | operations = newOps }, Cmd.none )

        PinNode True ->
            let
                newOps =
                    (Operations.setPinnedNode
                        model.operations.node.browsed
                        model.operations
                    )
            in
                ( { model | operations = newOps }, Cmd.none )

        PinNode False ->
            let
                newOps =
                    Operations.setPinnedNode Nothing model.operations
            in
                ( { model | operations = newOps }, Cmd.none )

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
                                substractGraph graph
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
                                        (manageMetaData
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


substractGraph : Graph -> Graph -> Graph
substractGraph receivedGraph graph =
    List.filter
        (\x ->
            not (Graph.elementOf x graph)
        )
        receivedGraph


manageMetaData : Maybe SearchNodeType -> Graph -> Graph
manageMetaData parentNode graph =
    List.map (addClass >> (setParentNode parentNode)) graph


setParentNode : Maybe SearchNodeType -> Element -> Element
setParentNode parentNode element =
    case element of
        Node node ->
            case parentNode of
                Just parentNode ->
                    if parentNode.uuid == (Node.getGenericData node).id then
                        Node node
                    else
                        let
                            nodeData =
                                node.data

                            newNodeData =
                                Node.setParentNode (Just parentNode.uuid) node.data
                        in
                            Node { node | data = newNodeData }

                Nothing ->
                    Node node

        element ->
            element


addClass : Element -> Element
addClass element =
    case element of
        Node node ->
            addNodeClasses node

        Edge edge ->
            addEdgeClasses edge


addNodeClasses : NodeType -> Element
addNodeClasses node =
    let
        classes =
            Node.getLabels node
                |> String.join ""
                |> String.toLower
    in
        Node { node | classes = classes }


addEdgeClasses : EdgeType -> Element
addEdgeClasses edge =
    let
        classes =
            edge
                |> Edge.getType
                |> String.toLower
    in
        Edge { edge | classes = classes }



--- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Ports.getLocalGraph
            (Json.Decode.decodeValue
                PortDecoder.localGraphDecoder
                >> SetSearchNode
            )
        , Ports.newGraphState
            (Json.Decode.decodeValue Snapshot.decoder
                >> SetGraphState
            )
        , Ports.displayNodeInfos
            ((Json.Decode.decodeValue Json.Decode.string)
                >> SetBrowsedNode
            )
        , Ports.hideNodeInfos UnsetBrowsedNode
        , Ports.pinNodeInfos PinNode
        , PhxSocket.listen model.phxSocket PhoenixMsg
        ]



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ viewError model.errorMessage
        , div [ class "row bg-silver rounded fill" ]
            [ div
                [ class "col-lg-9" ]
                [ div [ class "row border border-primary cy-graph", id "cy" ]
                    []
                ]
            , div [ class "col-lg-3 bg-gray rounded-right" ]
                [ Grid.row [ Row.attrs [ class "rounded bg-secondary" ] ]
                    [ Grid.col [ Col.lg12 ] [ text "Browse" ] ]
                , Grid.row []
                    [ Grid.col [ Col.lg12 ]
                        [ viewNodeData <| nodeToDisplay model.operations.node
                        ]
                    ]
                ]
            ]
        ]


viewError : Maybe String -> Html Msg
viewError errorMessage =
    let
        div_ =
            case errorMessage of
                Nothing ->
                    div [] []

                Just errorMsg ->
                    Grid.row []
                        [ Grid.col [ Col.lg12 ]
                            [ Alert.danger [ text errorMsg ] ]
                        ]
    in
        div_


nodeToDisplay : NodeOperations -> Maybe NodeType
nodeToDisplay currentNode =
    case currentNode.browsed of
        Just node ->
            Just node

        Nothing ->
            currentNode.pinned


viewNodeData : Maybe NodeType -> Html Msg
viewNodeData nodetoDisplay =
    let
        dataToDisplay =
            case nodetoDisplay of
                Nothing ->
                    div [] []

                Just node ->
                    case node.data of
                        GenericNode nodeData ->
                            viewGenericNodeData nodeData

                        PersonNode nodeData ->
                            viewPersonNodeData nodeData

                        PublicationNode nodeData ->
                            viewPublicationNodeData nodeData

                        ValueNode nodeData ->
                            viewValueNodeData nodeData
    in
        Card.config []
            |> Card.header [ class "text-center" ]
                [ h5 [] [ text "Node infos" ] ]
            |> Card.block [ Card.blockAttrs [ class "node-infos" ] ]
                [ Card.text [] [ dataToDisplay ] ]
            |> Card.view


viewGenericNodeData : GenericNodeData -> Html Msg
viewGenericNodeData nodeData =
    div []
        [ viewNodeLabel nodeData.labels ]


viewPersonNodeData : PersonNodeData -> Html Msg
viewPersonNodeData nodeData =
    div []
        [ viewNodeLabel nodeData.labels
        , viewInfoLine "Prénom" nodeData.firstName
        , viewInfoLine "Nom" nodeData.lastName
        , viewInfoLine "Pseudonymes" nodeData.aka
        , viewInfoLine "Lien Ars Margica" nodeData.internalLink
        , viewInfoLine "Lien externe" nodeData.externalLink
        ]


viewPublicationNodeData : PublicationNodeData -> Html Msg
viewPublicationNodeData nodeData =
    div []
        [ viewNodeLabel nodeData.labels
        , viewInfoLine "Titre" nodeData.title

        --, viewInfoLine "Lien Ars Margica" nodeData.titleFr
        --, viewInfoLine "Lien Ars Margica" nodeData.internalLink
        --, viewInfoLine "Lien externe" nodeData.externalLink
        ]


viewValueNodeData : ValueNodeData -> Html Msg
viewValueNodeData nodeData =
    div []
        [ viewNodeLabel nodeData.labels
        , viewInfoLine "Valeur" <| toString nodeData.value
        ]


viewNodeLabel : List String -> Html Msg
viewNodeLabel labels =
    viewInfoLine "Label" (String.join "," labels)


viewInfoLine : String -> String -> Html Msg
viewInfoLine label value =
    Grid.row []
        [ Grid.col [ Col.lg ] [ text <| label ++ ": " ]
        , Grid.col [ Col.lg8 ] [ text <| value ]
        ]
