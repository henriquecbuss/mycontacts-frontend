module Api.Contact exposing (delete, list)

import Api.HttpClient
import Contact
import Json.Decode as Decode


list : Api.HttpClient.SortDirection -> (Api.HttpClient.Response (List Contact.Model) -> msg) -> Cmd msg
list sortDirection toMsg =
    Api.HttpClient.get
        (Api.HttpClient.BackendGetUrl (Api.HttpClient.ListContacts sortDirection))
        toMsg
        (Decode.list Contact.decoder)


delete : Contact.Model -> (Api.HttpClient.Response () -> msg) -> Cmd msg
delete contact toMsg =
    Api.HttpClient.delete
        (Api.HttpClient.BackendDeleteUrl (Api.HttpClient.DeleteContact contact))
        toMsg
