module Accessors.Edge exposing (getType)

import Types
    exposing
        ( Edge
        , EdgeData(GenericEdge, InfluencedEdge)
        , GenericEdgeData
        , InfluencedEdgeData
        )


getType : Edge -> String
getType edge =
    let
        { edge_type } =
            getGenericEdgeData edge
    in
        edge_type


getGenericEdgeData : Edge -> GenericEdgeData
getGenericEdgeData edge =
    case edge.data of
        InfluencedEdge data ->
            GenericEdgeData data.source data.target data.edge_type

        GenericEdge data ->
            data
