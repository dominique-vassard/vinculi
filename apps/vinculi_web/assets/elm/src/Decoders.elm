module Decoders exposing (graphDecoder)

import Json.Decode exposing (field, decodeString, decodeValue, string, Decoder)
import Json.Decode.Pipeline exposing (decode, required, optional)
import Types exposing (..)


graphDecoder : Decoder Graph
graphDecoder =
    Json.Decode.Pipeline.decode Graph
        |> required "nodes" (Json.Decode.list nodeDecoder)
        |> required "edges" (Json.Decode.list edgeDecoder)


nodeDecoder : Decoder Node
nodeDecoder =
    Json.Decode.Pipeline.decode Node
        |> required "data" nodeDataDecoder
        |> optional "classes" Json.Decode.string ""


nodeDataDecoder : Decoder NodeData
nodeDataDecoder =
    Json.Decode.field "labels" (Json.Decode.list Json.Decode.string)
        |> Json.Decode.andThen nodeDataDecoderHelper


nodeDataDecoderHelper : List String -> Decoder NodeData
nodeDataDecoderHelper labels =
    case labels of
        [ "Year" ] ->
            valueDecoder

        [ "Person" ] ->
            personDecoder

        [ "Publication" ] ->
            publicationDecoder

        _ ->
            genericDecoder


genericDecoder : Decoder NodeData
genericDecoder =
    genericNodeDataDecoder
        |> Json.Decode.map Generic


genericNodeDataDecoder : Decoder GenericNodeData
genericNodeDataDecoder =
    genericDataDecoder GenericNodeData


genericDataDecoder : (String -> List String -> String -> node_type) -> Decoder node_type
genericDataDecoder dataType =
    Json.Decode.Pipeline.decode dataType
        |> required "id" Json.Decode.string
        |> required "labels" (Json.Decode.list Json.Decode.string)
        |> required "name" Json.Decode.string


personDecoder : Decoder NodeData
personDecoder =
    personNodeDataDecoder
        |> Json.Decode.map Person


personNodeDataDecoder : Decoder PersonNodeData
personNodeDataDecoder =
    genericDataDecoder PersonNodeData
        |> required "lastName" Json.Decode.string
        |> required "firstName" Json.Decode.string
        |> optional "aka" Json.Decode.string ""
        |> optional "internalLink" Json.Decode.string ""
        |> optional "externalLink" Json.Decode.string ""


valueDecoder : Decoder NodeData
valueDecoder =
    valueNodeDataDecoder
        |> Json.Decode.map ValueNode


valueNodeDataDecoder : Decoder ValueNodeData
valueNodeDataDecoder =
    genericDataDecoder ValueNodeData
        |> required "value" Json.Decode.int


publicationDecoder : Decoder NodeData
publicationDecoder =
    publicationNodeDataDecoder
        |> Json.Decode.map Publication


publicationNodeDataDecoder : Decoder PublicationNodeData
publicationNodeDataDecoder =
    genericDataDecoder PublicationNodeData
        |> required "title" Json.Decode.string


edgeDecoder : Decoder Edge
edgeDecoder =
    Json.Decode.Pipeline.decode Edge
        |> required "data" edgeDataDecoder


edgeDataDecoder : Decoder EdgeData
edgeDataDecoder =
    Json.Decode.Pipeline.decode EdgeData
        |> required "source" Json.Decode.string
        |> required "target" Json.Decode.string
        |> required "type" Json.Decode.string
