module Accessors.Operations exposing (..)

import Dict
import Types
    exposing
        ( EdgeType
        , NodeType
        , ElementFilters
        , ElementType(EdgeElt, NodeElt)
        , FilterName
        , GraphOperationName
        , Visible
        , Graph
        , GraphSnapshot
        , Operations
        , SearchNodeType
        )


setBrowsedNode : Maybe NodeType -> Operations -> Operations
setBrowsedNode newBrowsedNode operations =
    let
        oldNodeOps =
            operations.node

        newNodeOps =
            { oldNodeOps | browsed = newBrowsedNode }
    in
        { operations | node = newNodeOps }


setPinnedNode : Maybe NodeType -> Operations -> Operations
setPinnedNode newPinnedNode operations =
    let
        oldNodeOps =
            operations.node

        newNodeOps =
            { oldNodeOps | pinned = newPinnedNode }
    in
        { operations | node = newNodeOps }


setSearchedNode : Maybe SearchNodeType -> Operations -> Operations
setSearchedNode newSearchNode operations =
    let
        oldNodeOps =
            operations.node

        newNodeOps =
            { oldNodeOps | searched = newSearchNode }
    in
        { operations | node = newNodeOps }


setNodeFilters : ElementFilters -> Operations -> Operations
setNodeFilters newNodeFilter operations =
    let
        oldNodeOps =
            operations.node

        newNodeOps =
            { oldNodeOps | filtered = newNodeFilter }
    in
        { operations | node = newNodeOps }


toggleNodeFilterState : FilterName -> Operations -> Operations
toggleNodeFilterState filterName operations =
    let
        newFilters =
            Dict.update filterName toggleFilter operations.node.filtered
    in
        setNodeFilters newFilters operations


getNodeFilterState : FilterName -> Operations -> Visible
getNodeFilterState filterName operations =
    case Dict.get filterName operations.node.filtered of
        Just visible ->
            visible

        Nothing ->
            True


getNodeActiveFilters : Operations -> List FilterName
getNodeActiveFilters operations =
    Dict.keys <|
        Dict.filter
            (\_ visible -> not visible)
            operations.node.filtered


resetNodeFilters : Operations -> Operations
resetNodeFilters operations =
    let
        newFilters =
            Dict.map resetFilter operations.node.filtered
    in
        setNodeFilters newFilters operations


setBrowsedEdge : Maybe EdgeType -> Operations -> Operations
setBrowsedEdge newBrowsedEdge operations =
    let
        oldOps =
            operations.edge

        newOps =
            { oldOps | browsed = newBrowsedEdge }
    in
        { operations | edge = newOps }


setPinnedEdge : Maybe EdgeType -> Operations -> Operations
setPinnedEdge newPinnedEdge operations =
    let
        oldOps =
            operations.edge

        newOps =
            { oldOps | pinned = newPinnedEdge }
    in
        { operations | edge = newOps }


setEdgeFilters : ElementFilters -> Operations -> Operations
setEdgeFilters newFilters operations =
    let
        oldOps =
            operations.edge

        newOps =
            { oldOps | filtered = newFilters }
    in
        { operations | edge = newOps }


toggleEdgeFilterState : FilterName -> Operations -> Operations
toggleEdgeFilterState filterName operations =
    let
        newFilters =
            Dict.update filterName toggleFilter operations.edge.filtered
    in
        setEdgeFilters newFilters operations


resetEdgeFilters : Operations -> Operations
resetEdgeFilters operations =
    let
        newFilters =
            Dict.map resetFilter operations.edge.filtered
    in
        setEdgeFilters newFilters operations


getEdgeFilterState : FilterName -> Operations -> Visible
getEdgeFilterState filterName operations =
    case Dict.get filterName operations.edge.filtered of
        Just visible ->
            visible

        Nothing ->
            True


getEdgeActiveFilters : Operations -> List FilterName
getEdgeActiveFilters operations =
    Dict.keys <|
        Dict.filter
            (\_ visible -> not visible)
            operations.edge.filtered


setGraphCurrentOperation : GraphOperationName -> Operations -> Operations
setGraphCurrentOperation currentOpName operations =
    let
        oldGraphOps =
            operations.graph

        newGraphOps =
            { oldGraphOps | current = currentOpName }
    in
        { operations
            | graph = newGraphOps
        }


setGraphData : Maybe Graph -> Operations -> Operations
setGraphData graph operations =
    let
        oldGraphOps =
            operations.graph

        newGraphOps =
            { oldGraphOps | data = graph }
    in
        { operations
            | graph = newGraphOps
        }


setGraphSnapshot : Maybe GraphSnapshot -> Operations -> Operations
setGraphSnapshot snapshot operations =
    let
        oldGraphOps =
            operations.graph

        newGraphOps =
            { oldGraphOps | snapshot = snapshot }
    in
        { operations
            | graph = newGraphOps
        }



--- GETTERS


toggleFilter : Maybe Visible -> Maybe Visible
toggleFilter visible =
    case visible of
        Just v ->
            Just (not v)

        Nothing ->
            Just False


resetFilter : FilterName -> Visible -> Visible
resetFilter _ _ =
    True



--- HELPERS


resetElementFilters : Operations -> Operations
resetElementFilters operations =
    (resetEdgeFilters << resetNodeFilters) operations
