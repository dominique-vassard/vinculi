module Accessors.Element exposing (setClasses, setParentNode)

import Types exposing (Element(Node, Edge), SearchNodeType)
import Accessors.Node as Node exposing (setClassesFromLabels, setParentNode)
import Accessors.Edge as Edge exposing (setClassesFromType)


--- SETTERS


setClasses : Element -> Element
setClasses element =
    case element of
        Node node ->
            Node <| Node.setClassesFromLabels node

        Edge edge ->
            Edge <| Edge.setClassesFromType edge


setParentNode : Maybe SearchNodeType -> Element -> Element
setParentNode parentNode element =
    case element of
        Node node ->
            Node <| Node.setParentNode parentNode node

        element ->
            element
