module Main exposing (..)

import Html exposing (Html, button, div, form, input, li, span, text, ul)
import Html.Attributes exposing (class, id)
import Html.Events exposing (onClick, onInput, onSubmit)
import Json.Encode exposing (Value, object, string)
import Json.Decode exposing (field, decodeString, decodeValue, string)
import Ports exposing (..)
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
import Phoenix.Channel as PhxChannel exposing (init)
import Phoenix.Push as PhxPush exposing (init, onError, onOk, withPayload)


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


type alias Flags =
    { socket_url : String
    , source_node_uuid : String
    }


type alias Model =
    { number : Int
    , style : String
    , source_node_uuid : String
    , phxSocket : PhxSocket.Socket Msg
    , messageInProgress : String
    , messages : List String
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        channel =
            PhxChannel.init channelName

        ( phxSocket, phxCmd ) =
            PhxSocket.init flags.socket_url
                |> PhxSocket.withDebug
                |> PhxSocket.on "shout" channelName ReceiveMessage
                |> PhxSocket.join channel
    in
        ( { number = 1
          , style = ""
          , source_node_uuid = flags.source_node_uuid
          , phxSocket = phxSocket
          , messageInProgress = ""
          , messages = [ "Test messages" ]
          }
        , Cmd.map PhoenixMsg phxCmd
        )



-- UPDATE


type Msg
    = Increment
    | Decrement
    | Change String
    | ChangeStyle
    | CurrentStyle (Result String String)
    | ResetStyle (Result String String)
    | PhoenixMsg (PhxSocket.Msg Msg)
    | SetSocketMessage String
    | SendMessage
    | ReceiveMessage Json.Encode.Value
    | HandleSendError Json.Encode.Value


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increment ->
            ( { model | number = model.number + 1 }, Cmd.none )

        Decrement ->
            ( { model | number = model.number - 1 }, Cmd.none )

        Change newStyle ->
            ( { model | style = newStyle }, Cmd.none )

        ChangeStyle ->
            ( model, Ports.changeStyle model.style )

        CurrentStyle (Ok curStyle) ->
            ( { model | style = curStyle }, Cmd.none )

        CurrentStyle (Err err) ->
            ( model, Cmd.none )

        ResetStyle (Ok style) ->
            ( { model | style = style }, Cmd.none )

        ResetStyle (Err err) ->
            ( model, Cmd.none )

        PhoenixMsg msg ->
            let
                ( phxSocket, phxCmd ) =
                    PhxSocket.update msg model.phxSocket
            in
                ( { model | phxSocket = phxSocket }
                , Cmd.map PhoenixMsg phxCmd
                )

        SetSocketMessage msg ->
            ( { model | messageInProgress = msg }, Cmd.none )

        SendMessage ->
            let
                payload =
                    Json.Encode.object
                        [ ( "message"
                          , Json.Encode.string model.messageInProgress
                          )
                        ]

                phxPush =
                    PhxPush.init "shout" channelName
                        |> PhxPush.withPayload payload
                        |> PhxPush.onOk ReceiveMessage
                        |> PhxPush.onError HandleSendError

                ( phxSocket, phxCmd ) =
                    PhxSocket.push phxPush model.phxSocket
            in
                ( { model | phxSocket = phxSocket }, Cmd.map PhoenixMsg phxCmd )

        ReceiveMessage raw ->
            let
                messageDecoder =
                    Json.Decode.field "message" Json.Decode.string

                somePayload =
                    Json.Decode.decodeValue messageDecoder raw
            in
                case somePayload of
                    Ok message ->
                        ( { model | messages = message :: model.messages }
                        , Cmd.none
                        )

                    Err error ->
                        ( model, Cmd.none )

        HandleSendError _ ->
            ( { model | messages = "Failed to send message." :: model.messages }
            , Cmd.none
            )



--- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Ports.currentStyle (decodeStyle >> CurrentStyle)
        , Ports.resetStyle (decodeStyle >> ResetStyle)
        , PhxSocket.listen model.phxSocket PhoenixMsg
        ]


decodeStyle : Json.Decode.Value -> Result String String
decodeStyle =
    Json.Decode.decodeValue Json.Decode.string



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "row bg-silver rounded" ]
        [ div [ class "col-lg-9" ]
            [ button [ onClick Decrement ] [ text "-" ]
            , div [] [ text (toString model.number) ]
            , button [ onClick Increment ] [ text "+" ]
            , span [] [ text model.style ]
            , input [ onInput Change ] []
            , button [ onClick ChangeStyle ] [ text "change style" ]
            , button [ id "reset-style" ] [ text "reset style" ]
            , viewSocketTest model
            , div [ class "row border border-primary cy-graph", id "cy" ]
                []
            ]
        , div [ class "col-lg-3 bg-gray rounded-right" ]
            [ span [] [ text "Control panel" ]
            ]
        ]


viewSocketTest : Model -> Html Msg
viewSocketTest model =
    div [ class " border border-danger" ]
        [ ul [] (model.messages |> List.map drawMessage)
        , form [ onSubmit SendMessage ]
            [ input [ onInput SetSocketMessage ]
                []
            , button []
                [ text "Submit"
                ]
            ]
        ]


drawMessage : String -> Html Msg
drawMessage message =
    li []
        [ text message
        ]