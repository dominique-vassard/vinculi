module Accessors.Node
    exposing
        ( getId
        , getLabels
        , getGenericData
        , setClasses
        , setClassesFromLabels
        , setParentNode
        )

import Types
    exposing
        ( CommonNodeData
        , ElementId
        , NodeType
        , NodeData
            ( GenericNode
            , InstitutionNode
            , LocationNode
            , PersonNode
            , PublicationNode
            , ValueNode
            )
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
        GenericNode data ->
            GenericNode { data | parentNode = parentNode }

        InstitutionNode data ->
            InstitutionNode { data | parentNode = parentNode }

        LocationNode data ->
            LocationNode { data | parentNode = parentNode }

        PersonNode data ->
            PersonNode { data | parentNode = parentNode }

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


getId : NodeType -> ElementId
getId node =
    let
        { id } =
            getGenericData node
    in
        id


getGenericData : NodeType -> GenericNodeData
getGenericData node =
    case node.data of
        GenericNode data ->
            data

        InstitutionNode data ->
            extractGenericData data

        LocationNode data ->
            extractGenericData data

        PersonNode data ->
            extractGenericData data

        PublicationNode data ->
            extractGenericData data

        ValueNode data ->
            extractGenericData data



--- HELPERS


extractGenericData : CommonNodeData a -> GenericNodeData
extractGenericData data =
    GenericNodeData data.id data.labels data.name data.parentNode
