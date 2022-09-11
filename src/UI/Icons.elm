module UI.Icons exposing (..)

import Css
import Html.Styled
import Html.Styled.Attributes
import Svg.Styled as Svg
import Svg.Styled.Attributes as SvgAttr


arrowSolid : List Css.Style -> Html.Styled.Html msg
arrowSolid styles =
    Svg.svg
        [ SvgAttr.width "10"
        , SvgAttr.height "7"
        , SvgAttr.css (Css.fill Css.transparent :: styles)
        ]
        [ Svg.path
            [ SvgAttr.d "M5.792 5.97a1 1 0 0 1-1.584 0L1.043 1.86A1 1 0 0 1 1.836.25h6.328a1 1 0 0 1 .793 1.61L5.792 5.97Z"
            , SvgAttr.css [ Css.fill Css.currentColor ]
            ]
            []
        ]


xCircle : List Css.Style -> Html.Styled.Html msg
xCircle styles =
    Svg.svg
        [ SvgAttr.width "25"
        , SvgAttr.height "25"
        , SvgAttr.viewBox "0 0 25 25"
        , SvgAttr.fill "none"
        , SvgAttr.css styles
        ]
        [ Svg.path
            [ SvgAttr.d "M12.5 22.2533C18.0228 22.2533 22.5 17.7762 22.5 12.2533C22.5 6.73049 18.0228 2.25334 12.5 2.25334C6.97715 2.25334 2.5 6.73049 2.5 12.2533C2.5 17.7762 6.97715 22.2533 12.5 22.2533Z"
            , SvgAttr.stroke "white"
            , SvgAttr.strokeWidth "2"
            , SvgAttr.strokeLinecap "round"
            , SvgAttr.strokeLinejoin "round"
            ]
            []
        , Svg.path
            [ SvgAttr.d "M15.5 9.25334L9.5 15.2533"
            , SvgAttr.stroke "white"
            , SvgAttr.strokeWidth "2"
            , SvgAttr.strokeLinecap "round"
            , SvgAttr.strokeLinejoin "round"
            ]
            []
        , Svg.path
            [ SvgAttr.d "M9.5 9.25334L15.5 15.2533"
            , SvgAttr.stroke "white"
            , SvgAttr.strokeWidth "2"
            , SvgAttr.strokeLinecap "round"
            , SvgAttr.strokeLinejoin "round"
            ]
            []
        ]


checkCircle : List Css.Style -> Html.Styled.Html msg
checkCircle styles =
    Svg.svg
        [ SvgAttr.width "24"
        , SvgAttr.height "25"
        , SvgAttr.viewBox "0 0 24 25"
        , SvgAttr.fill "none"
        , SvgAttr.css styles
        ]
        [ Svg.path
            [ SvgAttr.d "M22 11.1547V12.0747C21.9988 14.2311 21.3005 16.3293 20.0093 18.0565C18.7182 19.7836 16.9033 21.0471 14.8354 21.6586C12.7674 22.27 10.5573 22.1966 8.53447 21.4492C6.51168 20.7019 4.78465 19.3208 3.61096 17.5117C2.43727 15.7027 1.87979 13.5627 2.02168 11.411C2.16356 9.25923 2.99721 7.21099 4.39828 5.57174C5.79935 3.93248 7.69279 2.79005 9.79619 2.31481C11.8996 1.83957 14.1003 2.057 16.07 2.93466"
            , SvgAttr.stroke "white"
            , SvgAttr.strokeWidth "2"
            , SvgAttr.strokeLinecap "round"
            , SvgAttr.strokeLinejoin "round"
            ]
            []
        , Svg.path
            [ SvgAttr.d "M22 4.07468L12 14.0847L9 11.0847"
            , SvgAttr.stroke "white"
            , SvgAttr.strokeWidth "2"
            , SvgAttr.strokeLinecap "round"
            , SvgAttr.strokeLinejoin "round"
            ]
            []
        ]
