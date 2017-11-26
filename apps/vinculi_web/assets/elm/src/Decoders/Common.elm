module Decoders.Common exposing (..)

import Json.Decode.Pipeline exposing (decode, optional, required)
import Json.Decode as Decode exposing (Decoder, float)
import Types
    exposing
        ( Position
        )


positionDecoder : Decoder Position
positionDecoder =
    Json.Decode.Pipeline.decode Position
        |> required "x" Decode.float
        |> required "y" Decode.float
