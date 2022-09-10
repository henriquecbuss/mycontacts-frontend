module Shared exposing
    ( Flags
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
import WebData exposing (WebData)


type alias Flags =
    Json.Value


type alias Model =
    { theme : Theme
    , availableCategories : WebData Api.HttpClient.Error (List Category)
    }


type Msg
    = CompletedLoadCategories (Api.HttpClient.Response (List Category))


init : Request -> Flags -> ( Model, Cmd Msg )
init _ _ =
    ( { theme = Themes.default
      , availableCategories = WebData.Loading
      }
    , Api.Category.list CompletedLoadCategories
    )


update : Request -> Msg -> Model -> ( Model, Cmd Msg )
update _ msg model =
    case msg of
        CompletedLoadCategories (Ok categories) ->
            ( { model | availableCategories = WebData.Loaded categories }, Cmd.none )

        CompletedLoadCategories (Err err) ->
            ( { model | availableCategories = WebData.WithError err }, Cmd.none )


subscriptions : Request -> Model -> Sub Msg
subscriptions _ _ =
    Sub.none
