module UI.Toast exposing (Model, Status(..), Variant(..), idle, view)

import Css
import Html.Styled exposing (div, text)
import Html.Styled.Attributes exposing (css)
import Themes exposing (Theme)
import UI.Animations
import UI.Icons


type Variant
    = Default
    | Error
    | Success


type Status
    = Idle
    | Removing


type alias Model =
    { variant : Variant
    , message : String
    , status : Status
    }


idle : Variant -> String -> Model
idle variant message =
    { variant = variant
    , message = message
    , status = Idle
    }


view : Theme -> List Model -> Html.Styled.Html msg
view theme toasts =
    div
        [ css
            [ Css.position Css.fixed
            , Css.bottom (Css.px 48)
            , Css.left (Css.pct 50)
            , Css.transform (Css.translateX (Css.pct -50))
            , Css.displayFlex
            , Css.flexDirection Css.column
            , Css.alignItems Css.center
            , Css.property "gap" "12px"
            ]
        ]
        (List.map (viewSingle theme) toasts)


viewSingle :
    Theme
    -> Model
    -> Html.Styled.Html msg
viewSingle theme model =
    let
        iconStyles =
            [ Css.marginRight (Css.px 8)
            ]
    in
    div
        [ css
            [ Css.padding2 (Css.px 16) (Css.px 32)
            , Css.fontWeight Css.bold
            , Css.color theme.colors.white
            , Css.borderRadius theme.borderRadius
            , Css.displayFlex
            , Css.alignItems Css.center
            , Css.justifyContent Css.center
            , case model.variant of
                Default ->
                    Css.backgroundColor theme.colors.primary.main

                Error ->
                    Css.backgroundColor theme.colors.danger.main

                Success ->
                    Css.backgroundColor theme.colors.success.main
            , Css.boxShadow5 (Css.px 0)
                (Css.px 20)
                (Css.px 20)
                (Css.px -16)
                (Css.hex "00000040")
            , Css.animationDuration (Css.ms 1000)
            , case model.status of
                Idle ->
                    UI.Animations.fadeInFromBelow 10

                Removing ->
                    UI.Animations.fadeOutAbove 10
            ]
        ]
        [ case model.variant of
            Default ->
                text ""

            Error ->
                UI.Icons.xCircle iconStyles

            Success ->
                UI.Icons.checkCircle iconStyles
        , text model.message
        ]
