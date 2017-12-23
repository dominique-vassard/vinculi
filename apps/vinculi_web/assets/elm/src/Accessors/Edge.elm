module Accessors.Edge
    exposing
        ( getId
        , getType
        , getGenericData
        , setClasses
        , setClassesFromType
        )

import Types
    exposing
        ( EdgeType
        , EdgeData(GenericEdge, InfluencedEdge)
        , GenericEdgeData
        , InfluencedEdgeData
        )


--- SETTERS


setClasses : String -> EdgeType -> EdgeType
setClasses classes edge =
    { edge | classes = String.toLower classes }


setClassesFromType : EdgeType -> EdgeType
setClassesFromType edge =
    setClasses (getType edge) edge



--- GETTERS


getId : EdgeType -> String
getId edge =
    let
        { id } =
            getGenericData edge
    in
        id


getType : EdgeType -> String
getType edge =
    let
        { edge_type } =
            getGenericData edge
    in
        edge_type


getGenericData : EdgeType -> GenericEdgeData
getGenericData edge =
    case edge.data of
        InfluencedEdge data ->
            GenericEdgeData data.id data.source data.target data.edge_type

        GenericEdge data ->
            data



--- HELPERS
