port module Ports exposing (..)

import Json.Decode exposing (Decoder)


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



--- OUT PORTS


port changeStyle : String -> Cmd msg


port newGraph : Graph -> Cmd msg



--- INPUT PORTS


port currentStyle : (Json.Decode.Value -> msg) -> Sub msg


port resetStyle : (Json.Decode.Value -> msg) -> Sub msg
