module Accessors.Graph
    exposing
        ( elementOf
        , getEdge
        , getNode
        , getFilteredElements
        , getFilteredNodes
        , getFilteredEdges
        , substractGraph
        , updateMetaData
        )

import Types
    exposing
        ( Element(Edge, Node)
        , ElementType(EdgeElt, NodeElt)
        , ElementId
        , EdgeType
        , FilterName
        , NodeType
        , Graph
        , SearchNodeType
        )
import Accessors.Element as Element exposing (setClasses, setParentNode)
import Accessors.Edge as Edge exposing (getGenericData)
import Accessors.Node as Node exposing (getGenericData, getId, getLabels)


--- SETTERS


updateMetaData : Maybe SearchNodeType -> Graph -> Graph
updateMetaData parentNode graph =
    List.map
        (Element.setClasses
            >> Element.setParentNode parentNode
        )
        graph



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


getFilteredElements : ElementType -> List FilterName -> Graph -> List ElementId
getFilteredElements elementType =
    case elementType of
        NodeElt ->
            getFilteredNodes

        EdgeElt ->
            getFilteredEdges


getFilteredNodes : List FilterName -> Graph -> List ElementId
getFilteredNodes filterNames graph =
    List.map (\x -> Node.getId x) <|
        List.filter
            (\x ->
                List.any (\x -> List.member x filterNames) (Node.getLabels x)
            )
            (nodes graph)


getFilteredEdges : List FilterName -> Graph -> List ElementId
getFilteredEdges filterNames graph =
    List.map (\x -> Edge.getId x) <|
        List.filter
            (\x -> List.member (Edge.getType x) filterNames)
            (edges graph)
