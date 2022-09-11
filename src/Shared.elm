module Shared exposing
    ( Effect(..)
    , Flags
    , Model
    , Msg
    , init
    , subscriptions
    , update
    , updateEffect
    , viewToasts
    )

import Api.Category
import Api.HttpClient
import Category exposing (Category)
import Dict exposing (Dict)
import Html.Styled
import Json.Decode as Json
import Request exposing (Request)
import Task
import Themes exposing (Theme)
import UI.Toast
import WebData exposing (WebData)


type alias Flags =
    Json.Value


type alias Model =
    { theme : Theme
    , availableCategories : WebData Api.HttpClient.Error (List Category)
    , toasts : Dict Int UI.Toast.Model
    , lastToastId : Int
    }


type Msg
    = CompletedLoadCategories (Api.HttpClient.Response (List Category))
    | StartedRemovingToast Int
    | FinishedRemovingToast Int


type Effect
    = ShowToast UI.Toast.Variant String


init : Request -> Flags -> ( Model, Cmd Msg )
init _ _ =
    ( { theme = Themes.default
      , availableCategories = WebData.Loading
      , toasts = Dict.empty
      , lastToastId = -1
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

        StartedRemovingToast toastId ->
            ( { model
                | toasts =
                    Dict.update toastId
                        (Maybe.map (\toast -> { toast | status = UI.Toast.Removing }))
                        model.toasts
              }
            , Cmd.none
            )

        FinishedRemovingToast toastId ->
            ( { model | toasts = Dict.remove toastId model.toasts }, Cmd.none )


updateEffect : Effect -> Model -> ( Model, Cmd Msg )
updateEffect effect model =
    case effect of
        ShowToast variant message ->
            ( { model
                | toasts =
                    Dict.insert (model.lastToastId + 1)
                        (UI.Toast.idle variant message)
                        model.toasts
                , lastToastId = model.lastToastId + 1
              }
            , Cmd.none
            )


subscriptions : Request -> Model -> Sub Msg
subscriptions _ _ =
    Sub.none


viewToasts : Model -> Html.Styled.Html Msg
viewToasts model =
    model.toasts
        |> Dict.toList
        |> List.map
            (\( id, toast ) ->
                ( String.fromInt id
                , { onStartRemoving = StartedRemovingToast id
                  , onFinishedRemoving = FinishedRemovingToast id
                  , duration = UI.Toast.defaultDuration
                  , toast = toast
                  }
                )
            )
        |> UI.Toast.view model.theme
