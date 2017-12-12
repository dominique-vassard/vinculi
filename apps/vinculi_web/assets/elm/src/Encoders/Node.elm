module Encoders.Node exposing (encoder)

import Json.Encode as Encode exposing (Value, bool, int, object, string, null)
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
        , CommonNodeData
        , GenericNodeData
        , InstitutionNodeData
        , LocationNodeData
        , PersonNodeData
        , PublicationNodeData
        , ValueNodeData
        )
import Encoders.Common exposing (positionEncoder)


encoder : NodeType -> Value
encoder node =
    Encode.object
        [ ( "group", Encode.string node.group )
        , ( "data", dataEncoder node.data )
        , ( "classes", Encode.string node.classes )
        , ( "position", positionEncoder node.position )
        , ( "grabbable", Encode.bool node.grabbable )
        , ( "locked", Encode.bool node.locked )
        , ( "removed", Encode.bool node.removed )
        , ( "selectable", Encode.bool node.selectable )
        , ( "selected", Encode.bool node.selected )
        ]


dataEncoder : NodeData -> Value
dataEncoder nodeData =
    case nodeData of
        GenericNode genericData ->
            genericEncoder genericData

        InstitutionNode institutionData ->
            institutionEncoder institutionData

        LocationNode locationData ->
            locationEncoder locationData

        PersonNode personData ->
            personEncoder personData

        PublicationNode publicationData ->
            publicationEncoder publicationData

        ValueNode valueData ->
            valueEncoder valueData


commonEncoder : CommonNodeData a -> List ( String, Value )
commonEncoder data =
    [ ( "id", Encode.string data.id )
    , ( "labels", Encode.list (List.map Encode.string data.labels) )
    , ( "name", Encode.string data.name )
    , ( "parent-node", (maybeStringEncoder data.parentNode) )
    ]


maybeStringEncoder : Maybe String -> Encode.Value
maybeStringEncoder str =
    case str of
        Just str ->
            Encode.string str

        Nothing ->
            Encode.null


genericEncoder : GenericNodeData -> Encode.Value
genericEncoder genericData =
    Encode.object (commonEncoder genericData)


institutionEncoder : InstitutionNodeData -> Encode.Value
institutionEncoder institutionData =
    Encode.object
        (commonEncoder institutionData
            ++ [ ( "type", Encode.string institutionData.institution_type ) ]
        )


locationEncoder : LocationNodeData -> Encode.Value
locationEncoder locationData =
    let
        latData =
            case locationData.lat of
                Just lat ->
                    [ ( "lat", Encode.float lat ) ]

                Nothing ->
                    []

        longData =
            case locationData.long of
                Just long ->
                    [ ( "long", Encode.float long ) ]

                Nothing ->
                    []
    in
        Encode.object
            (commonEncoder locationData
                ++ latData
                ++ longData
            )


personEncoder : PersonNodeData -> Encode.Value
personEncoder personData =
    Encode.object
        (commonEncoder personData
            ++ [ ( "firstName", Encode.string personData.firstName )
               , ( "lastName", Encode.string personData.lastName )
               , ( "aka", Encode.string personData.aka )
               , ( "internalLink", Encode.string personData.internalLink )
               , ( "externalLink", Encode.string personData.externalLink )
               ]
        )


publicationEncoder : PublicationNodeData -> Encode.Value
publicationEncoder publicationData =
    Encode.object
        (commonEncoder publicationData
            ++ [ ( "title", Encode.string publicationData.title )
               , ( "titleFr", Encode.string publicationData.titleFr )
               , ( "internalLink", Encode.string publicationData.internalLink )
               , ( "externalLink", Encode.string publicationData.externalLink )
               ]
        )


valueEncoder : ValueNodeData -> Encode.Value
valueEncoder valueData =
    Encode.object
        (commonEncoder valueData
            ++ [ ( "value", Encode.int valueData.value ) ]
        )
