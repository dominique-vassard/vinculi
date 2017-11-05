module Types exposing (..)

import Phoenix.Socket as PhxSocket exposing (Socket)
import Json.Encode exposing (Value)


--- FLAGS


type alias Flags =
    { socketUrl : String
    , originNodeUuid : String
    , originNodeLabels : List String
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
    = GenericNode GenericNodeData
    | PersonNode PersonNodeData
    | PublicationNode PublicationNodeData
    | ValueNode ValueNodeData


type alias Node =
    { data : NodeData
    , classes : String
    }



-- EDGES


type alias Edge =
    { data : EdgeData
    , classes : String
    }


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
    { phxSocket : PhxSocket.Socket Msg
    , graph : Graph
    , socketUrl : String
    , initGraph : Bool
    , searchNode : Maybe SearchNode
    , errorMessage : Maybe String
    }


type alias SearchNode =
    { uuid : String
    , labels : List String
    }


type Msg
    = PhoenixMsg (PhxSocket.Msg Msg)
    | HandleSendError Json.Encode.Value
    | GetNodeLocalGraph
    | ReceiveNodeLocalGraph Json.Encode.Value
    | InitGraph
    | SendGraph
    | Join
    | SetSearchNode (Result String SearchNode)
