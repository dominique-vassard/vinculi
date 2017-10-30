module Encoders exposing (graphEncoder)

import Json.Encode exposing (Value, object, string)
import Types exposing (..)


graphEncoder : Graph -> Json.Encode.Value
graphEncoder graph =
    Json.Encode.object
        [ ( "nodes", Json.Encode.list (List.map nodeEncoder graph.nodes) )
        , ( "edges", Json.Encode.list (List.map edgeEncoder graph.edges) )
        ]


nodeEncoder : Node -> Json.Encode.Value
nodeEncoder node =
    Json.Encode.object
        [ ( "data", nodeDataEncoder node.data )
        ]


nodeDataEncoder : NodeData -> Json.Encode.Value
nodeDataEncoder nodeData =
    case nodeData of
        Person personData ->
            personEncoder personData

        Generic genericData ->
            genericEncoder genericData

        Publication publicationData ->
            publicationEncoder publicationData

        ValueNode valueData ->
            valueEncoder valueData


personEncoder : PersonNodeData -> Json.Encode.Value
personEncoder personData =
    Json.Encode.object
        (genericDataEncoder personData
            ++ [ ( "firstName", Json.Encode.string personData.firstName )
               , ( "lastName", Json.Encode.string personData.lastName )
               ]
        )


genericEncoder : GenericNodeData -> Json.Encode.Value
genericEncoder genericData =
    Json.Encode.object (genericDataEncoder genericData)


genericDataEncoder : GenericData a -> List ( String, Value )
genericDataEncoder data =
    [ ( "id", Json.Encode.string data.id )
    , ( "labels", Json.Encode.list (List.map Json.Encode.string data.labels) )
    , ( "name", Json.Encode.string data.name )
    ]


valueEncoder : ValueNodeData -> Json.Encode.Value
valueEncoder valueData =
    Json.Encode.object
        (genericDataEncoder valueData
            ++ [ ( "value", Json.Encode.int valueData.value ) ]
        )


publicationEncoder : PublicationNodeData -> Json.Encode.Value
publicationEncoder publicationData =
    Json.Encode.object
        (genericDataEncoder publicationData
            ++ [ ( "title", Json.Encode.string publicationData.title ) ]
        )


edgeEncoder : Edge -> Json.Encode.Value
edgeEncoder edge =
    Json.Encode.object
        [ ( "data", edgeDataEncoder edge.data )
        ]


edgeDataEncoder : EdgeData -> Json.Encode.Value
edgeDataEncoder edgeData =
    Json.Encode.object
        [ ( "source", Json.Encode.string edgeData.source )
        , ( "target", Json.Encode.string edgeData.target )
        , ( "type", Json.Encode.string edgeData.type_ )
        ]
