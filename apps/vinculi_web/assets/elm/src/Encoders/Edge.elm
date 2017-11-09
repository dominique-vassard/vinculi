module Encoders.Edge exposing (encoder)

import Json.Encode as Encode exposing (Value, object, string)
import Types
    exposing
        ( EdgeType
        , EdgeData(GenericEdge, InfluencedEdge)
        , CommonEdgeData
        , GenericEdgeData
        , InfluencedEdgeData
        )
import Encoders.Common exposing (nothingEncoder)


encoder : EdgeType -> Value
encoder edge =
    Encode.object
        [ ( "group", Encode.string edge.group )
        , ( "data", dataEncoder edge.data )
        , ( "classes", Encode.string edge.classes )
        , ( "position", nothingEncoder )
        , ( "grabbable", Encode.bool edge.grabbable )
        , ( "locked", Encode.bool edge.locked )
        , ( "removed", Encode.bool edge.removed )
        , ( "selectable", Encode.bool edge.selectable )
        , ( "selected", Encode.bool edge.selected )
        ]


dataEncoder : EdgeData -> Value
dataEncoder data =
    case data of
        InfluencedEdge influencedData ->
            influencedEncoder influencedData

        GenericEdge genericData ->
            genericEncoder genericData


commonEncoder : CommonEdgeData a -> List ( String, Value )
commonEncoder data =
    [ ( "source", Encode.string data.source )
    , ( "target", Encode.string data.target )
    , ( "type", Encode.string data.edge_type )
    ]


genericEncoder : GenericEdgeData -> Value
genericEncoder data =
    Encode.object (commonEncoder data)


influencedEncoder : InfluencedEdgeData -> Value
influencedEncoder data =
    Encode.object (commonEncoder data ++ [ ( "strength", Encode.int data.strength ) ])
