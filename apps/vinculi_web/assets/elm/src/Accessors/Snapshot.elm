module Accessors.Snapshot exposing (..)

import Types exposing (ElementFilters, ElementState, Snapshot)


t : String
t =
    "hello"



--setNodeFilter : ElementFilters -> Snapshot -> Snapshot
--setNodeFilter nodeFilters snapshot =
--    let
--        oldNodeState =
--            snapshot.node
--        newNodeState =
--            { oldNodeState | filters = nodeFilters }
--    in
--        { snapshot | node = newNodeState }
