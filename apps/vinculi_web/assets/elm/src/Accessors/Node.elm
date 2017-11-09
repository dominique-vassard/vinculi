module Accessors.Node exposing (getLabels)

import Types
    exposing
        ( NodeType
        , NodeData(GenericNode, PersonNode, PublicationNode, ValueNode)
        , GenericNodeData
        )


getLabels : NodeType -> List String
getLabels node =
    let
        { labels } =
            getGenericData node
    in
        labels


getGenericData : NodeType -> GenericNodeData
getGenericData node =
    case node.data of
        PersonNode data ->
            GenericNodeData data.id data.labels data.name

        GenericNode data ->
            data

        PublicationNode data ->
            GenericNodeData data.id data.labels data.name

        ValueNode data ->
            GenericNodeData data.id data.labels data.name
