module Encoders.Node exposing (encoder)

import Json.Encode as Encode exposing (Value, bool, int, object, string)
import Types
    exposing
        ( NodeType
        , NodeData(GenericNode, PersonNode, PublicationNode, ValueNode)
        , CommonNodeData
        , GenericNodeData
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
        PersonNode personData ->
            personEncoder personData

        GenericNode genericData ->
            genericEncoder genericData

        PublicationNode publicationData ->
            publicationEncoder publicationData

        ValueNode valueData ->
            valueEncoder valueData


commonEncoder : CommonNodeData a -> List ( String, Value )
commonEncoder data =
    [ ( "id", Encode.string data.id )
    , ( "labels", Encode.list (List.map Encode.string data.labels) )
    , ( "name", Encode.string data.name )
    ]


genericEncoder : GenericNodeData -> Encode.Value
genericEncoder genericData =
    Encode.object (commonEncoder genericData)


personEncoder : PersonNodeData -> Encode.Value
personEncoder personData =
    Encode.object
        (commonEncoder personData
            ++ [ ( "firstName", Encode.string personData.firstName )
               , ( "lastName", Encode.string personData.lastName )
               ]
        )


publicationEncoder : PublicationNodeData -> Encode.Value
publicationEncoder publicationData =
    Encode.object
        (commonEncoder publicationData
            ++ [ ( "title", Encode.string publicationData.title ) ]
        )


valueEncoder : ValueNodeData -> Encode.Value
valueEncoder valueData =
    Encode.object
        (commonEncoder valueData
            ++ [ ( "value", Encode.int valueData.value ) ]
        )
