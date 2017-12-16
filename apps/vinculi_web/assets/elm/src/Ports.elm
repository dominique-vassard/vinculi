port module Ports exposing (..)

import Json.Decode exposing (Decoder)
import Json.Encode exposing (Value)


--- OUT PORTS


port initGraph : Json.Encode.Value -> Cmd msg


port addToGraph : Json.Encode.Value -> Cmd msg



-- {elementType, idList, visible}


port setVisibleElements : Json.Encode.Value -> Cmd msg



--- INPUT PORTS


port getLocalGraph : (Json.Decode.Value -> msg) -> Sub msg


port newGraphState : (Json.Decode.Value -> msg) -> Sub msg


port hideElementInfos : (Json.Decode.Value -> msg) -> Sub msg


port pinNodeInfos : (Bool -> msg) -> Sub msg


port pinElementInfos : (Json.Decode.Value -> msg) -> Sub msg


port displayElementInfos : (Json.Decode.Value -> msg) -> Sub msg
