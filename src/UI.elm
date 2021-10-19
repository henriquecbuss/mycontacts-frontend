module UI exposing (input)

import Css
import Css.Global
import Css.Transitions
import Html.Styled exposing (small, text)
import Html.Styled.Attributes exposing (css)
import Html.Styled.Events
import Themes exposing (Theme)


input :
    Theme
    ->
        { label : String
        , id : String
        , value : String
        , onInput : String -> msg
        , error : Maybe String
        }
    -> Html.Styled.Html msg
input theme { label, id, value, onInput, error } =
    let
        hasError =
            case error of
                Nothing ->
                    False

                Just _ ->
                    True

        placeholderColor =
            if hasError then
                theme.colors.danger.main

            else if String.isEmpty value then
                theme.colors.gray.light

            else
                theme.colors.foreground

        focusedPlaceholderColor =
            if hasError then
                theme.colors.danger.main

            else
                theme.colors.primary.main

        inputColor =
            if hasError then
                theme.colors.danger.main

            else
                theme.colors.foreground

        outlineColor =
            if String.isEmpty value then
                Css.rgba 0 0 0 0

            else
                theme.colors.foreground

        focusedOutlineColor =
            if hasError then
                theme.colors.danger.main

            else
                theme.colors.primary.main

        sidePadding =
            4

        labelShownLabelStyle =
            Css.batch
                [ Css.transform (Css.translate2 (Css.px 8) (Css.px -12))
                ]
    in
    Html.Styled.div
        [ css
            [ Css.position Css.relative
            , Css.pseudoClass "focus-within"
                [ Css.Global.children
                    [ Css.Global.label
                        [ labelShownLabelStyle
                        , Css.color focusedPlaceholderColor
                        ]
                    ]
                ]
            ]
        ]
        [ Html.Styled.label
            [ Html.Styled.Attributes.for id
            , css
                [ Css.position Css.absolute
                , Css.cursor Css.text_
                , Css.color placeholderColor
                , Css.transform (Css.translate2 (Css.px 16) (Css.px 16))
                , Css.Transitions.transition
                    [ Css.Transitions.transform3 75 0 Css.Transitions.linear
                    ]
                , if String.isEmpty value then
                    Css.batch []

                  else
                    labelShownLabelStyle
                , Css.after
                    [ Css.property "content" "''"
                    , Css.zIndex (Css.int -1)
                    , Css.position Css.absolute
                    , Css.top (Css.pct 50)
                    , Css.right (Css.px -sidePadding)
                    , Css.transform (Css.translateY (Css.pct -50))
                    , Css.height theme.borderWidth
                    , Css.width (Css.calc (Css.pct 100) Css.plus (Css.px (2 * sidePadding)))
                    , Css.backgroundColor theme.colors.white
                    ]
                ]
            ]
            [ Html.Styled.text label ]
        , Html.Styled.input
            [ Html.Styled.Attributes.value value
            , Html.Styled.Events.onInput onInput
            , Html.Styled.Attributes.id id
            , Html.Styled.Attributes.placeholder label
            , css
                [ Css.padding (Css.rem 1)
                , Css.width (Css.pct 100)
                , Css.outline3 theme.borderWidth Css.solid outlineColor
                , Css.border Css.zero
                , Css.borderRadius theme.borderRadius
                , Css.boxShadow4 Css.zero (Css.px 4) (Css.px 10) (Css.rgba 0 0 0 0.04)
                , Css.color inputColor
                , Css.focus
                    [ Css.outlineColor focusedOutlineColor
                    ]
                , Css.pseudoElement "placeholder"
                    [ Css.color placeholderColor
                    ]
                ]
            ]
            []
        , case error of
            Nothing ->
                text ""

            Just errorMessage ->
                small
                    [ css
                        [ Css.color theme.colors.danger.main
                        , Css.display Css.inlineBlock
                        , Css.fontSize (Css.rem 0.75)
                        , Css.marginTop (Css.rem 0.5)
                        ]
                    ]
                    [ text errorMessage ]
        ]
