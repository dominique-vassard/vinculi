module Accessors.Snapshots
    exposing
        ( init
        , addNewSnapshot
        , setElementFilters
        , setEdgeFilters
        , setNodeFilters
        , getCurrent
        )

import Utils.ZipList as ZipList exposing (ZipList, current, update)
import Types
    exposing
        ( ElementFilters
        , ElementType(EdgeElt, NodeElt)
        , GraphSnapshot
        , GraphOperationName(..)
        , Operations
        , Snapshot
        )
import Accessors.Snapshot as Snapshot exposing (..)


init : ZipList Snapshot
init =
    let
        initial =
            Snapshot.setGraphSnapshot
                (GraphSnapshot [] "Init")
                Snapshot.createEmpty
    in
        ZipList.init initial []



--- SETTERS


setNodeFilters : ElementFilters -> ZipList Snapshot -> ZipList Snapshot
setNodeFilters =
    setElementFilters NodeElt


setEdgeFilters : ElementFilters -> ZipList Snapshot -> ZipList Snapshot
setEdgeFilters =
    setElementFilters EdgeElt


setElementFilters : ElementType -> ElementFilters -> ZipList Snapshot -> ZipList Snapshot
setElementFilters elementType elementFilters snapshots =
    let
        newSnapshot =
            Snapshot.setElementFilters
                elementType
                elementFilters
                (ZipList.current snapshots)
    in
        ZipList.update newSnapshot snapshots


addNewSnapshot : GraphSnapshot -> Operations -> ZipList Snapshot -> ZipList Snapshot
addNewSnapshot graphSnapshot operations snapshots =
    let
        nodeFilters =
            operations.node.filtered

        edgeFilters =
            operations.edge.filtered

        newSnapshot =
            Snapshot.setElementFilters NodeElt nodeFilters
                << Snapshot.setElementFilters EdgeElt edgeFilters
                << Snapshot.setGraphSnapshot graphSnapshot
            <|
                Snapshot.createEmpty
    in
        case operations.graph.current of
            Init ->
                ZipList.update newSnapshot snapshots

            FilterLocal _ ->
                ZipList.update newSnapshot snapshots

            _ ->
                ZipList.add newSnapshot snapshots



--- GETTERS


getCurrent : ZipList Snapshot -> Snapshot
getCurrent =
    ZipList.current
