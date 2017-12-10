module Subscriptions exposing (subscriptions)

import Json.Decode exposing (decodeValue)
import Phoenix.Socket as PhxSocket exposing (listen)
import Types
    exposing
        ( Model
        , Msg
            ( PhoenixMsg
            , SetSearchNode
            , SetGraphState
            , SetBrowsedElement
            , UnsetBrowsedElement
            , SetPinnedElement
            )
        )
import Ports exposing (..)
import Decoders.Port as PortDecoder exposing (localGraphDecoder)
import Decoders.Snapshot as SnapshotDecoder exposing (decoder)
import Decoders.Element as ElementDecoder
    exposing
        ( browsedDecoder
        , elementTypeDecoder
        , pinnedDecoder
        )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Ports.getLocalGraph
            (Json.Decode.decodeValue
                PortDecoder.localGraphDecoder
                >> SetSearchNode
            )
        , Ports.newGraphState
            (Json.Decode.decodeValue SnapshotDecoder.decoder
                >> SetGraphState
            )
        , Ports.displayElementInfos
            ((Json.Decode.decodeValue ElementDecoder.browsedDecoder)
                >> SetBrowsedElement
            )
        , Ports.hideElementInfos
            ((Json.Decode.decodeValue ElementDecoder.elementTypeDecoder)
                >> UnsetBrowsedElement
            )
        , Ports.pinElementInfos
            ((Json.Decode.decodeValue ElementDecoder.pinnedDecoder)
                >> SetPinnedElement
            )
        , PhxSocket.listen model.phxSocket PhoenixMsg
        ]
