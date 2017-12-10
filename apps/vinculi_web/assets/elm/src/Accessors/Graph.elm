module Accessors.Graph
    exposing
        ( elementOf
        , getEdge
        , getNode
        , substractGraph
        , updateMetaData
        )

import Types
    exposing
        ( Element(Edge, Node)
        , EdgeType
        , NodeType
        , Graph
        , SearchNodeType
        )
import Accessors.Element as Element exposing (setClasses, setParentNode)
import Accessors.Edge as Edge exposing (getGenericData)
import Accessors.Node as Node exposing (getGenericData)


--- SETTERS


updateMetaData : Maybe SearchNodeType -> Graph -> Graph
updateMetaData parentNode graph =
    List.map (Element.setClasses >> (Element.setParentNode parentNode)) graph



--- GETTERS


nodes : Graph -> List NodeType
nodes graph =
    let
        f =
            \x ->
                case x of
                    Node node ->
                        Just node

                    Edge _ ->
                        Nothing
    in
        List.filterMap f graph


edges : Graph -> List EdgeType
edges graph =
    let
        f =
            \x ->
                case x of
                    Node _ ->
                        Nothing

                    Edge edge ->
                        Just edge
    in
        List.filterMap f graph


getEdge : String -> Graph -> Maybe EdgeType
getEdge edgeId graph =
    List.head <|
        List.filter (\x -> (Edge.getGenericData x).id == edgeId) (edges graph)


getNode : String -> Graph -> Maybe NodeType
getNode nodeId graph =
    List.head <|
        List.filter (\x -> (Node.getGenericData x).id == nodeId) (nodes graph)



--- HELPERS


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


isNode : Element -> Bool
isNode element =
    case element of
        Node _ ->
            True

        Edge _ ->
            False


isEdge : Element -> Bool
isEdge element =
    not <| isNode element


substractGraph : Graph -> Graph -> Graph
substractGraph receivedGraph graph =
    List.filter
        (\x ->
            not (elementOf x graph)
        )
        receivedGraph
