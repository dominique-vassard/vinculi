module Types exposing (..)

import Phoenix.Socket as PhxSocket exposing (Socket)
import Json.Encode exposing (Value)


type alias Flags =
    { socket_url : String
    , source_node_uuid : String
    }


type alias NodeData =
    { id : String
    , labels : List String
    , name : String
    }


type alias Node =
    { data : NodeData
    }


type alias EdgeData =
    { source : String
    , target : String
    , type_ : String
    }


type alias Edge =
    { data : EdgeData }


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
