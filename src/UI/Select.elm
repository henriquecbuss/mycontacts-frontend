module UI.Select exposing (Option, init, view, withOption, withOptions, withValue)

import Css
import Css.Global
import Css.Transitions
import Html.Styled exposing (small, text)
import Html.Styled.Attributes exposing (css)
import Html.Styled.Events
import List.Extra
import Themes exposing (Theme)
import UI.Icons


type Select constraints value msg
    = Select
        { label : String
        , id : String
        , value : Maybe value
        , onInput : Maybe value -> msg
        , error : Maybe String
        , options : List (Option value)
        }


type alias Option value =
    { label : String, value : value }


init :
    { label : String
    , id : String
    , onInput : Maybe value -> msg
    }
    -> Select {} value msg
init options =
    Select
        { label = options.label
        , id = options.id
        , value = Nothing
        , onInput = options.onInput
        , error = Nothing
        , options = []
        }


withOption :
    Option value
    -> Select contraints value msg
    -> Select { constraints | hasOption : () } value msg
withOption option (Select select) =
    Select { select | options = option :: select.options }


withOptions :
    (value -> Option value)
    -> List value
    -> Select constraints value msg
    -> Select { constraints | hasOption : () } value msg
withOptions toOption values (Select select) =
    Select { select | options = List.map toOption values ++ select.options }


withValue : Maybe value -> Select contraints value msg -> Select constraints value msg
withValue value (Select select) =
    Select { select | value = value }


view : Theme -> Select { hasOption : () } value msg -> Html.Styled.Html msg
view theme (Select select) =
    let
        hasError =
            case select.error of
                Nothing ->
                    False

                Just _ ->
                    True

        hasValue =
            case select.value of
                Nothing ->
                    False

                Just _ ->
                    True

        placeholderColor =
            if hasError then
                theme.colors.danger.main

            else if hasValue then
                theme.colors.foreground

            else
                theme.colors.gray.light

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
            if hasValue then
                theme.colors.foreground

            else
                Css.rgba 0 0 0 0

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

        inputHandler : String -> msg
        inputHandler inputValue =
            select.options
                |> List.Extra.find (\option -> option.label == inputValue)
                |> Maybe.map .value
                |> select.onInput
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
                , Css.Global.descendants
                    [ Css.Global.svg
                        [ Css.color focusedOutlineColor
                        ]
                    ]
                ]
            ]
        ]
        [ Html.Styled.label
            [ Html.Styled.Attributes.for select.id
            , css
                [ Css.position Css.absolute
                , Css.cursor Css.text_
                , Css.color placeholderColor
                , Css.transform (Css.translate2 (Css.px 16) (Css.px 16))
                , Css.Transitions.transition
                    [ Css.Transitions.transform3 75 0 Css.Transitions.linear
                    ]
                , if hasValue then
                    labelShownLabelStyle

                  else
                    Css.batch []
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
            [ Html.Styled.text select.label ]
        , Html.Styled.select
            [ Html.Styled.Attributes.value
                (select.value
                    |> Maybe.andThen (\currentValue -> List.Extra.find (\option -> option.value == currentValue) select.options)
                    |> Maybe.map .label
                    |> Maybe.withDefault ""
                )
            , Html.Styled.Events.onInput inputHandler
            , Html.Styled.Attributes.id select.id
            , Html.Styled.Attributes.placeholder select.label
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
            (Html.Styled.option [] []
                :: List.map
                    (\option ->
                        Html.Styled.option []
                            [ text option.label
                            ]
                    )
                    select.options
            )
        , Html.Styled.div
            [ css
                [ Css.position Css.absolute
                , Css.top Css.zero
                , Css.bottom Css.zero
                , Css.right Css.zero
                , Css.backgroundColor theme.colors.white
                , Css.padding2 Css.zero (Css.rem 1)
                , Css.borderRadius theme.borderRadius
                , Css.displayFlex
                , Css.alignItems Css.center
                , Css.justifyContent Css.center
                ]
            ]
            [ UI.Icons.arrowSolid
                [ Css.color inputColor
                , Css.Transitions.transition
                    [ Css.Transitions.color3 75 0 Css.Transitions.linear
                    ]
                ]
            ]
        , case select.error of
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
