module Decoders.Port exposing (localGraphDecoder)

import Json.Decode.Pipeline exposing (decode, required)
import Json.Decode as Decode exposing (Decoder, list, string)
import Types exposing (SearchNodeType)


localGraphDecoder : Decoder SearchNodeType
localGraphDecoder =
    Json.Decode.Pipeline.decode SearchNodeType
        |> required "uuid" Decode.string
        |> required "labels" (Decode.list Decode.string)
