module Accessors.Snapshot
    exposing
        ( createEmpty
        , setGraphSnapshot
        , setElementFilters
        )

import Dict
import Types
    exposing
        ( ElementFilters
        , ElementType(EdgeElt, NodeElt)
        , ElementState
        , GraphSnapshot
        , Snapshot
        )


createEmpty : Snapshot
createEmpty =
    { graph = []
    , description = ""
    , node =
        { filters = Dict.empty
        }
    , edge =
        { filters = Dict.empty
        }
    }



--- SETTER


setGraphSnapshot : GraphSnapshot -> Snapshot -> Snapshot
setGraphSnapshot graphSnapshot snapshot =
    { snapshot
        | graph = graphSnapshot.graph
        , description = graphSnapshot.description
    }


setElementFilters : ElementType -> ElementFilters -> Snapshot -> Snapshot
setElementFilters elementType elementFilters snapshot =
    let
        oldEltState =
            elementState elementType snapshot

        newEltState =
            { oldEltState | filters = elementFilters }
    in
        setElementState elementType newEltState snapshot


setElementState : ElementType -> ElementState -> Snapshot -> Snapshot
setElementState elementType state snapshot =
    case elementType of
        NodeElt ->
            { snapshot | node = state }

        EdgeElt ->
            { snapshot | edge = state }



--- GETTERS


elementState : ElementType -> Snapshot -> ElementState
elementState elementType snapshot =
    case elementType of
        NodeElt ->
            snapshot.node

        EdgeElt ->
            snapshot.edge
