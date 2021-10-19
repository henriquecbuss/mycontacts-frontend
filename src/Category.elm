module Category exposing (Category(..), list, toString, view)

import Css
import Html.Styled exposing (small, text)
import Html.Styled.Attributes exposing (css)
import Themes exposing (Theme)


type
    Category
    -- TODO - Not expose (..)
    = Instagram
    | LinkedIn
    | GitHub


toString : Category -> String
toString category =
    case category of
        Instagram ->
            "Instagram"

        LinkedIn ->
            "LinkedIn"

        GitHub ->
            "GitHub"


list : List Category
list =
    [ Instagram, LinkedIn, GitHub ]


view : Theme -> Category -> Html.Styled.Html msg
view theme category =
    small
        [ css
            [ Css.backgroundColor theme.colors.primary.lightest
            , Css.color theme.colors.primary.main
            , Css.padding2 (Css.px 3) (Css.px 6)
            , Css.borderRadius theme.borderRadius
            , Css.fontWeight Css.bold
            , Css.fontSize (Css.rem 0.75)
            , Css.textTransform Css.uppercase
            ]
        ]
        [ text (toString category) ]
