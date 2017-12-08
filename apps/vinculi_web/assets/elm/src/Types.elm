module Types exposing (..)

import Phoenix.Socket as PhxSocket exposing (Socket)
import Json.Encode exposing (Value)
import Utils.ZipList as ZipList exposing (ZipList)


--- FLAGS


type alias Flags =
    { socketUrl : String
    , originNodeUuid : String
    , originNodeLabels : List String
    , userToken : String
    }



--- NODES


type alias GenericNodeData =
    { id : String
    , labels : List String
    , name : String
    , parentNode : Maybe String
    }


type alias CommonNodeData a =
    { a
        | id : String
        , labels : List String
        , name : String
        , parentNode : Maybe String
    }


type alias CommonElementData a =
    { a | classes : String }


type alias PersonNodeData =
    { id : String
    , labels : List String
    , name : String
    , parentNode : Maybe String
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
    , parentNode : Maybe String
    , value : Int
    }


type alias PublicationNodeData =
    { id : String
    , labels : List String
    , name : String
    , parentNode : Maybe String
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
        | id : String
        , source : String
        , target : String
        , edge_type : String
    }


type alias GenericEdgeData =
    { id : String
    , source : String
    , target : String
    , edge_type : String
    }


type alias InfluencedEdgeData =
    { id : String
    , source : String
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



--- MODEL


type ElementType
    = NodeElt
    | EdgeElt


type alias BrowsedElement =
    { id : String
    , elementType : ElementType
    }


type alias PinnedElement =
    { elementType : ElementType
    , pin : Bool
    }


type alias NodeOperations =
    { searched : Maybe SearchNodeType
    , browsed : Maybe NodeType
    , pinned : Maybe NodeType
    }


type alias EdgeOperations =
    { browsed : Maybe EdgeType
    , pinned : Maybe EdgeType
    }


type alias GraphOperations =
    { data : Maybe Graph
    , isInitial : Bool
    }


type alias Operations =
    { node : NodeOperations
    , graph : GraphOperations
    , edge : EdgeOperations
    }


type alias Snapshot =
    { graph : Graph
    , description : String
    }


type alias Model =
    { phxSocket : PhxSocket.Socket Msg
    , socketUrl : String
    , userToken : String
    , errorMessage : Maybe String
    , operations : Operations
    , snapshots : ZipList Snapshot
    }


type alias SearchNodeType =
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
    | JoinError
    | SetSearchNode (Result String SearchNodeType)
    | SetBrowsedElement (Result String BrowsedElement)
    | UnsetBrowsedElement (Result String ElementType)
    | SetPinnedElement (Result String PinnedElement)
    | SetGraphState (Result String Snapshot)
