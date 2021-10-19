module Pages.New exposing (Model, Msg, page)

import Category exposing (Category)
import Gen.Params.New exposing (Params)
import Page
import Request
import Shared
import Themes exposing (Theme)
import UI
import UI.Select
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
    Page.element
        { init = init
        , update = update
        , view = view shared.theme
        , subscriptions = subscriptions
        }



-- INIT


type alias Model =
    { name : String
    , category : Maybe Category
    }


init : ( Model, Cmd Msg )
init =
    ( { name = ""
      , category = Nothing
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = EnteredName String
    | SelectedCategory (Maybe Category)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        EnteredName name ->
            ( { model | name = name }, Cmd.none )

        SelectedCategory category ->
            ( { model | category = category }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Theme -> Model -> View Msg
view theme model =
    [ UI.input
        theme
        { label = "Nome"
        , id = "name-input"
        , value = model.name
        , onInput = EnteredName
        , error = Nothing
        }
    , UI.Select.init
        { label = "Categoria"
        , id = "category-selector"
        , onInput = SelectedCategory
        }
        |> UI.Select.withValue model.category
        |> UI.Select.withOptions categoryToOption Category.list
        |> UI.Select.view theme
    ]


categoryToOption : Category -> UI.Select.Option Category
categoryToOption category =
    { value = category, label = Category.toString category }
