module Accessors.Operations exposing (..)

import Types exposing (Operations, NodeType, SearchNodeType, Graph)


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
