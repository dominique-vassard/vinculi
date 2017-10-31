module Decoders.Edge exposing (decoder)

import Json.Decode.Pipeline exposing (decode, required)
import Json.Decode as Decode exposing (Decoder, string)
import Types exposing (Edge, EdgeData)


decoder : Decoder Edge
decoder =
    Json.Decode.Pipeline.decode Edge
        |> required "data" dataDecoder


dataDecoder : Decoder EdgeData
dataDecoder =
    Json.Decode.Pipeline.decode EdgeData
        |> required "source" Decode.string
        |> required "target" Decode.string
        |> required "type" Decode.string
