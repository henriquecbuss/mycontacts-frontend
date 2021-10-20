module Api.Category exposing (list)

import Api.HttpClient
import Category exposing (Category)
import Json.Decode as Decode


list : (Api.HttpClient.Response (List Category) -> msg) -> Cmd msg
list toMsg =
    Api.HttpClient.get
        (Api.HttpClient.BackendGetRequest Api.HttpClient.ListCategories)
        toMsg
        (Decode.list Category.decoder)
