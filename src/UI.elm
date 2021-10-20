module UI exposing (button)

import Css
import Html.Styled
import Html.Styled.Attributes as Attributes
import Html.Styled.Events as Events
import Themes exposing (Theme)


button :
    Theme
    -> { onClick : Maybe msg, disabled : Bool }
    -> List Css.Style
    -> List (Html.Styled.Html msg)
    -> Html.Styled.Html msg
button theme { onClick, disabled } styles children =
    Html.Styled.button
        [ optionalAttribute Events.onClick onClick
        , Attributes.disabled disabled
        , Attributes.css
            (Css.backgroundColor theme.colors.primary.main
                :: Css.color theme.colors.white
                :: Css.outline Css.none
                :: Css.border Css.zero
                :: Css.borderRadius theme.borderRadius
                :: Css.padding (Css.rem 1)
                :: Css.fontWeight Css.bold
                :: Css.cursor Css.pointer
                :: styles
            )
        ]
        children



-- UTILS


optionalAttribute : (a -> Html.Styled.Attribute msg) -> Maybe a -> Html.Styled.Attribute msg
optionalAttribute attr maybeValue =
    case maybeValue of
        Nothing ->
            Attributes.class ""

        Just value ->
            attr value
