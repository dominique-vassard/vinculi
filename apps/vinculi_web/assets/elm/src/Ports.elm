port module Ports exposing (..)

import Json.Decode exposing (Decoder)
import Types exposing (..)


--- OUT PORTS


port changeStyle : String -> Cmd msg



-- Here is the next funny things to do to make it work:
--   https://stackoverflow.com/questions/37999504/how-to-pass-union-types-through-elm-ports


port newGraph : Graph -> Cmd msg



--- INPUT PORTS


port currentStyle : (Json.Decode.Value -> msg) -> Sub msg


port resetStyle : (Json.Decode.Value -> msg) -> Sub msg
