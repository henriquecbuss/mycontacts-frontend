module Pages.Edit.Id_ exposing (Model, Msg, page)

import Api.Contact
import Api.HttpClient
import Contact
import Css
import Effect exposing (Effect)
import Form
import Form.View
import Gen.Params.Edit.Id_ exposing (Params)
import Gen.Route
import Html.Styled exposing (div)
import Html.Styled.Attributes exposing (css)
import Page
import Request
import Shared
import UI
import UI.Animations
import UI.Form
import UI.Toast
import View exposing (View)
import WebData


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
    Page.advanced
        { init = init req.params.id
        , update = update req
        , view = view shared
        , subscriptions = subscriptions
        }



-- INIT


type Model
    = Loading
    | Loaded Contact.Model (Form.View.Model Contact.Input)


init : String -> ( Model, Effect Msg )
init contactId =
    ( Loading
    , Api.Contact.getById contactId CompletedLoadContact
        |> Effect.fromCmd
    )



-- UPDATE


type Msg
    = FormChanged Contact.Model (Form.View.Model Contact.Input)
    | SubmittedForm Contact.Model Contact.Output
    | CompletedLoadContact (Api.HttpClient.Response Contact.Model)
    | CompletedSaveContact (Api.HttpClient.Response Contact.Model)


update : Request.With Params -> Msg -> Model -> ( Model, Effect Msg )
update req msg model =
    case msg of
        FormChanged contact newForm ->
            ( Loaded contact newForm, Effect.none )

        SubmittedForm contact contactOutput ->
            ( model
            , Api.Contact.update contact contactOutput CompletedSaveContact
                |> Effect.fromCmd
            )

        CompletedLoadContact (Ok contact) ->
            ( Loaded contact (Contact.formFromContact contact), Effect.none )

        CompletedLoadContact (Err err) ->
            ( model
            , Effect.batch
                [ Shared.ShowToast UI.Toast.Error "Contato não encontrado"
                    |> Effect.fromShared
                , Request.pushRoute Gen.Route.Home_ req
                    |> Effect.fromCmd
                ]
            )

        CompletedSaveContact (Ok _) ->
            ( model
            , Shared.ShowToast UI.Toast.Success "Contato atualizado"
                |> Effect.fromShared
            )

        CompletedSaveContact (Err err) ->
            ( model
            , Shared.ShowToast UI.Toast.Error "Ocorreu um erro ao atualizar o contato"
                |> Effect.fromShared
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Shared.Model -> Model -> View Msg
view shared model =
    case model of
        Loaded contact contactForm ->
            let
                categories =
                    case shared.availableCategories of
                        WebData.Loaded categories_ ->
                            categories_

                        _ ->
                            []
            in
            [ UI.pageHeader shared.theme ("Editar " ++ Contact.getName contact)
            , Form.View.custom (UI.Form.viewConfig shared.theme)
                { onChange = FormChanged contact
                , action = "Salvar"
                , loading = "Salvando"
                , validation = Form.View.ValidateOnBlur
                }
                (Contact.form categories
                    |> Form.map (SubmittedForm contact)
                )
                contactForm
            ]

        Loading ->
            [ UI.pageHeader shared.theme "Editar"
            , Contact.formSkeleton shared.theme
            ]
