module Pages.Home_ exposing (Model, Msg, page)

import Contact
import Css
import Css.Global
import Css.Transitions
import Gen.Params.Home_ exposing (Params)
import Gen.Route
import Html.Styled exposing (a, button, div, h1, hr, img, input, strong, text, ul)
import Html.Styled.Attributes exposing (css, href, placeholder, src)
import Html.Styled.Events exposing (onClick)
import Page
import Request
import Shared
import Themes exposing (Theme)
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
    Page.element
        { init = init
        , update = update
        , view = view shared.theme
        , subscriptions = subscriptions
        }



-- INIT


type alias Model =
    { sortDirection : SortDirection
    , contacts : List Contact.Model
    }


type SortDirection
    = Asc
    | Desc


init : ( Model, Cmd Msg )
init =
    ( { sortDirection = Asc
      , contacts = Contact.mockContacts
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = ClickedToggleSortDirection


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ClickedToggleSortDirection ->
            ( { model
                | sortDirection =
                    case model.sortDirection of
                        Asc ->
                            Desc

                        Desc ->
                            Asc
              }
            , Cmd.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Theme -> Model -> View Msg
view theme model =
    [ searchBar theme "Pesquisar contato..."
    , header theme
    , hr
        [ css
            [ Css.margin2 (Css.rem 1) Css.zero
            , Css.height (Css.px 2)
            , Css.borderRadius (Css.px 1)
            , Css.color theme.colors.gray.light
            , Css.opacity (Css.num 0.2)
            ]
        ]
        []
    , ordenationButton theme model
    , ul
        [ css
            [ Css.listStyle Css.none
            , Css.displayFlex
            , Css.flexDirection Css.column
            ]
        ]
        (List.indexedMap (Contact.view theme) model.contacts)
    ]


searchBar : Theme -> String -> Html.Styled.Html msg
searchBar theme placeholderString =
    input
        [ css
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
        , placeholder placeholderString
        ]
        []


header : Theme -> Html.Styled.Html msg
header theme =
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
            [ text "3 contatos" ]
        , a
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
        ]


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
                            Asc ->
                                Css.deg 180

                            Desc ->
                                Css.deg 0
                        )
                    )
                , Css.Transitions.transition [ Css.Transitions.transform3 150 0 Css.Transitions.easeInOut ]
                ]
            ]
            []
        ]
