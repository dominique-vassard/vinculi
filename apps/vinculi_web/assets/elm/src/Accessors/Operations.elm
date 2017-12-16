module Accessors.Operations exposing (..)

import Dict
import Types
    exposing
        ( EdgeType
        , NodeType
        , ElementFilters
        , FilterName
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


setNodeFilter : ElementFilters -> Operations -> Operations
setNodeFilter newNodeFilter operations =
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
            Dict.update filterName updateFilter operations.node.filtered
    in
        setNodeFilter newFilters operations


updateFilter : Maybe Visible -> Maybe Visible
updateFilter visible =
    case visible of
        Just v ->
            Just (not v)

        Nothing ->
            Just False


getNodeFilterState : FilterName -> Operations -> Visible
getNodeFilterState filterName operations =
    case Dict.get filterName operations.node.filtered of
        Just visible ->
            visible

        Nothing ->
            True


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


setGraphIsInitial : Bool -> Operations -> Operations
setGraphIsInitial isInitial operations =
    let
        oldGraphOps =
            operations.graph

        newGraphOps =
            { oldGraphOps | isInitial = isInitial }
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
