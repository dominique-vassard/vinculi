module Accessors.Snapshot exposing (..)

import Types exposing (ElementFilters, Snapshot)


setNodeFilter : ElementFilters -> Snapshot -> Snapshot
setNodeFilter nodeFilters snapshot =
    let
        oldNodeState =
            snapshot.node

        newNodeState =
            { oldNodeState | filters = nodeFilters }
    in
        { snapshot | node = newNodeState }
