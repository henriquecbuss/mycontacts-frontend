module UI.Animations exposing (pulse)

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
