module Accessors.Node exposing (getLabels, getGenericData, setParentNode)

import Types
    exposing
        ( CommonNodeData
        , NodeType
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
            GenericNodeData data.id data.labels data.name data.parentNode

        GenericNode data ->
            data

        PublicationNode data ->
            GenericNodeData data.id data.labels data.name data.parentNode

        ValueNode data ->
            GenericNodeData data.id data.labels data.name data.parentNode


setParentNode : Maybe String -> NodeData -> NodeData
setParentNode parentNode nodeData =
    case nodeData of
        PersonNode data ->
            PersonNode { data | parentNode = parentNode }

        GenericNode data ->
            GenericNode { data | parentNode = parentNode }

        PublicationNode data ->
            PublicationNode { data | parentNode = parentNode }

        ValueNode data ->
            ValueNode { data | parentNode = parentNode }
