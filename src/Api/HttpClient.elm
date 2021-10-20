module Api.HttpClient exposing
    ( BackendDeleteEndpoint(..)
    , BackendGetEndpoint(..)
    , DeleteUrl(..)
    , Error(..)
    , GetUrl(..)
    , Response
    , SortDirection(..)
    , delete
    , get
    , unwrapResult
    )

import Contact
import Http
import Json.Decode exposing (Decoder)
import Url.Builder



-- GET


type GetUrl
    = BackendGetUrl BackendGetEndpoint


type BackendGetEndpoint
    = ListContacts SortDirection


type SortDirection
    = Asc
    | Desc


get : GetUrl -> (Response a -> msg) -> Decoder a -> Cmd msg
get getUrl toMsg decoder =
    Http.get
        { url = getUrlToString getUrl
        , expect =
            Http.expectJson
                (\result ->
                    case result of
                        Err httpError ->
                            Err (HttpError httpError)

                        Ok (Err responseError) ->
                            Err (ResponseError responseError)

                        Ok (Ok value) ->
                            Ok value
                )
                (Json.Decode.oneOf
                    [ Json.Decode.field "error" Json.Decode.string
                        |> Json.Decode.map Err
                    , Json.Decode.map Ok decoder
                    ]
                )
        }
        |> Cmd.map toMsg



-- DELETE


type DeleteUrl
    = BackendDeleteUrl BackendDeleteEndpoint


type BackendDeleteEndpoint
    = DeleteContact Contact.Model


delete : DeleteUrl -> (Response () -> msg) -> Cmd msg
delete deleteUrl toMsg =
    Http.request
        { method = "DELETE"
        , headers = []
        , url = deleteUrlToString deleteUrl
        , body = Http.emptyBody
        , expect = Http.expectWhatever (Result.mapError HttpError >> toMsg)
        , timeout = Nothing
        , tracker = Nothing
        }



-- UTILS


getUrlToString : GetUrl -> String
getUrlToString getUrl =
    case getUrl of
        BackendGetUrl (ListContacts sortDirection) ->
            Url.Builder.crossOrigin backendUrl
                [ "contacts" ]
                [ Url.Builder.string "order" (sortDirectionToString sortDirection) ]


deleteUrlToString : DeleteUrl -> String
deleteUrlToString deleteUrl =
    case deleteUrl of
        BackendDeleteUrl (DeleteContact contact) ->
            Url.Builder.crossOrigin backendUrl
                [ "contacts", Contact.getId contact ]
                []


type alias Response a =
    Result Error a


type Error
    = HttpError Http.Error
    | ResponseError String


unwrapResult : Result Http.Error (Result String a) -> Result Error a
unwrapResult result =
    case result of
        Err httpError ->
            Err (HttpError httpError)

        Ok (Err responseError) ->
            Err (ResponseError responseError)

        Ok (Ok value) ->
            Ok value


backendUrl : String
backendUrl =
    "http://localhost:4000"


sortDirectionToString : SortDirection -> String
sortDirectionToString sortDirection =
    case sortDirection of
        Asc ->
            "asc"

        Desc ->
            "desc"
