port module Main exposing (..)

import Html exposing (Html, button, div, text, span, input)
import Html.Attributes exposing (class, id)
import Html.Events exposing (onClick, onInput)


main : Program Never Model Msg
main =
    Html.program { init = init, view = view, update = update, subscriptions = subscriptions }



-- MODEL


type alias Model =
    { number : Int
    , style : String
    }


init : ( Model, Cmd Msg )
init =
    ( { number = 1
      , style = ""
      }
    , Cmd.none
    )



-- UPDATE


port changeStyle : String -> Cmd msg


type Msg
    = Increment
    | Decrement
    | Change String
    | ChangeStyle
    | CurrentStyle String
    | ResetStyle String


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
            ( model, changeStyle model.style )

        CurrentStyle curStyle ->
            ( { model | style = curStyle }, Cmd.none )

        ResetStyle style ->
            ( { model | style = style }, Cmd.none )



--- SUBSCRIPTIONS


port currentStyle : (String -> msg) -> Sub msg


port resetStyle : (String -> msg) -> Sub msg


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ currentStyle CurrentStyle
        , resetStyle ResetStyle
        ]



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
            , div [ class "row border border-primary cy-graph", id "cy" ]
                []
            ]
        , div [ class "col-lg-3 bg-gray rounded-right" ] [ span [] [ text "Control panel" ] ]
        ]
