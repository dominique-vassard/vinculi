module Decoders.Edge exposing (decoder)

import Json.Decode.Pipeline exposing (decode, optional, required, hardcoded)
import Json.Decode as Decode exposing (Decoder, nullable, string)
import Types
    exposing
        ( EdgeType
        , EdgeData(GenericEdge, InfluencedEdge)
        , GenericEdgeData
        , InfluencedEdgeData
        , Position
        )


decoder : Decoder EdgeType
decoder =
    Json.Decode.Pipeline.decode EdgeType
        |> required "group" Decode.string
        |> required "data" dataDecoder
        |> optional "classes" Decode.string ""
        |> hardcoded Nothing
        |> optional "grabbable" Decode.bool True
        |> optional "locked" Decode.bool False
        |> optional "removed" Decode.bool False
        |> optional "selectable" Decode.bool True
        |> optional "selected" Decode.bool False


dataDecoder : Decoder EdgeData
dataDecoder =
    Decode.field "type" Decode.string
        |> Decode.andThen dataDecoderHelper


dataDecoderHelper : String -> Decoder EdgeData
dataDecoderHelper edge_type =
    case edge_type of
        "INFLUENCED" ->
            influencedDecoder

        _ ->
            genericDecoder


commonDataDecoder : (String -> String -> String -> String -> e_type) -> Decoder e_type
commonDataDecoder dataType =
    Json.Decode.Pipeline.decode dataType
        |> required "id" Decode.string
        |> required "source" Decode.string
        |> required "target" Decode.string
        |> required "type" Decode.string


genericDecoder : Decoder EdgeData
genericDecoder =
    genericDataDecoder
        |> Decode.map GenericEdge


genericDataDecoder : Decoder GenericEdgeData
genericDataDecoder =
    commonDataDecoder GenericEdgeData


influencedDecoder : Decoder EdgeData
influencedDecoder =
    influencedDataDecoder
        |> Decode.map InfluencedEdge


influencedDataDecoder : Decoder InfluencedEdgeData
influencedDataDecoder =
    commonDataDecoder InfluencedEdgeData
        |> required "strength" Decode.int
