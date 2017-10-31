module Encoders.Node exposing (encoder)

import Json.Encode as Encode exposing (Value, int, object, string)
import Types
    exposing
        ( Node
        , NodeData(Generic, Person, Publication, ValueNode)
        , CommonNodeData
        , GenericNodeData
        , PersonNodeData
        , PublicationNodeData
        , ValueNodeData
        )


encoder : Node -> Value
encoder node =
    Encode.object
        [ ( "data", dataEncoder node.data )
        , ( "classes", Encode.string node.classes )
        ]


dataEncoder : NodeData -> Value
dataEncoder nodeData =
    case nodeData of
        Person personData ->
            personEncoder personData

        Generic genericData ->
            genericEncoder genericData

        Publication publicationData ->
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
