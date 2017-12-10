module Accessors.Node
    exposing
        ( getLabels
        , getGenericData
        , setClasses
        , setClassesFromLabels
        , setParentNode
        )

import Types
    exposing
        ( CommonNodeData
        , NodeType
        , NodeData(GenericNode, PersonNode, PublicationNode, ValueNode)
        , GenericNodeData
        , SearchNodeType
        )


--- SETTERS


setParentNode : Maybe SearchNodeType -> NodeType -> NodeType
setParentNode parentNode node =
    case parentNode of
        Just parentNode ->
            if parentNode.uuid == (getGenericData node).id then
                node
            else
                let
                    nodeData =
                        node.data

                    newNodeData =
                        setParentNodeData
                            (Just parentNode.uuid)
                            node.data
                in
                    { node | data = newNodeData }

        Nothing ->
            node


setParentNodeData : Maybe String -> NodeData -> NodeData
setParentNodeData parentNode nodeData =
    case nodeData of
        PersonNode data ->
            PersonNode { data | parentNode = parentNode }

        GenericNode data ->
            GenericNode { data | parentNode = parentNode }

        PublicationNode data ->
            PublicationNode { data | parentNode = parentNode }

        ValueNode data ->
            ValueNode { data | parentNode = parentNode }


setClasses : String -> NodeType -> NodeType
setClasses class node =
    { node | classes = String.toLower class }


setClassesFromLabels : NodeType -> NodeType
setClassesFromLabels node =
    let
        classes =
            getLabels node
                |> String.join ""
    in
        setClasses classes node



--- GETTERS


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



--- HELPERS
