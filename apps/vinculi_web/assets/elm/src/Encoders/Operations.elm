module Encoders.Operations exposing (visibleElementsEncoder)

import Json.Encode as Encode exposing (Value, list, string)
import Types exposing (ElementType(NodeElt, EdgeElt), Visible)


--type alias VisibleElements =
--    { elementType : ElementType
--    , elementIds : List String
--    , visible : Visible
--    }


type alias ElementId =
    String



--visibleElementsEncoder : VisibleElements -> Encode.Value
--visibleElementsEncoder visibleElements =
--    Encode.object
--        [ ( "elementType", elementTypeEncoder visibleElements.elementType )
--        , ( "elementIds", Encode.list <| List.map Encode.string visibleElements.elementIds )
--        , ( "visible", Encode.bool visibleElements.visible )
--        ]


visibleElementsEncoder : ElementType -> List ElementId -> Visible -> Encode.Value
visibleElementsEncoder elementType elementIds visible =
    Encode.object
        [ ( "elementType", elementTypeEncoder elementType )
        , ( "elementIds", Encode.list <| List.map Encode.string elementIds )
        , ( "visible", Encode.bool visible )
        ]


elementTypeEncoder : ElementType -> Encode.Value
elementTypeEncoder elementType =
    case elementType of
        NodeElt ->
            Encode.string "nodes"

        EdgeElt ->
            Encode.string "edges"
