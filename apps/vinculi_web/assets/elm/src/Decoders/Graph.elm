module Decoders.Graph exposing (decoder, fromWsDecoder)

import Json.Decode exposing (Decoder, andThen, field, list, string)
import Types exposing (Graph, Element(Node, Edge))
import Decoders.Node as Node exposing (decoder)
import Decoders.Edge as Edge exposing (decoder)


fromWsDecoder : Decoder Graph
fromWsDecoder =
    Json.Decode.field "data" decoder


decoder : Decoder Graph
decoder =
    Json.Decode.list elementDecoder


elementDecoder : Decoder Element
elementDecoder =
    Json.Decode.field "group" Json.Decode.string
        |> Json.Decode.andThen elementTypeDecoder


elementTypeDecoder : String -> Decoder Element
elementTypeDecoder elementType =
    case elementType of
        "nodes" ->
            nodeDecoder

        "edges" ->
            edgeDecoder

        _ ->
            Debug.crash "BOOM!"


nodeDecoder : Decoder Element
nodeDecoder =
    Node.decoder
        |> Json.Decode.map Node


edgeDecoder : Decoder Element
edgeDecoder =
    Edge.decoder
        |> Json.Decode.map Edge
