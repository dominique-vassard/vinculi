module Accessors.Graph exposing (elementOf, getEdge, getNode)

import Types exposing (Element(Edge, Node), EdgeType, NodeType, Graph)
import Accessors.Node as Node exposing (getGenericData)
import Accessors.Edge as Edge exposing (getGenericData)


elementOf : Element -> Graph -> Bool
elementOf element graph =
    case element of
        Node node ->
            let
                nodeId =
                    (Node.getGenericData node).id

                filtered =
                    List.filter
                        (\x ->
                            (Node.getGenericData x).id == nodeId
                        )
                        (nodes graph)
            in
                (List.length filtered) > 0

        Edge edge ->
            let
                edgeId =
                    (Edge.getGenericData edge).id

                filtered =
                    List.filter
                        (\x ->
                            (Edge.getGenericData x).id == edgeId
                        )
                        (edges graph)
            in
                (List.length filtered) > 0


getEdge : String -> Graph -> Maybe EdgeType
getEdge edgeId graph =
    List.head <|
        List.filter (\x -> (Edge.getGenericData x).id == edgeId) (edges graph)


getNode : String -> Graph -> Maybe NodeType
getNode nodeId graph =
    List.head <|
        List.filter (\x -> (Node.getGenericData x).id == nodeId) (nodes graph)


parts : Graph -> ( Graph, Graph )
parts graph =
    List.partition
        (\x ->
            case x of
                Node _ ->
                    True

                Edge _ ->
                    False
        )
        graph


nodes : Graph -> List NodeType
nodes graph =
    let
        ( nodes, _ ) =
            parts graph

        f =
            (\x ->
                case x of
                    Node node ->
                        node

                    Edge _ ->
                        Debug.crash "No edge should be found here"
            )
    in
        List.map f nodes


edges : Graph -> List EdgeType
edges graph =
    let
        ( _, edges ) =
            parts graph

        f =
            (\x ->
                case x of
                    Edge edge ->
                        edge

                    Node _ ->
                        Debug.crash "No node should be found here"
            )
    in
        List.map f edges
