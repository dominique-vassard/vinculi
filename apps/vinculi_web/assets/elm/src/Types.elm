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


type alias CommonElementData a =
    { a | classes : String }


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


type alias Position =
    { x : Float
    , y : Float
    }


type alias NodeType =
    { group : String
    , data : NodeData
    , classes : String
    , position : Position
    , grabbable : Bool
    , locked : Bool
    , removed : Bool
    , selectable : Bool
    , selected : Bool
    }



-- EDGES


type alias EdgeType =
    { group : String
    , data : EdgeData
    , classes : String
    , position : Maybe Position
    , grabbable : Bool
    , locked : Bool
    , removed : Bool
    , selectable : Bool
    , selected : Bool
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


type Element
    = Node NodeType
    | Edge EdgeType


type alias Graph =
    List Element


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
