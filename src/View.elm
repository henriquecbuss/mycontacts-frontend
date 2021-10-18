module View exposing (View, map, none, placeholder, toBrowserDocument)

import Browser
import Css exposing (backgroundColor, borderBox, boxSizing, color, fontFamilies, fontFamily, fontSize, margin, padding, px, sansSerif, zero)
import Css.Global exposing (body, everything, global)
import Html.Styled exposing (div)
import Themes exposing (Theme)


type alias View msg =
    List (Html.Styled.Html msg)


placeholder : String -> View msg
placeholder str =
    [ Html.Styled.text str ]


none : View msg
none =
    placeholder ""


map : (a -> b) -> View a -> View b
map fn view =
    List.map (Html.Styled.map fn) view


toBrowserDocument : Theme -> View msg -> Browser.Document msg
toBrowserDocument theme view =
    { title = "MyContacts"
    , body =
        [ global
            [ everything
                [ margin zero
                , padding zero
                , boxSizing borderBox
                , fontFamilies [ "Sora", sansSerif.value ]
                , fontSize (px 16)
                ]
            , body
                [ backgroundColor theme.colors.background
                , color theme.colors.foreground
                ]
            ]
        , defaultContainer view
        ]
            |> List.map Html.Styled.toUnstyled
    }


defaultContainer : List (Html.Styled.Html msg) -> Html.Styled.Html msg
defaultContainer children =
    div []
        []
