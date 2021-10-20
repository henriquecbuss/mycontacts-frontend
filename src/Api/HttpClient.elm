module Api.HttpClient exposing
    ( BackendGetEndpoint(..)
    , Error(..)
    , GetUrl(..)
    , Response
    , SortDirection(..)
    , get
    , unwrapResult
    )

import Http
import Json.Decode exposing (Decoder)
import Url.Builder


type GetUrl
    = Backend BackendGetEndpoint


type BackendGetEndpoint
    = ListContacts SortDirection


type SortDirection
    = Asc
    | Desc


get : GetUrl -> (Result Error a -> msg) -> Decoder a -> Cmd msg
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



-- UTILS


getUrlToString : GetUrl -> String
getUrlToString getUrl =
    case getUrl of
        Backend (ListContacts sortDirection) ->
            Url.Builder.crossOrigin backendUrl
                [ "contacts" ]
                [ Url.Builder.string "order" (sortDirectionToString sortDirection) ]


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
