module UI.Animations exposing (fadeInFromBelow, fadeOutAbove, pulse)

import Css
import Css.Animations


pulse : Int -> Css.Style
pulse index =
    let
        keyframes =
            Css.Animations.keyframes
                [ ( 0, [ Css.Animations.opacity (Css.num 0.7) ] )
                , ( 50, [ Css.Animations.opacity (Css.num 0.3) ] )
                , ( 100, [ Css.Animations.opacity (Css.num 0.7) ] )
                ]
    in
    Css.batch
        [ Css.animationName keyframes
        , Css.animationDuration (Css.ms 2000)
        , Css.animationDelay (Css.ms (100 * toFloat index))
        , Css.animationIterationCount Css.infinite
        ]


fadeInFromBelow : Float -> Css.Style
fadeInFromBelow translationAmount =
    let
        keyframes =
            Css.Animations.keyframes
                [ ( 0
                  , [ Css.Animations.opacity (Css.num 0)
                    , Css.Animations.transform [ Css.translateY (Css.px translationAmount) ]
                    ]
                  )
                , ( 100
                  , [ Css.Animations.opacity (Css.num 1)
                    , Css.Animations.transform [ Css.translateY (Css.px 0) ]
                    ]
                  )
                ]
    in
    Css.batch
        [ Css.animationName keyframes
        , Css.animationIterationCount (Css.num 1)
        ]


fadeOutAbove : Float -> Css.Style
fadeOutAbove translationAmount =
    let
        keyframes =
            Css.Animations.keyframes
                [ ( 0
                  , [ Css.Animations.opacity (Css.num 1)
                    , Css.Animations.transform [ Css.translateY (Css.px 0) ]
                    ]
                  )
                , ( 100
                  , [ Css.Animations.opacity (Css.num 0)
                    , Css.Animations.transform [ Css.translateY (Css.px -translationAmount) ]
                    ]
                  )
                ]
    in
    Css.batch
        [ Css.animationName keyframes
        , Css.animationIterationCount (Css.num 1)
        ]
