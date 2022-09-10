module Pages.Home_ exposing (Model, Msg, page)

import Api.Contact
import Api.HttpClient
import Contact
import Css
import Css.Global
import Css.Transitions
import Gen.Params.Home_ exposing (Params)
import Gen.Route
import Html.Styled exposing (a, br, button, div, h1, h2, hr, img, input, p, span, strong, text)
import Html.Styled.Attributes as Attributes exposing (css, href, placeholder, src)
import Html.Styled.Events as Events exposing (onClick)
import Html.Styled.Keyed
import Page
import Request
import Shared
import Themes exposing (Theme)
import UI
import UI.Modal
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared _ =
    Page.element
        { init = init
        , update = update
        , view = view shared.theme
        , subscriptions = subscriptions
        }



-- INIT


type alias Model =
    { sortDirection : Api.HttpClient.SortDirection
    , search : String
    , contacts : ContactsStatus
    , deletingContact : Maybe Contact.Model
    }


type ContactsStatus
    = Loading
    | Loaded (List Contact.Model)
    | WithError Api.HttpClient.Error


init : ( Model, Cmd Msg )
init =
    let
        defaultSortDirection =
            Api.HttpClient.Asc
    in
    ( { sortDirection = defaultSortDirection
      , search = ""
      , contacts = Loading
      , deletingContact = Nothing
      }
    , Api.Contact.list defaultSortDirection CompletedLoadContacts
    )



-- UPDATE


type Msg
    = ClickedToggleSortDirection
    | CompletedLoadContacts (Api.HttpClient.Response (List Contact.Model))
    | RequestedRetryContacts
    | EnteredSearchTerm String
    | ClosedModal
    | ClickedDeleteContact Contact.Model
    | ConfirmedDeleteContact Contact.Model
    | CompletedDeleteContact (Api.HttpClient.Response ())


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ClickedToggleSortDirection ->
            let
                newSortDirection =
                    case model.sortDirection of
                        Api.HttpClient.Asc ->
                            Api.HttpClient.Desc

                        Api.HttpClient.Desc ->
                            Api.HttpClient.Asc
            in
            ( { model
                | sortDirection = newSortDirection
                , contacts = Loading
              }
            , Api.Contact.list newSortDirection CompletedLoadContacts
            )

        CompletedLoadContacts response ->
            ( { model
                | contacts =
                    case response of
                        Ok contacts ->
                            Loaded contacts

                        Err err ->
                            WithError err
              }
            , Cmd.none
            )

        RequestedRetryContacts ->
            ( { model | contacts = Loading }
            , Api.Contact.list model.sortDirection CompletedLoadContacts
            )

        EnteredSearchTerm searchTerm ->
            ( { model | search = searchTerm }, Cmd.none )

        ClosedModal ->
            ( { model | deletingContact = Nothing }, Cmd.none )

        ClickedDeleteContact contact ->
            ( { model | deletingContact = Just contact }, Cmd.none )

        ConfirmedDeleteContact contact ->
            ( { model
                | contacts = Loading
                , deletingContact = Nothing
              }
            , Api.Contact.delete contact CompletedDeleteContact
            )

        CompletedDeleteContact _ ->
            ( model, Api.Contact.list model.sortDirection CompletedLoadContacts )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


getContacts : Model -> ContactsStatus
getContacts model =
    case model.contacts of
        Loading ->
            Loading

        WithError err ->
            WithError err

        Loaded contacts_ ->
            contacts_
                |> List.filter
                    (Contact.getName
                        >> String.toLower
                        >> String.contains (String.toLower model.search)
                    )
                |> Loaded


hasNoContacts : Model -> Bool
hasNoContacts model =
    case model.contacts of
        Loaded contacts ->
            List.isEmpty contacts

        _ ->
            False


viewDeleteContactModal : Theme -> Model -> Html.Styled.Html Msg
viewDeleteContactModal theme model =
    case model.deletingContact of
        Just contact ->
            UI.Modal.init ClosedModal
                |> UI.Modal.withHeader
                    ("Tem certeza que deseja remover o contato \""
                        ++ Contact.getName contact
                        ++ "\"?"
                    )
                |> UI.Modal.withBody "Esta ação não poderá ser desfeita!"
                |> UI.Modal.withAction "Deletar" (ConfirmedDeleteContact contact)
                |> UI.Modal.withVariant UI.Danger
                |> UI.Modal.view theme

        Nothing ->
            text ""


viewHeader : Theme -> Model -> List (Html.Styled.Html Msg)
viewHeader theme model =
    if hasNoContacts model then
        [ div
            [ css [ Css.displayFlex, Css.justifyContent Css.center ]
            ]
            [ newContactButton theme ]
        ]

    else
        [ searchBar theme model.search "Pesquisar contato..."
        , header theme (getContacts model)
        ]


viewBody : Theme -> Model -> List (Html.Styled.Html Msg)
viewBody theme model =
    if hasNoContacts model then
        [ div
            [ css
                [ Css.paddingLeft (Css.px 50)
                , Css.paddingRight (Css.px 50)
                , Css.displayFlex
                , Css.flexDirection Css.column
                , Css.alignItems Css.center
                ]
            ]
            [ img [ src "/icons/emptyBox.svg" ] []
            , p
                [ css
                    [ Css.color theme.colors.gray.light
                    , Css.textAlign Css.center
                    , Css.marginTop (Css.rem 1)
                    ]
                ]
                [ text "Você ainda não tem nenhum contato cadastrado!"
                , br [] []
                , text "Clique no botão "
                , span
                    [ css
                        [ Css.color theme.colors.primary.main
                        , Css.fontWeight Css.bold
                        ]
                    ]
                    [ text "\"Novo contato\"" ]
                , text " acima para cadastrar o seu primeiro contato!"
                ]
            ]
        ]

    else
        [ case getContacts model of
            WithError _ ->
                text ""

            Loading ->
                ordenationButton theme model

            Loaded contacts ->
                if List.isEmpty contacts then
                    text ""

                else
                    ordenationButton theme model
        , case getContacts model of
            Loading ->
                Html.Styled.Keyed.ul
                    [ css
                        [ Css.listStyle Css.none
                        , Css.displayFlex
                        , Css.flexDirection Css.column
                        ]
                    ]
                    (List.range 1 5
                        |> List.map
                            (\index ->
                                ( String.fromInt index
                                , Contact.viewLoading theme index
                                )
                            )
                    )

            Loaded contacts ->
                if List.isEmpty contacts then
                    div [ css [ Css.displayFlex, Css.alignItems Css.flexStart ] ]
                        [ img
                            [ src "/icons/magnifyingGlassQuestion.svg"
                            , css [ Css.marginRight (Css.rem 1.5) ]
                            ]
                            []
                        , p
                            [ css
                                [ Css.fontWeight Css.normal
                                , Css.color theme.colors.gray.light
                                ]
                            ]
                            [ text "Nenhum resultado encontrado para "
                            , strong
                                [ css [ Css.property "word-break" "break-word" ]
                                ]
                                [ text ("\"" ++ model.search ++ "\"") ]
                            ]
                        ]

                else
                    Html.Styled.Keyed.ul
                        [ css
                            [ Css.listStyle Css.none
                            , Css.displayFlex
                            , Css.flexDirection Css.column
                            ]
                        ]
                        (contacts
                            |> List.indexedMap
                                (\index contact ->
                                    Contact.view theme
                                        index
                                        ClickedDeleteContact
                                        contact
                                )
                        )

            WithError _ ->
                div
                    [ css
                        [ Css.displayFlex
                        , Css.alignItems Css.center
                        , Css.padding3 Css.zero (Css.rem 0.5) Css.zero
                        ]
                    ]
                    [ img
                        [ src "/icons/sadFace.svg"
                        , css
                            []
                        ]
                        []
                    , div
                        [ css
                            [ Css.marginLeft (Css.px 28)
                            ]
                        ]
                        [ h1
                            [ css
                                [ Css.color theme.colors.danger.dark
                                , Css.fontSize (Css.rem 1.5)
                                ]
                            ]
                            [ text "Ocorreu um erro ao obter os seus contatos!" ]
                        , UI.button theme
                            UI.Primary
                            { onClick = Just RequestedRetryContacts, disabled = False }
                            [ Css.marginTop (Css.rem 0.5) ]
                            [ text "Tentar obter novamente" ]
                        ]
                    ]
        ]


view : Theme -> Model -> View Msg
view theme model =
    List.concat
        [ [ viewDeleteContactModal theme model ]
        , viewHeader theme model
        , [ hr
                [ css
                    [ Css.margin2 (Css.rem 1) Css.zero
                    , Css.height (Css.px 2)
                    , Css.borderRadius (Css.px 1)
                    , Css.color theme.colors.gray.light
                    , Css.opacity (Css.num 0.2)
                    ]
                ]
                []
          ]
        , viewBody theme model
        ]


searchBar : Theme -> String -> String -> Html.Styled.Html Msg
searchBar theme value placeholderString =
    input
        [ Attributes.value value
        , Events.onInput EnteredSearchTerm
        , placeholder placeholderString
        , css
            [ Css.width (Css.pct 100)
            , Css.padding (Css.rem 1)
            , Css.borderRadius (Css.px 25)
            , Css.border Css.zero
            , Css.boxShadow4 Css.zero (Css.px 4) (Css.px 10) (Css.rgba 0 0 0 0.04)
            , Css.outline Css.none
            , Css.focus
                [ Css.outline3 theme.borderWidth Css.solid theme.colors.primary.main
                ]
            , Css.pseudoElement "placeholder"
                [ Css.color theme.colors.gray.light
                ]
            ]
        ]
        []


header : Theme -> ContactsStatus -> Html.Styled.Html msg
header theme contactsStatus =
    div
        [ css
            [ Css.displayFlex
            , Css.justifyContent Css.spaceBetween
            , Css.alignItems Css.center
            , Css.marginTop (Css.rem 2)
            , Css.width (Css.pct 100)
            ]
        ]
        [ h1 [ css [ Css.fontSize (Css.rem 1.5) ] ]
            [ case contactsStatus of
                Loading ->
                    text ""

                Loaded contacts ->
                    if List.length contacts == 1 then
                        text "1 contato"

                    else
                        text (String.fromInt (List.length contacts) ++ " contatos")

                WithError _ ->
                    text ""
            ]
        , newContactButton theme
        ]


newContactButton : Theme -> Html.Styled.Html msg
newContactButton theme =
    a
        [ css
            [ Css.backgroundColor theme.colors.background
            , Css.padding2 (Css.px 12) (Css.px 16)
            , Css.fontWeight Css.bold
            , Css.color theme.colors.primary.main
            , Css.textDecoration Css.none
            , Css.border3 theme.borderWidth Css.solid theme.colors.primary.main
            , Css.borderRadius theme.borderRadius
            , Css.cursor Css.pointer
            , Css.Transitions.transition
                [ Css.Transitions.backgroundColor3 150 0 Css.Transitions.easeIn
                , Css.Transitions.color3 150 0 Css.Transitions.easeIn
                ]
            , Css.hover
                [ Css.backgroundColor theme.colors.primary.main
                , Css.color theme.colors.background
                ]
            , Css.active
                [ Css.backgroundColor theme.colors.primary.light
                ]
            ]
        , href (Gen.Route.toHref Gen.Route.New)
        ]
        [ text "Novo contato" ]


ordenationButton : Theme -> Model -> Html.Styled.Html Msg
ordenationButton theme model =
    button
        [ onClick ClickedToggleSortDirection
        , css
            [ Css.backgroundColor Css.transparent
            , Css.border Css.zero
            , Css.displayFlex
            , Css.alignItems Css.center
            , Css.marginBottom (Css.rem 0.5)
            , Css.cursor Css.pointer
            , Css.color theme.colors.primary.main
            , Css.hover
                [ Css.color theme.colors.primary.light
                , Css.Global.children [ Css.Global.img [ Css.opacity (Css.num 0.8) ] ]
                ]
            , Css.active
                [ Css.color theme.colors.primary.dark
                , Css.Global.children [ Css.Global.img [ Css.opacity (Css.num 1) ] ]
                ]
            ]
        ]
        [ strong [] [ text "Nome" ]
        , img
            [ src "/icons/arrowUp.svg"
            , css
                [ Css.marginLeft (Css.rem 0.5)
                , Css.transform
                    (Css.rotateX
                        (case model.sortDirection of
                            Api.HttpClient.Asc ->
                                Css.deg 180

                            Api.HttpClient.Desc ->
                                Css.deg 0
                        )
                    )
                , Css.Transitions.transition [ Css.Transitions.transform3 150 0 Css.Transitions.easeInOut ]
                ]
            ]
            []
        ]
