port module Ports exposing (..)

import Json.Decode exposing (Decoder)
import Types exposing (..)


--- OUT PORTS


port changeStyle : String -> Cmd msg


port newGraph : Graph -> Cmd msg



--- INPUT PORTS


port currentStyle : (Json.Decode.Value -> msg) -> Sub msg


port resetStyle : (Json.Decode.Value -> msg) -> Sub msg
