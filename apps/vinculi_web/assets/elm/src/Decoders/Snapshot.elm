module Decoders.Snapshot exposing (decoder)

import Json.Decode as Decode exposing (Decoder, string)
import Json.Decode.Pipeline exposing (decode, required)
import Types exposing (Snapshot)
import Decoders.Graph as GraphDecoder exposing (decoder)


todo : String
todo =
    "hello"
