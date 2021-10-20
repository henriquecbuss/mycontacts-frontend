module Api.Contact exposing (create, delete, getById, list, update)

import Api.HttpClient
import Contact
import Json.Decode as Decode


list : Api.HttpClient.SortDirection -> (Api.HttpClient.Response (List Contact.Model) -> msg) -> Cmd msg
list sortDirection toMsg =
    Api.HttpClient.get
        (Api.HttpClient.BackendGetRequest (Api.HttpClient.ListContacts sortDirection))
        toMsg
        (Decode.list Contact.decoder)


getById : String -> (Api.HttpClient.Response Contact.Model -> msg) -> Cmd msg
getById id toMsg =
    Api.HttpClient.get
        (Api.HttpClient.BackendGetRequest (Api.HttpClient.GetContactById id))
        toMsg
        Contact.decoder


delete : Contact.Model -> (Api.HttpClient.Response () -> msg) -> Cmd msg
delete contact toMsg =
    Api.HttpClient.delete
        (Api.HttpClient.BackendDeleteRequest (Api.HttpClient.DeleteContact contact))
        toMsg


create : Contact.Output -> (Api.HttpClient.Response Contact.Model -> msg) -> Cmd msg
create contactOutput toMsg =
    Api.HttpClient.post
        (Api.HttpClient.BackendPostRequest Api.HttpClient.CreateContact)
        (Contact.encodeOutput contactOutput)
        toMsg
        Contact.decoder


update : Contact.Model -> Contact.Output -> (Api.HttpClient.Response Contact.Model -> msg) -> Cmd msg
update contact contactOutput toMsg =
    Api.HttpClient.put
        (Api.HttpClient.BackendPutRequest (Api.HttpClient.UpdateContact contact))
        (Contact.encodeOutput contactOutput)
        toMsg
        Contact.decoder
