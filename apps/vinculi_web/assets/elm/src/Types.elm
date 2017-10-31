module Types exposing (..)

import Phoenix.Socket as PhxSocket exposing (Socket)
import Json.Encode exposing (Value)


--- FLAGS


type alias Flags =
    { socket_url : String
    , source_node_uuid : String
    }



--- NODES


type alias GenericNodeData =
    { id : String
    , labels : List String
    , name : String
    }


type alias CommonNodeData a =
    { a
        | id : String
        , labels : List String
        , name : String
    }


type alias PersonNodeData =
    { id : String
    , labels : List String
    , name : String
    , lastName : String
    , firstName : String
    , aka : String
    , internalLink : String
    , externalLink : String
    }


type alias ValueNodeData =
    { id : String
    , labels : List String
    , name : String
    , value : Int
    }


type alias PublicationNodeData =
    { id : String
    , labels : List String
    , name : String
    , title : String
    }


type NodeData
    = Generic GenericNodeData
    | Person PersonNodeData
    | Publication PublicationNodeData
    | ValueNode ValueNodeData


type alias Node =
    { data : NodeData
    , classes : String
    }



-- EDGES


type alias Edge =
    { data : EdgeData }


type EdgeData
    = GenericEdge GenericEdgeData
    | InfluencedEdge InfluencedEdgeData


type alias CommonEdgeData a =
    { a
        | source : String
        , target : String
        , edge_type : String
    }


type alias GenericEdgeData =
    { source : String
    , target : String
    , edge_type : String
    }


type alias InfluencedEdgeData =
    { source : String
    , target : String
    , edge_type : String
    , strength : Int
    }



--- GRAPH


type alias Graph =
    { nodes : List Node
    , edges : List Edge
    }


type alias Model =
    { number : Int
    , style : String
    , source_node_uuid : String
    , phxSocket : PhxSocket.Socket Msg
    , messageInProgress : String
    , messages : List String
    , graph : Graph
    }


type Msg
    = Increment
    | Decrement
    | Change String
    | ChangeStyle
    | CurrentStyle (Result String String)
    | ResetStyle (Result String String)
    | PhoenixMsg (PhxSocket.Msg Msg)
    | SetSocketMessage String
    | SendMessage
    | ReceiveMessage Json.Encode.Value
    | HandleSendError Json.Encode.Value
    | GetNodeLocalGraph
    | ReceiveNodeLocalGraph Json.Encode.Value
    | SendGraph
