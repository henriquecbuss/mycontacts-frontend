module UI.Modal exposing
    ( Modal
    , init
    , view
    , withAction
    , withBody
    , withHeader
    , withIsLoading
    , withVariant
    , withVisible
    )

import Css
import Html.Styled exposing (button, div, h1, node, p, span, text)
import Html.Styled.Attributes exposing (css, disabled)
import Html.Styled.Events as Events
import Json.Decode
import Themes exposing (Theme)
import UI


type Modal constraints msg
    = Modal
        { header : Maybe String
        , body : Maybe String
        , cancelAction : String
        , action : Maybe { text : String, toMsg : msg }
        , isLoading : Bool
        , variant : UI.Variant
        , onClose : msg
        , isVisible : Bool
        }



-- INIT


init : msg -> Modal {} msg
init onClose =
    Modal
        { header = Nothing
        , body = Nothing
        , cancelAction = "Cancelar"
        , action = Nothing
        , isLoading = False
        , variant = UI.Primary
        , onClose = onClose
        , isVisible = True
        }



-- HELPERS


withHeader : String -> Modal constraints msg -> Modal { constraints | hasContent : () } msg
withHeader header (Modal modal) =
    Modal { modal | header = Just header }


withBody : String -> Modal constraints msg -> Modal { contraints | hasContent : () } msg
withBody body (Modal modal) =
    Modal { modal | body = Just body }


withCancelAction : String -> Modal constraints msg -> Modal constraints msg
withCancelAction cancelAction (Modal modal) =
    Modal { modal | cancelAction = cancelAction }


withAction : String -> msg -> Modal constraints msg -> Modal constraints msg
withAction action onClick (Modal modal) =
    Modal { modal | action = Just { text = action, toMsg = onClick } }


withIsLoading : Bool -> Modal constraints msg -> Modal constraints msg
withIsLoading isLoading (Modal modal) =
    Modal { modal | isLoading = isLoading }


withVariant : UI.Variant -> Modal constraints msg -> Modal constraints msg
withVariant variant (Modal modal) =
    Modal { modal | variant = variant }


withVisible : Bool -> Modal constraints msg -> Modal constraints msg
withVisible visible (Modal modal) =
    Modal { modal | isVisible = visible }



-- VIEW


view : Theme -> Modal { constraints | hasContent : () } msg -> Html.Styled.Html msg
view theme (Modal modal) =
    if not modal.isVisible then
        text ""

    else
        div
            [ Events.onClick modal.onClose
            , css
                [ Css.position Css.absolute
                , Css.top Css.zero
                , Css.left Css.zero
                , Css.right Css.zero
                , Css.bottom Css.zero
                , Css.zIndex (Css.int 10)
                , Css.displayFlex
                , Css.alignItems Css.center
                , Css.justifyContent Css.center
                , Css.backgroundColor (Css.rgba 0 0 0 0.4)
                , Css.property "backdrop-filter" "blur(7px)"
                ]
            ]
            [ node "modal-container"
                [ Events.on "esc" (Json.Decode.succeed modal.onClose)
                , css
                    [ Css.maxWidth (Css.px 450)
                    , Css.width (Css.pct 100)
                    , Css.backgroundColor theme.colors.white
                    , Css.padding (Css.rem 1.5)
                    , Css.borderRadius theme.borderRadius
                    , Css.boxShadow4 Css.zero (Css.px 4) (Css.px 10) (Css.rgba 0 0 0 0.04)
                    ]
                ]
                [ optionalElement modal.header
                    (\header ->
                        h1
                            [ css
                                [ Css.color
                                    (case modal.variant of
                                        UI.Primary ->
                                            theme.colors.foreground

                                        UI.Danger ->
                                            theme.colors.danger.main
                                    )
                                , Css.fontSize (Css.px 22)
                                , Css.fontWeight Css.bold
                                ]
                            ]
                            [ text header ]
                    )
                , optionalElement modal.body
                    (\body ->
                        p
                            [ css
                                [ Css.marginTop (Css.rem 2)
                                ]
                            ]
                            [ text body ]
                    )
                , div
                    [ css
                        [ Css.marginTop (Css.rem 2)
                        , Css.displayFlex
                        , Css.justifyContent Css.end
                        ]
                    ]
                    [ button
                        [ Events.onClick modal.onClose
                        , disabled modal.isLoading
                        , css
                            [ Css.backgroundColor Css.transparent
                            , Css.border Css.zero
                            , Css.outline Css.none
                            , Css.color theme.colors.gray.light
                            , Css.pseudoClass "not([disabled])"
                                [ Css.hover
                                    [ Css.textDecoration Css.underline
                                    ]
                                , Css.cursor Css.pointer
                                ]
                            , Css.pseudoClass "focus-visible"
                                [ Css.outline3 (Css.px 4) Css.solid theme.colors.gray.lightest
                                , Css.outlineOffset (Css.px 2)
                                , Css.borderRadius theme.borderRadius
                                ]
                            ]
                        ]
                        [ text modal.cancelAction ]
                    , optionalElement modal.action
                        (\action ->
                            UI.button theme
                                modal.variant
                                { onClick = Just action.toMsg
                                , isDisabled = False
                                , isLoading = modal.isLoading
                                }
                                [ Css.marginLeft (Css.rem 2)
                                , Css.paddingTop (Css.px 10)
                                , Css.paddingBottom (Css.px 10)
                                , Css.position Css.relative
                                ]
                                [ text action.text ]
                        )
                    ]
                ]
            ]



-- UTILS


optionalElement : Maybe a -> (a -> Html.Styled.Html msg) -> Html.Styled.Html msg
optionalElement maybeData viewData =
    Maybe.map viewData maybeData
        |> Maybe.withDefault (text "")
