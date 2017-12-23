module View exposing (view)

import Bootstrap.Alert as Alert
import Bootstrap.Card as Card
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Row as Row
import Bootstrap.Grid.Col as Col
import Bootstrap.ListGroup as ListGroup
import Bootstrap.Tab as Tab
import Dict
import Html exposing (Html, a, button, div, i, h5, h6, text)
import Html.Attributes exposing (attribute, class, classList, href, id, style)
import Html.Events exposing (onClick)
import Types
    exposing
        ( Model
        , Msg(ToggleFilter, ResetFilters, FilterTabMsg, ControlPanelState)
        , EdgeType
        , NodeType
        , Operations
        , EdgeOperations
        , NodeOperations
        , EdgeData(GenericEdge, InfluencedEdge)
        , ElementFilters
        , FilterName
        , Visible
        , ElementType(EdgeElt, NodeElt)
        , GenericEdgeData
        , InfluencedEdgeData
        , NodeData
            ( GenericNode
            , InstitutionNode
            , LocationNode
            , PersonNode
            , PublicationNode
            , ValueNode
            )
        , GenericNodeData
        , InstitutionNodeData
        , LocationNodeData
        , PersonNodeData
        , PublicationNodeData
        , ValueNodeData
        , Panel(Navigator, Filters)
        )


type TextType
    = SimpleText
    | Url


view : Model -> Html Msg
view model =
    div []
        [ viewError model.errorMessage
        , Grid.row [ Row.attrs [ class "bg-silver rounded fill" ] ]
            [ Grid.col
                [ Col.lg9 ]
                [ Grid.row [ Row.attrs [ class "cy-graph", id "cy" ] ]
                    []
                ]
            , Grid.col [ Col.lg3, Col.attrs [ class "bg-gray rounded-right" ] ]
                [ Grid.row []
                    [ Grid.col [ Col.lg12, Col.attrs [ class "p-0", id "control-panels", attribute "data-children" "cpanel" ] ]
                        [ div [ class "cpanels" ]
                            [ viewPanelTitle model Navigator "Navigateur" "panel-navigator" True
                            , viewPanelNavigator model
                            , viewPanelTitle model Filters "Filtres" "panel-filters" False
                            , viewPanelFilters model
                            ]
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


viewPanelTitle : Model -> Panel -> String -> String -> Bool -> Html Msg
viewPanelTitle model panel title panelId isExpanded =
    div [ class "rounded-top control-panel-title p-1" ]
        [ a
            [ attribute "data-toggle" "collapse"
            , attribute "data-parent" "control-panels"
            , href <| "#" ++ panelId
            , attribute "aria-expanded" (toString isExpanded)
            , attribute "aria-controls" panelId
            , onClick (ControlPanelState panel)
            ]
            [ i
                [ classList
                    [ ( "fa fa-angle-down link"
                      , (Dict.get (toString panel) model.controlPanelsState) == Just True
                      )
                    , ( "fa fa-angle-right link"
                      , (Dict.get (toString panel) model.controlPanelsState) == Just False
                      )
                    ]
                ]
                [ text <| " " ++ title
                ]
            ]
        ]


viewPanelNavigator : Model -> Html Msg
viewPanelNavigator model =
    div
        [ id "panel-navigator"
        , class "control-panel-navigator collapse show"
        , attribute "role" "tabpanel"
        ]
        [ viewNodeData <| nodeToDisplay model.operations.node
        , viewEdgeData <| edgeToDisplay model.operations.edge
        ]


viewPanelFilters : Model -> Html Msg
viewPanelFilters model =
    div
        [ id "panel-filters"
        , class "p-1 collapse"
        , attribute "role" "tabpanel"
        ]
        [ viewTabFilters model
        ]


viewTabFilters : Model -> Html Msg
viewTabFilters model =
    Tab.config FilterTabMsg
        |> Tab.items
            [ viewTabFilterItems NodeElt model.operations.node.filtered
            , viewTabFilterItems EdgeElt model.operations.edge.filtered
            ]
        |> Tab.view model.filterTabState


viewTabFilterItems : ElementType -> ElementFilters -> Tab.Item Msg
viewTabFilterItems elementType elementFilters =
    let
        data =
            case elementType of
                NodeElt ->
                    { title = "Noeuds", id = "filter-node", linkClass = "node", bgClass = "bg-node" }

                EdgeElt ->
                    { title = "Relations", id = "filter-edge", linkClass = "edge", bgClass = "bg-edge" }
    in
        Tab.item
            { id = data.id
            , link = Tab.link [ class <| "ml-1 text-dark nav-filter-" ++ data.linkClass ] [ text data.title ]
            , pane = Tab.pane [ class <| "p1 rounded-bottom filter-pane " ++ data.bgClass ] [ viewElementFilters elementType elementFilters ]
            }


viewElementFilters : ElementType -> ElementFilters -> Html Msg
viewElementFilters elementType elementFilters =
    div [ class "p-1" ]
        ([ button [ class "btn btn-secondary", onClick (ResetFilters elementType) ]
            [ text "Tout voir" ]
         ]
            ++ (List.map (viewElementFilter elementType) <|
                    Dict.toList elementFilters
               )
        )


viewElementFilter : ElementType -> ( FilterName, Visible ) -> Html Msg
viewElementFilter elementType ( filterName, visible ) =
    div
        [ onClick (ToggleFilter elementType filterName)
        , classList
            [ ( "text-disabled", not visible )
            ]
        ]
        [ i
            [ classList
                [ ( "link", True )
                , ( "filter-list", True )
                , ( "fa fa-eye", visible )
                , ( "fa fa-eye-slash", not visible )
                ]
            ]
            [ text <| " " ++ filterName ]
        ]


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
                    case edge.data of
                        GenericEdge edgeData ->
                            viewGenericEdgeData edgeData

                        InfluencedEdge edgeData ->
                            viewInfluencedEdgeData edgeData
    in
        Card.config [ Card.attrs [ class "border-edge m-1 bg-edge" ] ]
            |> Card.header [ class "text-center bg-edge p-0" ]
                [ h5 [] [ text "Relation" ] ]
            |> Card.block [ Card.blockAttrs [ class "element-infos" ] ]
                [ Card.text [] [ dataToDisplay ] ]
            |> Card.view


viewGenericEdgeData : GenericEdgeData -> Html Msg
viewGenericEdgeData edgeData =
    div [ class "p-1 m-0" ]
        [ ListGroup.ul
            [ viewEdgeType edgeData.edge_type ]
        ]


viewInfluencedEdgeData : InfluencedEdgeData -> Html Msg
viewInfluencedEdgeData edgeData =
    viewNodeInfos
        [ viewEdgeType edgeData.edge_type
        , viewInfoLineText "Force" <| toString edgeData.strength
        ]


viewEdgeType : String -> ListGroup.Item Msg
viewEdgeType edge_type =
    viewInfoLineText "Type" edge_type


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

                        InstitutionNode nodeData ->
                            viewInstitutionNodeData nodeData

                        LocationNode nodeData ->
                            viewLocationNodeData nodeData

                        PersonNode nodeData ->
                            viewPersonNodeData nodeData

                        PublicationNode nodeData ->
                            viewPublicationNodeData nodeData

                        ValueNode nodeData ->
                            viewValueNodeData nodeData
    in
        Card.config [ Card.attrs [ class "border-node m-1 bg-node" ] ]
            |> Card.header [ class "text-center bg-node p-0" ]
                [ h5 [] [ text "Noeud" ] ]
            |> Card.block [ Card.blockAttrs [ class "element-infos" ] ]
                [ Card.text [] [ dataToDisplay ] ]
            |> Card.view


viewNodeInfos : List (ListGroup.Item Msg) -> Html Msg
viewNodeInfos infoLines =
    div [ class "p-1 m-0" ]
        [ ListGroup.ul infoLines
        ]


viewGenericNodeData : GenericNodeData -> Html Msg
viewGenericNodeData nodeData =
    div [ class "p-1 m-0" ]
        [ ListGroup.ul
            [ viewNodeLabel
                nodeData.labels
            ]
        ]


viewInstitutionNodeData : InstitutionNodeData -> Html Msg
viewInstitutionNodeData nodeData =
    viewNodeInfos
        [ viewNodeLabel nodeData.labels
        , viewInfoLineText "Type" nodeData.institution_type
        ]


viewLocationNodeData : LocationNodeData -> Html Msg
viewLocationNodeData nodeData =
    let
        lat =
            case nodeData.lat of
                Just lat ->
                    toString lat

                Nothing ->
                    ""

        long =
            case nodeData.long of
                Just long ->
                    toString long

                Nothing ->
                    ""
    in
        viewNodeInfos
            [ viewNodeLabel nodeData.labels
            , viewInfoLineText "Latitude" lat
            , viewInfoLineText "Longitude" long
            ]


viewPersonNodeData : PersonNodeData -> Html Msg
viewPersonNodeData nodeData =
    viewNodeInfos
        [ viewNodeLabel nodeData.labels
        , viewInfoLineText "Prénom" nodeData.firstName
        , viewInfoLineText "Nom" nodeData.lastName
        , viewInfoLineText "Pseudonymes" nodeData.aka
        , viewInfoLineUrl "Lien Ars Margica" nodeData.internalLink
        , viewInfoLineUrl "Lien externe" nodeData.externalLink
        ]


viewPublicationNodeData : PublicationNodeData -> Html Msg
viewPublicationNodeData nodeData =
    viewNodeInfos
        [ viewNodeLabel nodeData.labels
        , viewInfoLineText "Titre" nodeData.title
        , viewInfoLineText "TitreFr" nodeData.titleFr
        , viewInfoLineUrl "Lien Ars Margica" nodeData.internalLink
        , viewInfoLineUrl "Lien externe" nodeData.externalLink
        ]


viewValueNodeData : ValueNodeData -> Html Msg
viewValueNodeData nodeData =
    viewNodeInfos
        [ viewNodeLabel nodeData.labels
        , viewInfoLineText "Valeur" <| toString nodeData.value
        ]


viewNodeLabel : List String -> ListGroup.Item Msg
viewNodeLabel labels =
    viewInfoLineText "Label" (String.join "," labels)


viewInfoLineText : String -> String -> ListGroup.Item Msg
viewInfoLineText label value =
    viewInfoLine label value SimpleText


viewInfoLineUrl : String -> String -> ListGroup.Item Msg
viewInfoLineUrl label value =
    viewInfoLine label value Url


viewInfoLine : String -> String -> TextType -> ListGroup.Item Msg
viewInfoLine label value textType =
    let
        text_ =
            case textType of
                SimpleText ->
                    text <| value

                Url ->
                    a [ href value ] [ text <| value ]
    in
        ListGroup.li
            [ ListGroup.attrs [ class "element-border-infos p-1 bg-white" ] ]
            [ Grid.row [ Row.attrs [ class "border-bottom" ] ]
                [ Grid.col [ Col.lg ] [ text <| label ++ ": " ]
                , Grid.col [ Col.lg8 ] [ text_ ]
                ]
            ]
