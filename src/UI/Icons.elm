module UI.Icons exposing (..)

import Css exposing (fill)
import Html.Styled
import Html.Styled.Attributes exposing (height, width)
import Svg.Styled exposing (path, svg)
import Svg.Styled.Attributes exposing (css, d)


arrowSolid : List Css.Style -> Html.Styled.Html msg
arrowSolid styles =
    svg [ width 10, height 7, css (fill Css.transparent :: styles) ]
        [ path
            [ d "M5.792 5.97a1 1 0 0 1-1.584 0L1.043 1.86A1 1 0 0 1 1.836.25h6.328a1 1 0 0 1 .793 1.61L5.792 5.97Z"
            , css [ fill Css.currentColor ]
            ]
            []
        ]
