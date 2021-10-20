module Pages.Edit.Id_ exposing (Model, Msg, page)

import Api.Contact
import Api.HttpClient
import Contact
import Css
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
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
    Page.element
        { init = init req.params.id
        , update = update req
        , view = view shared
        , subscriptions = subscriptions
        }



-- INIT


type Model
    = Loading
    | Loaded Contact.Model (Form.View.Model Contact.Input)
    | WithError Api.HttpClient.Error


init : String -> ( Model, Cmd Msg )
init contactId =
    ( Loading
    , Api.Contact.getById contactId CompletedLoadContact
    )



-- UPDATE


type Msg
    = FormChanged Contact.Model (Form.View.Model Contact.Input)
    | SubmittedForm Contact.Model Contact.Output
    | CompletedLoadContact (Api.HttpClient.Response Contact.Model)
    | CompletedSaveContact (Api.HttpClient.Response Contact.Model)


update : Request.With Params -> Msg -> Model -> ( Model, Cmd Msg )
update req msg model =
    case msg of
        FormChanged contact newForm ->
            ( Loaded contact newForm, Cmd.none )

        SubmittedForm contact contactOutput ->
            ( model, Api.Contact.update contact contactOutput CompletedSaveContact )

        CompletedLoadContact (Ok contact) ->
            ( Loaded contact (Contact.formFromContact contact), Cmd.none )

        CompletedLoadContact (Err err) ->
            ( WithError err, Cmd.none )

        CompletedSaveContact (Ok _) ->
            ( model, Request.pushRoute Gen.Route.Home_ req )

        CompletedSaveContact (Err err) ->
            ( WithError err, Cmd.none )



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
                        Shared.Loaded categories_ ->
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
            , List.range 1 4
                |> List.map
                    (\index ->
                        div
                            [ css
                                [ Css.width (Css.pct 100)
                                , Css.height (Css.px 53)
                                , Css.backgroundColor shared.theme.colors.gray.lightest
                                , Css.borderRadius shared.theme.borderRadius
                                , UI.Animations.pulse index
                                ]
                            ]
                            []
                    )
                |> div
                    [ css
                        [ Css.displayFlex
                        , Css.flexDirection Css.column
                        , Css.property "gap" "1rem"
                        ]
                    ]
            , div
                [ css
                    [ Css.width (Css.pct 100)
                    , Css.height (Css.px 53)
                    , Css.backgroundColor shared.theme.colors.primary.lighter
                    , Css.borderRadius shared.theme.borderRadius
                    , Css.marginTop (Css.rem 1.5)
                    , UI.Animations.pulse 5
                    ]
                ]
                []
            ]

        WithError _ ->
            []
