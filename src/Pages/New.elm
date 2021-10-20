module Pages.New exposing (Model, Msg, page)

import Contact
import Form
import Form.View
import Gen.Params.New exposing (Params)
import Page
import Request
import Shared
import Themes exposing (Theme)
import UI
import UI.Form
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared _ =
    Page.element
        { init = init
        , update = update
        , view = view shared.theme
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


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FormChanged newForm ->
            ( newForm, Cmd.none )

        SubmittedForm _ ->
            ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Theme -> Model -> View Msg
view theme model =
    [ UI.pageHeader theme "Novo contato"
    , Form.View.custom (UI.Form.viewConfig theme)
        { onChange = FormChanged
        , action = "Cadastrar"
        , loading = "Cadastrando"
        , validation = Form.View.ValidateOnBlur
        }
        (Form.map SubmittedForm Contact.form)
        model
    ]
