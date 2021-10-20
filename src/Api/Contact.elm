module Api.Contact exposing (list)

import Api.HttpClient
import Contact
import Json.Decode as Decode


list : Api.HttpClient.SortDirection -> (Api.HttpClient.Response (List Contact.Model) -> msg) -> Cmd msg
list sortDirection toMsg =
    Api.HttpClient.get (Api.HttpClient.Backend (Api.HttpClient.ListContacts sortDirection))
        toMsg
        (Decode.list Contact.decoder)
