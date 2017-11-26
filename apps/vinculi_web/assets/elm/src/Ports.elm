port module Ports exposing (..)

import Json.Decode exposing (Decoder)
import Json.Encode exposing (Value)


--- OUT PORTS


port initGraph : Json.Encode.Value -> Cmd msg


port addToGraph : Json.Encode.Value -> Cmd msg



--- INPUT PORTS


port getLocalGraph : (Json.Decode.Value -> msg) -> Sub msg


port newGraphState : (Json.Decode.Value -> msg) -> Sub msg


port displayNodeInfos : (Json.Decode.Value -> msg) -> Sub msg
