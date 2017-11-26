module Accessors.Edge exposing (getType)

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
            getGenericEdgeData edge
    in
        edge_type


getGenericEdgeData : EdgeType -> GenericEdgeData
getGenericEdgeData edge =
    case edge.data of
        InfluencedEdge data ->
            GenericEdgeData data.id data.source data.target data.edge_type

        GenericEdge data ->
            data
