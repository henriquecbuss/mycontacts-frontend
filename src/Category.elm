module Category exposing (Category, decoder, form, getId, toString, view)

import Css
import Form
import Html.Styled exposing (small, text)
import Html.Styled.Attributes exposing (css)
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as JDP
import Themes exposing (Theme)


type Category
    = Category { id : String, name : String }


toString : Category -> String
toString (Category { name }) =
    name


getId : Category -> String
getId (Category { id }) =
    id


decoder : Decoder Category
decoder =
    Decode.succeed (\id name -> Category { id = id, name = name })
        |> JDP.required "id" Decode.string
        |> JDP.required "name" Decode.string


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


type alias CategoryId =
    String


form : List Category -> Form.Form CategoryId CategoryId
form categories =
    Form.selectField
        { parser = Ok
        , value = identity
        , update = \id _ -> id
        , error = always Nothing
        , attributes =
            { label = "Categoria"
            , placeholder = "Categoria"
            , options =
                categories
                    |> List.map (\(Category { name, id }) -> ( id, name ))
            }
        }
