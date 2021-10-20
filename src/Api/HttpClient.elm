module Api.HttpClient exposing
    ( Error(..), Response
    , get, GetRequest(..), BackendGetEndpoint(..)
    , post, PostRequest(..), BackendPostEndpoint(..)
    , put, PutRequest(..), BackendPutEndpoint(..)
    , delete, DeleteRequest(..), BackendDeleteEndpoint(..)
    , SortDirection(..)
    )

{-| This module is used to organize all our HTTP calls.


## Response

@docs Error, Response, unwrapResult


## Get

@docs get, GetRequest, BackendGetEndpoint


## Post

@docs post, PostRequest, BackendPostEndpoint


## Put

@docs put, PutRequest, BackendPutEndpoint


## Delete

@docs delete, DeleteRequest, BackendDeleteEndpoint


## Helpers

@docs SortDirection

-}

import Contact
import Http
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode
import Url.Builder



-- RESPONSE


type alias Response a =
    Result Error a


type Error
    = HttpError Http.Error
    | ResponseError String



-- GET


type GetRequest
    = BackendGetRequest BackendGetEndpoint


type BackendGetEndpoint
    = ListContacts SortDirection
    | GetContactById String
    | ListCategories


get : GetRequest -> (Response a -> msg) -> Decoder a -> Cmd msg
get getUrl toMsg decoder =
    Http.get
        { url = getUrlToString getUrl
        , expect = expectJsonWithError decoder
        }
        |> Cmd.map toMsg



-- POST


type PostRequest
    = BackendPostRequest BackendPostEndpoint


type BackendPostEndpoint
    = CreateContact


post : PostRequest -> Encode.Value -> (Response a -> msg) -> Decoder a -> Cmd msg
post postRequest body toMsg decoder =
    Http.post
        { url = postUrlToString postRequest
        , body = Http.jsonBody body
        , expect = expectJsonWithError decoder
        }
        |> Cmd.map toMsg



-- PUT


type PutRequest
    = BackendPutRequest BackendPutEndpoint


type BackendPutEndpoint
    = UpdateContact Contact.Model


put : PutRequest -> Encode.Value -> (Response a -> msg) -> Decoder a -> Cmd msg
put putRequest body toMsg decoder =
    Http.request
        { method = "PUT"
        , headers = []
        , url = putUrlToString putRequest
        , body = Http.jsonBody body
        , expect = expectJsonWithError decoder
        , timeout = Nothing
        , tracker = Nothing
        }
        |> Cmd.map toMsg



-- DELETE


type DeleteRequest
    = BackendDeleteRequest BackendDeleteEndpoint


type BackendDeleteEndpoint
    = DeleteContact Contact.Model


delete : DeleteRequest -> (Response () -> msg) -> Cmd msg
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



-- HELPERS


type SortDirection
    = Asc
    | Desc



-- INTERNAL HELPERS


expectJsonWithError : Decoder a -> Http.Expect (Response a)
expectJsonWithError decoder =
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
        (Decode.oneOf
            [ Decode.field "error" Decode.string
                |> Decode.map Err
            , Decode.map Ok decoder
            ]
        )


getUrlToString : GetRequest -> String
getUrlToString getUrl =
    case getUrl of
        BackendGetRequest (ListContacts sortDirection) ->
            Url.Builder.crossOrigin backendUrl
                [ "contacts" ]
                [ Url.Builder.string "order" (sortDirectionToString sortDirection) ]

        BackendGetRequest (GetContactById id) ->
            Url.Builder.crossOrigin backendUrl
                [ "contacts", id ]
                []

        BackendGetRequest ListCategories ->
            Url.Builder.crossOrigin backendUrl
                [ "categories" ]
                []


postUrlToString : PostRequest -> String
postUrlToString postUrl =
    case postUrl of
        BackendPostRequest CreateContact ->
            Url.Builder.crossOrigin backendUrl
                [ "contacts" ]
                []


putUrlToString : PutRequest -> String
putUrlToString putUrl =
    case putUrl of
        BackendPutRequest (UpdateContact contact) ->
            Url.Builder.crossOrigin backendUrl
                [ "contacts", Contact.getId contact ]
                []


deleteUrlToString : DeleteRequest -> String
deleteUrlToString deleteUrl =
    case deleteUrl of
        BackendDeleteRequest (DeleteContact contact) ->
            Url.Builder.crossOrigin backendUrl
                [ "contacts", Contact.getId contact ]
                []


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
