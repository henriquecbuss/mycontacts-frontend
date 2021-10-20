module UI.Form exposing (viewConfig)

import Css
import Css.Global
import Css.Transitions
import Form.Error
import Form.View
import Html.Styled exposing (small, text)
import Html.Styled.Attributes as Attributes exposing (css)
import Html.Styled.Events as Events
import Themes exposing (Theme)
import UI
import UI.Icons


viewConfig : Theme -> Form.View.CustomConfig msg (Html.Styled.Html msg)
viewConfig theme =
    { form = form theme
    , textField = inputField theme "text"
    , emailField = inputField theme "email"
    , passwordField = inputField theme "password"
    , searchField = inputField theme "search"
    , textareaField = textareaField
    , numberField = numberField
    , rangeField = rangeField
    , checkboxField = checkboxField
    , radioField = radioField
    , selectField = selectField theme
    , group = group
    , section = section
    , formList = formList
    , formListItem = formListItem
    }


form : Theme -> Form.View.FormConfig msg (Html.Styled.Html msg) -> Html.Styled.Html msg
form theme { onSubmit, action, loading, state, fields } =
    Html.Styled.form
        [ css
            [ Css.displayFlex
            , Css.flexDirection Css.column
            , Css.property "gap" "16px"
            ]
        , optionalAttribute Events.onSubmit onSubmit
        ]
        (List.concat
            [ fields
            , [ UI.button
                    theme
                    { onClick = onSubmit
                    , disabled = onSubmit == Nothing
                    }
                    [ Css.marginTop (Css.rem 0.5) ]
                    [ if state == Form.View.Loading then
                        Html.Styled.text loading

                      else
                        Html.Styled.text action
                    ]
              ]
            ]
        )


inputField : Theme -> String -> Form.View.TextFieldConfig msg -> Html.Styled.Html msg
inputField theme type_ { onChange, onBlur, disabled, value, error, showError, attributes } =
    let
        hasError =
            case error of
                Nothing ->
                    False

                Just _ ->
                    showError

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
    Html.Styled.label
        [ css
            [ Css.position Css.relative
            , Css.display Css.block
            , Css.pseudoClass "focus-within"
                [ Css.Global.children
                    [ Css.Global.div
                        [ labelShownLabelStyle
                        , Css.color focusedPlaceholderColor
                        ]
                    ]
                ]
            ]
        ]
        [ Html.Styled.div
            [ css
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
            [ Html.Styled.text attributes.label ]
        , Html.Styled.input
            [ Attributes.value value
            , Events.onInput onChange
            , optionalAttribute Events.onBlur onBlur
            , Attributes.placeholder attributes.label
            , Attributes.disabled disabled
            , Attributes.type_ type_
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
        , case maybeErrorMessage showError error of
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


textareaField : Form.View.TextFieldConfig msg -> Html.Styled.Html msg
textareaField _ =
    text ""


numberField : Form.View.NumberFieldConfig msg -> Html.Styled.Html msg
numberField { onChange, onBlur, disabled, value, error, showError, attributes } =
    let
        stepAttr =
            attributes.step
                |> Maybe.map String.fromFloat
                |> Maybe.withDefault "any"
    in
    Html.Styled.input
        [ Events.onInput onChange
        , Attributes.disabled disabled
        , Attributes.value value
        , Attributes.placeholder attributes.placeholder
        , Attributes.type_ "number"
        , Attributes.step stepAttr
        ]
        []


rangeField : Form.View.RangeFieldConfig msg -> Html.Styled.Html msg
rangeField _ =
    text ""


checkboxField : Form.View.CheckboxFieldConfig msg -> Html.Styled.Html msg
checkboxField _ =
    text ""


radioField : Form.View.RadioFieldConfig msg -> Html.Styled.Html msg
radioField _ =
    text ""


selectField : Theme -> Form.View.SelectFieldConfig msg -> Html.Styled.Html msg
selectField theme { onChange, onBlur, disabled, value, error, showError, attributes } =
    let
        hasError =
            case error of
                Nothing ->
                    False

                Just _ ->
                    True

        hasValue =
            not (String.isEmpty value)

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
    in
    Html.Styled.label
        [ css
            [ Css.position Css.relative
            , Css.display Css.block
            , Css.pseudoClass "focus-within"
                [ Css.Global.children
                    [ Css.Global.div
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
        [ Html.Styled.div
            [ css
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
            [ Html.Styled.text attributes.label ]
        , Html.Styled.select
            [ Attributes.value value
            , Attributes.placeholder attributes.label
            , Attributes.disabled disabled
            , Events.onInput onChange
            , optionalAttribute Events.onBlur onBlur
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
                    (\( key, label_ ) ->
                        Html.Styled.option
                            [ Attributes.value key
                            , Attributes.selected (value == key)
                            ]
                            [ text label_ ]
                    )
                    attributes.options
            )
        , Html.Styled.span
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
                , Css.pointerEvents Css.none
                ]
            ]
            [ UI.Icons.arrowSolid
                [ Css.color inputColor
                , Css.Transitions.transition
                    [ Css.Transitions.color3 75 0 Css.Transitions.linear
                    ]
                ]
            ]
        , case maybeErrorMessage showError error of
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


group : List (Html.Styled.Html msg) -> Html.Styled.Html msg
group =
    Html.Styled.div []


section : String -> List (Html.Styled.Html msg) -> Html.Styled.Html msg
section sectionTitle children =
    Html.Styled.div [] (text sectionTitle :: children)


formList : Form.View.FormListConfig msg (Html.Styled.Html msg) -> Html.Styled.Html msg
formList _ =
    text ""


formListItem : Form.View.FormListItemConfig msg (Html.Styled.Html msg) -> Html.Styled.Html msg
formListItem _ =
    text ""



-- HELPERS


maybeErrorMessage : Bool -> Maybe Form.Error.Error -> Maybe String
maybeErrorMessage showError maybeError =
    case maybeError of
        Just (Form.Error.External error) ->
            Just error

        _ ->
            if showError then
                Maybe.map errorToString maybeError

            else
                Nothing


errorToString : Form.Error.Error -> String
errorToString error =
    case error of
        Form.Error.RequiredFieldIsEmpty ->
            "Esse campo precisa ser preenchido"

        Form.Error.ValidationFailed validationError ->
            validationError

        Form.Error.External externalError ->
            externalError


optionalAttribute : (a -> Html.Styled.Attribute msg) -> Maybe a -> Html.Styled.Attribute msg
optionalAttribute attr maybeValue =
    case maybeValue of
        Nothing ->
            Attributes.class ""

        Just value ->
            attr value
