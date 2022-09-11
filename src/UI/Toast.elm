module UI.Toast exposing (Model, Status(..), Variant(..), duration, idle, view)

import Css
import Css.Animations
import Css.Transitions
import Html.Styled exposing (div, li, text)
import Html.Styled.Attributes exposing (css)
import Html.Styled.Keyed
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


view : Theme -> List ( Int, Model ) -> Html.Styled.Html msg
view theme toasts =
    Html.Styled.Keyed.ul
        []
        (toasts
            |> List.sortBy Tuple.first
            |> List.reverse
            |> List.indexedMap
                (\index ( toastId, toast ) ->
                    ( String.fromInt toastId
                    , viewSingle theme index toast
                    )
                )
        )


viewSingle :
    Theme
    -> Int
    -> Model
    -> Html.Styled.Html msg
viewSingle theme index model =
    let
        iconStyles =
            [ Css.marginRight (Css.px 8)
            , Css.alignSelf Css.flexStart
            ]

        timerAnimation =
            Css.Animations.keyframes
                [ ( 0, [ Css.Animations.transform [ Css.scaleX 1 ] ] )
                , ( 100, [ Css.Animations.transform [ Css.scaleX 0 ] ] )
                ]
    in
    li
        [ css
            [ Css.position Css.fixed
            , Css.bottom (Css.px 48)
            , Css.left (Css.pct 50)
            , Css.transform (Css.translateX (Css.pct -50))
            ]
        ]
        [ div
            [ css
                [ case model.status of
                    Idle ->
                        UI.Animations.fadeInFromBelow 10

                    Removing ->
                        UI.Animations.fadeOutAbove 10
                , Css.animationDuration (Css.ms 1000)
                ]
            ]
            [ div
                [ css
                    [ Css.position Css.relative
                    , Css.padding2 (Css.px 16) (Css.px 32)
                    , Css.fontWeight Css.bold
                    , Css.color theme.colors.white
                    , Css.borderRadius theme.borderRadius
                    , Css.displayFlex
                    , Css.alignItems Css.center
                    , Css.justifyContent Css.center
                    , Css.transforms
                        [ Css.translateY (Css.px (-12 * toFloat index))
                        , Css.translateY (Css.pct (-100 * toFloat index))
                        ]
                    , Css.Transitions.transition
                        [ Css.Transitions.transform 1000
                        ]
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
                    , Css.overflow Css.hidden
                    , Css.after
                        [ Css.property "content" "''"
                        , Css.position Css.absolute
                        , Css.bottom (Css.px 0)
                        , Css.left (Css.px 0)
                        , Css.width (Css.pct 100)
                        , Css.height (Css.px 2)
                        , Css.backgroundColor theme.colors.white
                        , Css.animationName timerAnimation
                        , Css.animationDuration (Css.ms duration)
                        , Css.animationIterationCount (Css.num 1)
                        , Css.property "animation-timing-function" "linear"
                        , Css.property "animation-fill-mode" "forwards"
                        , Css.property "transform-origin" "left"
                        ]
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
            ]
        ]


duration : Float
duration =
    3000
