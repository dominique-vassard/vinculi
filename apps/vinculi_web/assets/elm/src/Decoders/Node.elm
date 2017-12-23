module Decoders.Node exposing (decoder)

import Json.Decode.Pipeline exposing (decode, optional, required)
import Json.Decode as Decode
    exposing
        ( Decoder
        , andThen
        , float
        , list
        , map
        , nullable
        , string
        )
import Decoders.Common exposing (positionDecoder)
import Types
    exposing
        ( NodeType
        , NodeData
            ( GenericNode
            , InstitutionNode
            , LocationNode
            , PersonNode
            , PublicationNode
            , ValueNode
            )
        , GenericNodeData
        , InstitutionNodeData
        , LocationNodeData
        , PersonNodeData
        , PublicationNodeData
        , ValueNodeData
        , Position
        )


decoder : Decoder NodeType
decoder =
    Json.Decode.Pipeline.decode NodeType
        |> required "group" Decode.string
        |> required "data" dataDecoder
        |> optional "classes" Decode.string ""
        |> optional "position" positionDecoder (Position 0 0)
        |> optional "grabbable" Decode.bool True
        |> optional "locked" Decode.bool False
        |> optional "removed" Decode.bool False
        |> optional "selectable" Decode.bool True
        |> optional "selected" Decode.bool False


dataDecoder : Decoder NodeData
dataDecoder =
    Decode.field "labels" (Decode.list Decode.string)
        |> Decode.andThen dataDecoderHelper


dataDecoderHelper : List String -> Decoder NodeData
dataDecoderHelper labels =
    case labels of
        [ "Continent" ] ->
            locationDecoder

        [ "Country" ] ->
            locationDecoder

        [ "Institution" ] ->
            institutionDecoder

        [ "Person" ] ->
            personDecoder

        [ "Publication" ] ->
            publicationDecoder

        [ "Town" ] ->
            locationDecoder

        [ "Year" ] ->
            valueDecoder

        _ ->
            genericDecoder


commonDataDecoder : (String -> List String -> String -> Maybe String -> ntype) -> Decoder ntype
commonDataDecoder dataType =
    Json.Decode.Pipeline.decode dataType
        |> required "id" Decode.string
        |> required "labels" (Decode.list Decode.string)
        |> required "name" Decode.string
        |> optional "parent-node" (Decode.nullable Decode.string) Nothing


genericDecoder : Decoder NodeData
genericDecoder =
    genericDataDecoder
        |> Decode.map GenericNode


genericDataDecoder : Decoder GenericNodeData
genericDataDecoder =
    commonDataDecoder GenericNodeData


institutionDecoder : Decoder NodeData
institutionDecoder =
    institutionDataDecoder
        |> Decode.map InstitutionNode


institutionDataDecoder : Decoder InstitutionNodeData
institutionDataDecoder =
    commonDataDecoder InstitutionNodeData
        |> required "type" Decode.string


locationDecoder : Decoder NodeData
locationDecoder =
    locationDataDecoder
        |> Decode.map LocationNode


locationDataDecoder : Decoder LocationNodeData
locationDataDecoder =
    commonDataDecoder LocationNodeData
        |> optional "lat" (Decode.nullable Decode.float) Nothing
        |> optional "long" (Decode.nullable Decode.float) Nothing


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
        |> required "titleFr" Decode.string
        |> optional "internalLink" Decode.string ""
        |> optional "externalLink" Decode.string ""


valueDecoder : Decoder NodeData
valueDecoder =
    valueDataDecoder
        |> Decode.map ValueNode


valueDataDecoder : Decoder ValueNodeData
valueDataDecoder =
    commonDataDecoder ValueNodeData
        |> required "value" Decode.int
