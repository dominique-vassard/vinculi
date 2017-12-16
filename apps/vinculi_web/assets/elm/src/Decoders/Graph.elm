module Decoders.Graph exposing (decoder, fromWsDecoder, snapshotDecoder)

import Json.Decode as Decode exposing (Decoder, andThen, fail, field, list, string)
import Json.Decode.Pipeline exposing (decode, required)
import Types exposing (Graph, GraphSnapshot, Element(Node, Edge))
import Decoders.Node as Node exposing (decoder)
import Decoders.Edge as Edge exposing (decoder)


fromWsDecoder : Decoder Graph
fromWsDecoder =
    Decode.field "data" decoder


decoder : Decoder Graph
decoder =
    Decode.list elementDecoder


elementDecoder : Decoder Element
elementDecoder =
    Decode.field "group" Decode.string
        |> Decode.andThen elementTypeDecoder


elementTypeDecoder : String -> Decoder Element
elementTypeDecoder elementType =
    case elementType of
        "nodes" ->
            nodeDecoder

        "edges" ->
            edgeDecoder

        something ->
            Decode.fail <| "Not a valid element type: " ++ something


nodeDecoder : Decoder Element
nodeDecoder =
    Node.decoder
        |> Decode.map Node


edgeDecoder : Decoder Element
edgeDecoder =
    Edge.decoder
        |> Decode.map Edge


snapshotDecoder : Decoder GraphSnapshot
snapshotDecoder =
    Json.Decode.Pipeline.decode GraphSnapshot
        |> required "data" decoder
        |> required "description" Decode.string
