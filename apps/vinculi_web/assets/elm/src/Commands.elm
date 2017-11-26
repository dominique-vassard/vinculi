module Commands exposing (..)

import Types exposing (Node)
import Json.Encode exposing (object)
import Phoenix exposing (push)
import Phoenix.Push as PhxPush exposing (init, withPayload, onError, onOk)


getNodeLocalGraph : String -> String -> Cmd Msg
getNodeLocalGraph socket_url node_uuid =
    let
        payload =
            Json.Encode.object
                [ ( "node_uuid", Json.Encode.string node_uuid ) ]

        phxPush =
            PhxPush.init "node_local_graph" "constellation:explore"
                |> PhxPush.withPayload payload
                |> PhxPush.onOk ReceiveNodeLocalGraph
                |> PhxPush.onError HandleSendError
    in
        Phoenix.push socket_url phxPush
