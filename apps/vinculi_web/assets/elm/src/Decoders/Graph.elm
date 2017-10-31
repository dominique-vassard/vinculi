module Decoders.Graph exposing (decoder)

import Json.Decode.Pipeline exposing (decode, required)
import Json.Decode exposing (Decoder, list)
import Types exposing (Graph)
import Decoders.Node as Node exposing (decoder)
import Decoders.Edge as Edge exposing (decoder)


decoder : Decoder Graph
decoder =
    Json.Decode.Pipeline.decode Graph
        |> required "nodes" (Json.Decode.list Node.decoder)
        |> required "edges" (Json.Decode.list Edge.decoder)
