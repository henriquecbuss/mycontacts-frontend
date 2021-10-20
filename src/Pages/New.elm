module Pages.New exposing (Model, Msg, page)

import Api.Contact
import Api.HttpClient
import Contact
import Form
import Form.View
import Gen.Params.New exposing (Params)
import Gen.Route
import Html.Styled exposing (text)
import Page
import Request
import Shared
import Themes exposing (Theme)
import UI
import UI.Form
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
    Page.element
        { init = init
        , update = update req
        , view = view shared
        , subscriptions = subscriptions
        }



-- INIT


type alias Model =
    Form.View.Model Contact.Input


init : ( Model, Cmd Msg )
init =
    ( Form.View.idle
        { name = ""
        , email = ""
        , phone = ""
        , category = ""
        }
    , Cmd.none
    )



-- UPDATE


type Msg
    = FormChanged (Form.View.Model Contact.Input)
    | SubmittedForm Contact.Output
    | CompletedCreatingContact (Api.HttpClient.Response Contact.Model)


update : Request.With Params -> Msg -> Model -> ( Model, Cmd Msg )
update req msg model =
    case msg of
        FormChanged newForm ->
            ( newForm, Cmd.none )

        SubmittedForm contactOutput ->
            ( model, Api.Contact.create contactOutput CompletedCreatingContact )

        CompletedCreatingContact contact ->
            ( model, Request.pushRoute Gen.Route.Home_ req )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Shared.Model -> Model -> View Msg
view shared model =
    [ UI.pageHeader shared.theme "Novo contato"
    , case shared.availableCategories of
        Shared.Loaded categories ->
            Form.View.custom (UI.Form.viewConfig shared.theme)
                { onChange = FormChanged
                , action = "Cadastrar"
                , loading = "Cadastrando"
                , validation = Form.View.ValidateOnBlur
                }
                (Contact.form categories
                    |> Form.map SubmittedForm
                )
                model

        _ ->
            text ""
    ]
