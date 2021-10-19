module Pages.Home_ exposing (Model, Msg, page)

import Css
import Css.Transitions
import Gen.Params.Home_ exposing (Params)
import Gen.Route
import Html.Styled exposing (a, div, h1, hr, input, strong, text)
import Html.Styled.Attributes exposing (css, href, placeholder)
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
    {}


init : ( Model, Cmd Msg )
init =
    ( {}, Cmd.none )



-- UPDATE


type Msg
    = ReplaceMe


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ReplaceMe ->
            ( model, Cmd.none )



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

            -- TODO - Use new route when it's ready
            , href (Gen.Route.toHref Gen.Route.Home_)
            ]
            [ text "Novo contato" ]
        ]
