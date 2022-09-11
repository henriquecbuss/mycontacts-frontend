module UI.Toast exposing (Model, Status(..), Variant(..), duration, idle, view)

import Css
import Css.Animations
import Css.Transitions
import Html.Styled exposing (button, div, li, text)
import Html.Styled.Attributes exposing (css)
import Html.Styled.Events exposing (onClick)
import Html.Styled.Keyed
import Json.Encode
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


view : Theme -> List ( String, { onRemove : msg, toast : Model } ) -> Html.Styled.Html msg
view theme toasts =
    Html.Styled.Keyed.ul
        [ css [ Css.property "isolation" "isolate" ]
        ]
        (toasts
            |> List.sortBy Tuple.first
            |> List.reverse
            |> List.indexedMap
                (\index ( toastId, { onRemove, toast } ) ->
                    ( toastId
                    , viewSingle theme index onRemove toast
                    )
                )
        )


viewSingle :
    Theme
    -> Int
    -> msg
    -> Model
    -> Html.Styled.Html msg
viewSingle theme index onRemove model =
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
            , Css.listStyle Css.none
            , Css.zIndex (Css.int (999999 - index))
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
            [ button
                [ css
                    [ Css.position Css.relative
                    , Css.padding2 (Css.px 16) (Css.px 32)
                    , Css.fontWeight Css.bold
                    , Css.color theme.colors.white
                    , Css.borderRadius theme.borderRadius
                    , Css.displayFlex
                    , Css.alignItems Css.center
                    , Css.justifyContent Css.center
                    , Css.cursor Css.pointer
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
                    , Css.hover
                        [ case model.variant of
                            Default ->
                                Css.backgroundColor theme.colors.primary.light

                            Error ->
                                Css.backgroundColor theme.colors.danger.light

                            Success ->
                                Css.backgroundColor theme.colors.success.light
                        ]
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
                , case model.status of
                    Idle ->
                        onClick onRemove

                    Removing ->
                        css []
                , Html.Styled.Attributes.property "role" (Json.Encode.string "alert")
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
