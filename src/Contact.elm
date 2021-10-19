module Contact exposing (Model, mockContacts, view)

import Category exposing (Category(..))
import Css
import Html.Styled exposing (a, button, div, img, li, small, strong, text)
import Html.Styled.Attributes exposing (css, src)
import Mask
import Themes exposing (Theme)


type Model
    = Contact
        { id : String
        , name : String
        , email : Maybe String
        , phone : Maybe String
        , category : Maybe Category
        }


mockContacts : List Model
mockContacts =
    [ Contact
        { id = "1"
        , name = "Henrique"
        , email = Just "henrique@mail.com"
        , phone = Just "47988494288"
        , category = Nothing
        }
    , Contact
        { id = "2"
        , name = "José"
        , email = Just "jose+1@mail.com"
        , phone = Just "1231231231"
        , category = Just Instagram
        }
    , Contact
        { id = "3"
        , name = "Rose"
        , email = Just "rose@mail.com"
        , phone = Just "3123123123"
        , category = Nothing
        }
    ]


view : Theme -> Model -> Html.Styled.Html msg
view theme (Contact model) =
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
            [ a [ css [ actionIconStyle ] ]
                [ img [ src "/icons/edit.svg" ] [] ]
            , button
                [ css [ actionIconStyle, Css.marginLeft (Css.rem 0.5) ] ]
                [ img [ src "/icons/delete.svg" ] [] ]
            ]
        ]
