module Encoders.Graph exposing (encoder)

import Json.Encode as Encode exposing (Value, object)
import Types exposing (Graph, Element(Node, Edge))
import Encoders.Node as Node exposing (encoder)
import Encoders.Edge as Edge exposing (encoder)


encoder : Graph -> Value
encoder graph =
    Encode.list (List.map elementEncoder graph)


elementEncoder : Element -> Value
elementEncoder element =
    case element of
        Node node ->
            Node.encoder node

        Edge edge ->
            Edge.encoder edge
