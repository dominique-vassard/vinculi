module Accessors.Edge exposing (getType, getGenericData)

import Types
    exposing
        ( EdgeType
        , EdgeData(GenericEdge, InfluencedEdge)
        , GenericEdgeData
        , InfluencedEdgeData
        )


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
