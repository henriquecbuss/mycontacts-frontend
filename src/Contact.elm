module Contact exposing
    ( Input
    , Model
    , Output
    , decoder
    , form
    , getId
    , optionalField
    , view
    , viewLoading
    )

import Category exposing (Category(..))
import Css
import Css.Animations
import Form
import Gen.Route
import Html.Styled exposing (a, button, div, img, li, small, span, strong, text)
import Html.Styled.Attributes exposing (css, href, src)
import Html.Styled.Events as Events
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as JDP
import Mask
import Regex exposing (Regex)
import Themes exposing (Theme)


type Model
    = Contact
        { id : String
        , name : String
        , email : Maybe String
        , phone : Maybe String
        , category : Maybe Category
        }


getId : Model -> String
getId (Contact model) =
    model.id



-- VIEW


view : Theme -> Int -> (Model -> msg) -> Model -> ( String, Html.Styled.Html msg )
view theme index deleteMsg (Contact model) =
    let
        contactItem : String -> Html.Styled.Html msg
        contactItem content =
            small
                [ css
                    [ Css.color theme.colors.gray.light
                    , Css.fontSize (Css.rem 0.875)
                    , Css.marginTop (Css.rem 0.25)
                    ]
                ]
                [ text content ]

        actionIconStyle : Css.Style
        actionIconStyle =
            Css.batch
                [ Css.cursor Css.pointer
                , Css.backgroundColor Css.transparent
                , Css.border Css.zero
                , Css.hover
                    [ Css.opacity (Css.num 0.7)
                    ]
                , Css.active
                    [ Css.opacity (Css.num 0.9)
                    ]
                ]
    in
    ( model.id
    , li
        [ css
            [ Css.displayFlex
            , Css.justifyContent Css.spaceBetween
            , Css.alignItems Css.center
            , Css.padding (Css.rem 1)
            , Css.borderRadius theme.borderRadius
            , Css.backgroundColor theme.colors.white
            , Css.boxShadow4 Css.zero (Css.px 4) (Css.px 10) (Css.rgba 0 0 0 0.04)
            , Css.marginTop (Css.rem 1)
            , Css.firstChild [ Css.marginTop Css.zero ]
            , Css.animationDuration (Css.ms 500)
            , Css.animationDelay (Css.ms (100 * toFloat index))
            , Css.property "animation-fill-mode" "both"
            , Css.animationName
                (Css.Animations.keyframes
                    [ ( 0
                      , [ Css.Animations.opacity Css.zero
                        , Css.Animations.transform [ Css.translateY (Css.pct 50) ]
                        ]
                      )
                    , ( 100
                      , [ Css.Animations.opacity (Css.num 1)
                        , Css.Animations.transform [ Css.translateY Css.zero ]
                        ]
                      )
                    ]
                )
            ]
        ]
        [ div
            [ css
                [ Css.displayFlex
                , Css.flexDirection Css.column
                ]
            ]
            [ div []
                [ strong [ css [ Css.marginRight (Css.rem 0.5) ] ]
                    [ text model.name ]
                , model.category
                    |> Maybe.map (Category.view theme)
                    |> Maybe.withDefault (text "")
                ]
            , model.email
                |> Maybe.map contactItem
                |> Maybe.withDefault (text "")
            , model.phone
                |> Maybe.map
                    (\phone ->
                        Mask.string
                            { mask =
                                if String.length phone == 11 then
                                    "(##) # ####-####"

                                else
                                    "(##) ####-####"
                            , replace = '#'
                            }
                            phone
                            |> contactItem
                    )
                |> Maybe.withDefault (text "")
            ]
        , div []
            [ a
                [ href (Gen.Route.toHref (Gen.Route.Edit__Id_ { id = model.id }))
                , css [ actionIconStyle ]
                ]
                [ img [ src "/icons/edit.svg" ] [] ]
            , button
                [ Events.onClick (deleteMsg (Contact model))
                , css [ actionIconStyle, Css.marginLeft (Css.rem 0.5) ]
                ]
                [ img [ src "/icons/delete.svg" ] [] ]
            ]
        ]
    )


viewLoading : Theme -> Int -> Html.Styled.Html msg
viewLoading theme index =
    let
        pulse =
            Css.Animations.keyframes
                [ ( 0, [ Css.Animations.opacity (Css.num 0.7) ] )
                , ( 50, [ Css.Animations.opacity (Css.num 0.3) ] )
                , ( 100, [ Css.Animations.opacity (Css.num 0.7) ] )
                ]
    in
    li
        [ css
            [ Css.displayFlex
            , Css.justifyContent Css.spaceBetween
            , Css.alignItems Css.center
            , Css.padding (Css.rem 1)
            , Css.borderRadius theme.borderRadius
            , Css.backgroundColor theme.colors.white
            , Css.boxShadow4 Css.zero (Css.px 4) (Css.px 10) (Css.rgba 0 0 0 0.04)
            , Css.marginTop (Css.rem 1)
            , Css.firstChild [ Css.marginTop Css.zero ]
            , Css.animationDuration (Css.ms 500)
            , Css.animationDelay (Css.ms (100 * toFloat index))
            , Css.property "animation-fill-mode" "both"
            , Css.animationName
                (Css.Animations.keyframes
                    [ ( 0
                      , [ Css.Animations.opacity Css.zero
                        , Css.Animations.transform [ Css.translateY (Css.pct 50) ]
                        ]
                      )
                    , ( 100
                      , [ Css.Animations.opacity (Css.num 1)
                        , Css.Animations.transform [ Css.translateY Css.zero ]
                        ]
                      )
                    ]
                )
            ]
        ]
        [ div
            [ css
                [ Css.displayFlex
                , Css.flexDirection Css.column
                , Css.width (Css.pct 100)
                , Css.property "gap" "4px"
                , Css.animationName pulse
                , Css.animationDuration (Css.ms 2000)
                , Css.animationDelay (Css.ms (100 * toFloat index))
                , Css.animationIterationCount Css.infinite
                ]
            ]
            [ span
                [ css
                    [ Css.height (Css.rem 0.75)
                    , Css.width (Css.pct 60)
                    , Css.backgroundColor theme.colors.gray.light
                    , Css.borderRadius theme.borderRadius
                    ]
                ]
                []
            , span
                [ css
                    [ Css.height (Css.rem 0.75)
                    , Css.width (Css.pct 50)
                    , Css.backgroundColor theme.colors.gray.lightest
                    , Css.borderRadius theme.borderRadius
                    ]
                ]
                []
            , span
                [ css
                    [ Css.height (Css.rem 0.75)
                    , Css.width (Css.pct 40)
                    , Css.backgroundColor theme.colors.gray.lightest
                    , Css.borderRadius theme.borderRadius
                    ]
                ]
                []
            ]
        ]



-- FORM


type alias Input =
    { name : String
    , email : String
    , phone : String
    , category : String
    }


type alias Output =
    { name : String
    , email : Maybe String
    , phone : Maybe String
    , category : Maybe Category
    }


emailRegex : Regex
emailRegex =
    Regex.fromString "^(([^<>()[\\]\\\\.,;:\\s@\"]+(\\.[^<>()[\\]\\\\.,;:\\s@\"]+)*)|(\".+\"))@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\])|(([a-zA-Z\\-0-9]+\\.)+[a-zA-Z]{2,}))$"
        |> Maybe.withDefault Regex.never


phoneMask : { mask : String, replace : Char }
phoneMask =
    { mask = "(##) # ####-####", replace = '#' }


form : Form.Form Input Output
form =
    Form.succeed Output
        |> Form.append
            (Form.textField
                { parser = Ok
                , value = .name
                , update = \name values -> { values | name = name }
                , error = always Nothing
                , attributes =
                    { placeholder = "Nome *"
                    , label = "Nome *"
                    }
                }
            )
        |> Form.append
            (Form.optional
                (Form.emailField
                    { parser =
                        \email ->
                            if Regex.contains emailRegex email then
                                Ok email

                            else
                                Err "O formato do e-mail é inválido"
                    , value = .email
                    , update = \email values -> { values | email = email }
                    , error = always Nothing
                    , attributes =
                        { placeholder = "E-mail"
                        , label = "E-mail"
                        }
                    }
                )
            )
        |> Form.append
            (Form.optional
                (Form.textField
                    { parser = Mask.remove phoneMask >> Ok
                    , value = .phone >> Mask.string phoneMask
                    , update = \phone values -> { values | phone = phone }
                    , error = always Nothing
                    , attributes =
                        { placeholder = "Telefone"
                        , label = "Telefone"
                        }
                    }
                )
            )
        |> Form.append
            (Form.optional
                (Form.selectField
                    { parser = Category.fromString >> Result.fromMaybe "Invalid category"
                    , value = .category
                    , update = \category values -> { values | category = category }
                    , error = always Nothing
                    , attributes =
                        { label = "Categoria"
                        , placeholder = "Categoria"
                        , options =
                            Category.list
                                |> List.map (\category -> ( Category.toString category, Category.toString category ))
                        }
                    }
                )
            )



-- JSON


decoder : Decoder Model
decoder =
    Decode.succeed
        (\id name email phone category ->
            Contact
                { id = id
                , name = name
                , email = email
                , phone = phone
                , category = category
                }
        )
        |> JDP.required "id" Decode.string
        |> JDP.required "name" Decode.string
        |> optionalField "email" Decode.string
        |> optionalField "phone" Decode.string
        |> optionalField "category_name" Category.decoder


optionalField : String -> Decoder a -> Decoder (Maybe a -> b) -> Decoder b
optionalField fieldName decoder_ =
    JDP.optional fieldName (Decode.map Just decoder_) Nothing
