module Main exposing (..)

import Html exposing (Html, button, div, form, input, li, span, text, ul)
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
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Types exposing (..)
import Ports exposing (..)
import Decoders.Graph as GraphDecode exposing (decoder)
import Decoders.Port as PortDecoder exposing (localGraphDecoder)
import Encoders.Graph as GraphEncode exposing (encoder)
import Accessors.Node as Node exposing (..)
import Accessors.Edge as Edge exposing (..)
import Task


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


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { phxSocket = PhxSocket.init flags.socketUrl
      , graph = Graph [] []
      , socketUrl = flags.socketUrl
      , initGraph = True
      , searchNode =
            Just
                { uuid = flags.originNodeUuid
                , labels = flags.originNodeLabels
                }
      , errorMessage = Nothing
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
            ( model, Ports.addToGraph (GraphEncode.encoder model.graph) )

        InitGraph ->
            ( model, Ports.initGraph (GraphEncode.encoder model.graph) )

        --Ports IN
        SetSearchNode (Ok searchNode) ->
            ( { model | searchNode = Just searchNode }
            , Task.perform (always GetNodeLocalGraph) (Task.succeed ())
            )

        SetSearchNode (Err searchNode) ->
            ( model, Cmd.none )

        -- Socket
        Join ->
            let
                channel =
                    PhxChannel.init channelName
                        |> PhxChannel.onJoin (always GetNodeLocalGraph)

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

        GetNodeLocalGraph ->
            case model.searchNode of
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
                    Json.Decode.decodeValue GraphDecode.decoder raw

                localGraphCmd =
                    case model.initGraph of
                        True ->
                            Task.perform (always InitGraph) (Task.succeed ())

                        False ->
                            Task.perform (always SendGraph) (Task.succeed ())
            in
                case decodedGraph of
                    Ok graph ->
                        ( { model
                            | graph = manageMetaData graph
                            , initGraph = False
                          }
                        , localGraphCmd
                        )

                    Err error ->
                        ( { model
                            | errorMessage =
                                Just "Cannot decode received graph."
                          }
                        , Cmd.none
                        )


manageMetaData : Graph -> Graph
manageMetaData graph =
    let
        nodes =
            List.map (\x -> addNodeClasses x) graph.nodes

        edges =
            graph.edges
                |> List.map (\edge -> addEdgeClasses edge)
    in
        { graph | nodes = nodes, edges = edges }


addNodeClasses : Node -> Node
addNodeClasses node =
    let
        classes =
            Node.getLabels node
                |> String.join ""
                |> String.toLower
    in
        { node | classes = classes }


addEdgeClasses : Edge -> Edge
addEdgeClasses edge =
    let
        classes =
            edge
                |> Edge.getType
                |> String.toLower
    in
        { edge | classes = classes }



--- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Ports.getLocalGraph
            (Json.Decode.decodeValue
                PortDecoder.localGraphDecoder
                >> SetSearchNode
            )
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
                [ span [] [ text "Control panel" ]
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
