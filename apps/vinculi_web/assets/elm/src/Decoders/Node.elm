module Decoders.Node exposing (decoder)

import Json.Decode.Pipeline exposing (decode, optional, required)
import Json.Decode as Decode exposing (Decoder, andThen, list, map, string)
import Types
    exposing
        ( Node
        , NodeData(GenericNode, PersonNode, PublicationNode, ValueNode)
        , GenericNodeData
        , PersonNodeData
        , PublicationNodeData
        , ValueNodeData
        )


decoder : Decoder Node
decoder =
    Json.Decode.Pipeline.decode Node
        |> required "data" dataDecoder
        |> optional "classes" Decode.string ""


dataDecoder : Decoder NodeData
dataDecoder =
    Decode.field "labels" (Decode.list Decode.string)
        |> Decode.andThen dataDecoderHelper


dataDecoderHelper : List String -> Decoder NodeData
dataDecoderHelper labels =
    case labels of
        [ "Year" ] ->
            valueDecoder

        [ "Person" ] ->
            personDecoder

        [ "Publication" ] ->
            publicationDecoder

        _ ->
            genericDecoder


commonDataDecoder : (String -> List String -> String -> ntype) -> Decoder ntype
commonDataDecoder dataType =
    Json.Decode.Pipeline.decode dataType
        |> required "id" Decode.string
        |> required "labels" (Decode.list Decode.string)
        |> required "name" Decode.string


genericDecoder : Decoder NodeData
genericDecoder =
    genericDataDecoder
        |> Decode.map GenericNode


genericDataDecoder : Decoder GenericNodeData
genericDataDecoder =
    commonDataDecoder GenericNodeData


personDecoder : Decoder NodeData
personDecoder =
    personDataDecoder
        |> Decode.map PersonNode


personDataDecoder : Decoder PersonNodeData
personDataDecoder =
    commonDataDecoder PersonNodeData
        |> required "lastName" Decode.string
        |> required "firstName" Decode.string
        |> optional "aka" Decode.string ""
        |> optional "internalLink" Decode.string ""
        |> optional "externalLink" Decode.string ""


publicationDecoder : Decoder NodeData
publicationDecoder =
    publicationDataDecoder
        |> Decode.map PublicationNode


publicationDataDecoder : Decoder PublicationNodeData
publicationDataDecoder =
    commonDataDecoder PublicationNodeData
        |> required "title" Decode.string


valueDecoder : Decoder NodeData
valueDecoder =
    valueDataDecoder
        |> Decode.map ValueNode


valueDataDecoder : Decoder ValueNodeData
valueDataDecoder =
    commonDataDecoder ValueNodeData
        |> required "value" Decode.int
