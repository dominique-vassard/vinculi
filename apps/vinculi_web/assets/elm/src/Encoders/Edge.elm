module Encoders.Edge exposing (encoder)

import Json.Encode as Encode exposing (Value, object, string)
import Types exposing (Edge, EdgeData)


encoder : Edge -> Value
encoder edge =
    Encode.object
        [ ( "data", dataEncoder edge.data )
        ]


dataEncoder : EdgeData -> Value
dataEncoder data =
    Encode.object
        [ ( "source", Encode.string data.source )
        , ( "target", Encode.string data.target )
        , ( "type", Encode.string data.edge_type )
        ]
