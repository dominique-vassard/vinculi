module Decoders.Edge exposing (decoder)

import Json.Decode.Pipeline exposing (decode, required)
import Json.Decode as Decode exposing (Decoder, string)
import Types
    exposing
        ( Edge
        , EdgeData(GenericEdge, InfluencedEdge)
        , GenericEdgeData
        , InfluencedEdgeData
        )


decoder : Decoder Edge
decoder =
    Json.Decode.Pipeline.decode Edge
        |> required "data" dataDecoder


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


commonDataDecoder : (String -> String -> String -> e_type) -> Decoder e_type
commonDataDecoder dataType =
    Json.Decode.Pipeline.decode dataType
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
