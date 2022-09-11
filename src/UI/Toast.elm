module UI.Toast exposing (Model, Status(..), Variant(..), defaultDuration, idle, view)

import Css
import Css.Animations
import Css.Transitions
import Html.Styled exposing (button, div, li, text)
import Html.Styled.Attributes exposing (css)
import Html.Styled.Events
import Html.Styled.Keyed
import Json.Decode
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


view :
    Theme
    ->
        List
            ( String
            , { onStartRemoving : msg
              , onFinishedRemoving : msg
              , duration : Css.Duration {}
              , toast : Model
              }
            )
    -> Html.Styled.Html msg
view theme toasts =
    Html.Styled.Keyed.ul
        [ css [ Css.property "isolation" "isolate" ]
        ]
        (toasts
            |> List.sortBy Tuple.first
            |> List.reverse
            |> List.indexedMap
                (\index ( toastId, { toast } as options ) ->
                    ( toastId
                    , viewSingle theme
                        { index = index
                        , duration = options.duration
                        , onStartRemoving = options.onStartRemoving
                        , onFinishedRemoving = options.onFinishedRemoving
                        }
                        toast
                    )
                )
        )


viewSingle :
    Theme
    ->
        { index : Int
        , duration : Css.Duration {}
        , onStartRemoving : msg
        , onFinishedRemoving : msg
        }
    -> Model
    -> Html.Styled.Html msg
viewSingle theme options model =
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
            , Css.zIndex (Css.int (999999 - options.index))
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
            , case model.status of
                Idle ->
                    css []

                Removing ->
                    Html.Styled.Events.on "animationend"
                        (Json.Decode.succeed options.onFinishedRemoving)
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
                        [ Css.translateY (Css.px (-12 * toFloat options.index))
                        , Css.translateY (Css.pct (-100 * toFloat options.index))
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
                        , Css.after
                            [ Css.property "animation-play-state" "paused" ]
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
                        , Css.animationDuration options.duration
                        , Css.animationIterationCount (Css.num 1)
                        , Css.property "animation-timing-function" "linear"
                        , Css.property "animation-fill-mode" "forwards"
                        , Css.property "transform-origin" "left"
                        ]
                    ]
                , case model.status of
                    Idle ->
                        Html.Styled.Events.onClick options.onStartRemoving

                    Removing ->
                        css []
                , Html.Styled.Attributes.property "role" (Json.Encode.string "alert")
                , Html.Styled.Events.on "animationend" (Json.Decode.succeed options.onStartRemoving)
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


defaultDuration : Css.Duration {}
defaultDuration =
    Css.ms 3000
