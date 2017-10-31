module Encoders.Graph exposing (encoder)

import Json.Encode as Encode exposing (Value, object)
import Types exposing (Graph)
import Encoders.Node as Node exposing (encoder)
import Encoders.Edge as Edge exposing (encoder)


encoder : Graph -> Value
encoder graph =
    Encode.object
        [ ( "nodes", Encode.list (List.map Node.encoder graph.nodes) )
        , ( "edges", Encode.list (List.map Edge.encoder graph.edges) )
        ]
