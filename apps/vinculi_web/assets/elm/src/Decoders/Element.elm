module Decoders.Element
    exposing
        ( browsedDecoder
        , elementTypeDecoder
        , filterDecoder
        , pinnedDecoder
        )

import Json.Decode.Pipeline exposing (decode, required)
import Json.Decode as Decode
    exposing
        ( Decoder
        , bool
        , fail
        , list
        , string
        , succeed
        )
import Types
    exposing
        ( BrowsedElement
        , PinnedElement
        , ElementType(NodeElt, EdgeElt)
        )


browsedDecoder : Decoder BrowsedElement
browsedDecoder =
    Json.Decode.Pipeline.decode BrowsedElement
        |> required "id" Decode.string
        |> required "elementType" elementTypeDecoder


pinnedDecoder : Decoder PinnedElement
pinnedDecoder =
    Json.Decode.Pipeline.decode PinnedElement
        |> required "elementType" elementTypeDecoder
        |> required "pin" Decode.bool


filterDecoder : Decoder (List String)
filterDecoder =
    Decode.field "data" (Decode.list Decode.string)


elementTypeDecoder : Decoder ElementType
elementTypeDecoder =
    Decode.string
        |> Decode.andThen decodeElementType


decodeElementType : String -> Decoder ElementType
decodeElementType elementType =
    case elementType of
        "node" ->
            Decode.succeed NodeElt

        "edge" ->
            Decode.succeed EdgeElt

        unknownType ->
            Decode.fail <| "Unknown type: " ++ unknownType
