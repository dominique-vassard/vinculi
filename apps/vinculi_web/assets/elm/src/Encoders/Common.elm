module Encoders.Common exposing (..)

import Json.Encode as Encode exposing (Value, int, object, string)
import Types exposing (Position)


positionEncoder : Position -> Value
positionEncoder position =
    Encode.object
        [ ( "x", Encode.float position.x )
        , ( "y", Encode.float position.y )
        ]


nothingEncoder : Value
nothingEncoder =
    Encode.object []


userEncoder : String -> Encode.Value
userEncoder userToken =
    Encode.object [ ( "token", Encode.string userToken ) ]
