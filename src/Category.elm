module Category exposing (Category(..), decoder, fromString, list, toString, view)

import Css
import Html.Styled exposing (small, text)
import Html.Styled.Attributes exposing (css)
import Json.Decode as Decode exposing (Decoder)
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


fromString : String -> Maybe Category
fromString category =
    case category of
        "Instagram" ->
            Just Instagram

        "LinkedIn" ->
            Just LinkedIn

        "GitHub" ->
            Just GitHub

        _ ->
            Nothing


decoder : Decoder Category
decoder =
    Decode.string
        |> Decode.andThen
            (\stringCategory ->
                case String.toLower stringCategory of
                    "instagram" ->
                        Decode.succeed Instagram

                    "linkedin" ->
                        Decode.succeed LinkedIn

                    "github" ->
                        Decode.succeed GitHub

                    _ ->
                        Decode.fail "Expecting valid category"
            )


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
