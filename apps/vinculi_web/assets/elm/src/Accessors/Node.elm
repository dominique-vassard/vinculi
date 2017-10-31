module Accessors.Node exposing (getLabels)

import Types exposing (..)


getLabels : Node -> List String
getLabels node =
    let
        { labels } =
            getGenericData node
    in
        labels


getGenericData : Node -> GenericNodeData
getGenericData node =
    case node.data of
        Person data ->
            GenericNodeData data.id data.labels data.name

        Generic data ->
            data

        Publication data ->
            GenericNodeData data.id data.labels data.name

        ValueNode data ->
            GenericNodeData data.id data.labels data.name
