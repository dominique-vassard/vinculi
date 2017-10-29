port module Ports exposing (..)

import Json.Decode exposing (Decoder)
import Json.Encode exposing (Value)


--import Types exposing (..)
--- OUT PORTS


port changeStyle : String -> Cmd msg


port newGraph : Json.Encode.Value -> Cmd msg



--- INPUT PORTS


port currentStyle : (Json.Decode.Value -> msg) -> Sub msg


port resetStyle : (Json.Decode.Value -> msg) -> Sub msg
