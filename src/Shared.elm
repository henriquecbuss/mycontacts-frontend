module Shared exposing
    ( CategoryStatus(..)
    , Flags
    , Model
    , Msg
    , init
    , subscriptions
    , update
    )

import Api.Category
import Api.HttpClient
import Category exposing (Category)
import Json.Decode as Json
import Request exposing (Request)
import Themes exposing (Theme)


type alias Flags =
    Json.Value


type alias Model =
    { theme : Theme
    , availableCategories : CategoryStatus
    }


type CategoryStatus
    = Loading
    | Loaded (List Category)
    | WithError Api.HttpClient.Error


type Msg
    = CompletedLoadCategories (Api.HttpClient.Response (List Category))


init : Request -> Flags -> ( Model, Cmd Msg )
init _ _ =
    ( { theme = Themes.default
      , availableCategories = Loading
      }
    , Api.Category.list CompletedLoadCategories
    )


update : Request -> Msg -> Model -> ( Model, Cmd Msg )
update _ msg model =
    case msg of
        CompletedLoadCategories (Ok categories) ->
            ( { model | availableCategories = Loaded categories }, Cmd.none )

        CompletedLoadCategories (Err err) ->
            ( { model | availableCategories = WithError err }, Cmd.none )


subscriptions : Request -> Model -> Sub Msg
subscriptions _ _ =
    Sub.none
