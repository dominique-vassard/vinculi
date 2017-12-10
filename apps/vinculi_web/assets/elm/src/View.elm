module View exposing (view)

import Bootstrap.Alert as Alert
import Bootstrap.Card as Card
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Row as Row
import Bootstrap.Grid.Col as Col
import Html exposing (Html, button, div, h5, span, text)
import Html.Attributes exposing (class, id)
import Types
    exposing
        ( Model
        , Msg
        , EdgeType
        , NodeType
        , EdgeOperations
        , NodeOperations
        , GenericEdgeData
        , NodeData(GenericNode, PersonNode, PublicationNode, ValueNode)
        , GenericNodeData
        , PersonNodeData
        , PublicationNodeData
        , ValueNodeData
        )
import Accessors.Edge as Edge exposing (..)


view : Model -> Html Msg
view model =
    div []
        [ viewError model.errorMessage
        , div [ class "row bg-silver rounded fill" ]
            [ div
                [ class "col-lg-9" ]
                [ div [ class "row border border-primary cy-graph", id "cy" ]
                    []
                ]
            , div [ class "col-lg-3 bg-gray rounded-right" ]
                [ Grid.row [ Row.attrs [ class "rounded bg-secondary" ] ]
                    [ Grid.col [ Col.lg12 ] [ text "Browse" ] ]
                , Grid.row []
                    [ Grid.col [ Col.lg12 ]
                        [ viewNodeData <| nodeToDisplay model.operations.node
                        , viewEdgeData <| edgeToDisplay model.operations.edge
                        ]
                    ]
                ]
            ]
        ]


viewError : Maybe String -> Html Msg
viewError errorMessage =
    let
        div_ =
            case errorMessage of
                Nothing ->
                    div [] []

                Just errorMsg ->
                    Grid.row []
                        [ Grid.col [ Col.lg12 ]
                            [ Alert.danger [ text errorMsg ] ]
                        ]
    in
        div_


nodeToDisplay : NodeOperations -> Maybe NodeType
nodeToDisplay currentNode =
    case currentNode.browsed of
        Just node ->
            Just node

        Nothing ->
            currentNode.pinned


edgeToDisplay : EdgeOperations -> Maybe EdgeType
edgeToDisplay currentEdge =
    case currentEdge.browsed of
        Just edge ->
            Just edge

        Nothing ->
            currentEdge.pinned


viewEdgeData : Maybe EdgeType -> Html Msg
viewEdgeData edgeToDisplay =
    let
        dataToDisplay =
            case edgeToDisplay of
                Nothing ->
                    div [] []

                Just edge ->
                    div [] [ text (Edge.getGenericData edge).edge_type ]
    in
        Card.config []
            |> Card.header [ class "text-center" ]
                [ h5 [] [ text "Edge infos" ] ]
            |> Card.block [ Card.blockAttrs [ class "node-infos" ] ]
                [ Card.text [] [ dataToDisplay ] ]
            |> Card.view


viewNodeData : Maybe NodeType -> Html Msg
viewNodeData nodetoDisplay =
    let
        dataToDisplay =
            case nodetoDisplay of
                Nothing ->
                    div [] []

                Just node ->
                    case node.data of
                        GenericNode nodeData ->
                            viewGenericNodeData nodeData

                        PersonNode nodeData ->
                            viewPersonNodeData nodeData

                        PublicationNode nodeData ->
                            viewPublicationNodeData nodeData

                        ValueNode nodeData ->
                            viewValueNodeData nodeData
    in
        Card.config []
            |> Card.header [ class "text-center" ]
                [ h5 [] [ text "Node infos" ] ]
            |> Card.block [ Card.blockAttrs [ class "node-infos" ] ]
                [ Card.text [] [ dataToDisplay ] ]
            |> Card.view


viewGenericNodeData : GenericNodeData -> Html Msg
viewGenericNodeData nodeData =
    div []
        [ viewNodeLabel nodeData.labels ]


viewPersonNodeData : PersonNodeData -> Html Msg
viewPersonNodeData nodeData =
    div []
        [ viewNodeLabel nodeData.labels
        , viewInfoLine "Prénom" nodeData.firstName
        , viewInfoLine "Nom" nodeData.lastName
        , viewInfoLine "Pseudonymes" nodeData.aka
        , viewInfoLine "Lien Ars Margica" nodeData.internalLink
        , viewInfoLine "Lien externe" nodeData.externalLink
        ]


viewPublicationNodeData : PublicationNodeData -> Html Msg
viewPublicationNodeData nodeData =
    div []
        [ viewNodeLabel nodeData.labels
        , viewInfoLine "Titre" nodeData.title

        --, viewInfoLine "Lien Ars Margica" nodeData.titleFr
        --, viewInfoLine "Lien Ars Margica" nodeData.internalLink
        --, viewInfoLine "Lien externe" nodeData.externalLink
        ]


viewValueNodeData : ValueNodeData -> Html Msg
viewValueNodeData nodeData =
    div []
        [ viewNodeLabel nodeData.labels
        , viewInfoLine "Valeur" <| toString nodeData.value
        ]


viewNodeLabel : List String -> Html Msg
viewNodeLabel labels =
    viewInfoLine "Label" (String.join "," labels)


viewInfoLine : String -> String -> Html Msg
viewInfoLine label value =
    Grid.row []
        [ Grid.col [ Col.lg ] [ text <| label ++ ": " ]
        , Grid.col [ Col.lg8 ] [ text <| value ]
        ]
