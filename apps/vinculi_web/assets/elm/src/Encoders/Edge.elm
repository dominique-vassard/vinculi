module Encoders.Edge exposing (encoder)

import Json.Encode as Encode exposing (Value, object, string)
import Types
    exposing
        ( Edge
        , EdgeData(GenericEdge, InfluencedEdge)
        , CommonEdgeData
        , GenericEdgeData
        , InfluencedEdgeData
        )


encoder : Edge -> Value
encoder edge =
    Encode.object
        [ ( "data", dataEncoder edge.data )
        , ( "classes", Encode.string edge.classes )
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
