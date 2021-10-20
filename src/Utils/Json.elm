module Utils.Json exposing (maybeEncode, optionalField)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as JDP
import Json.Encode as Encode


optionalField : String -> Decoder a -> Decoder (Maybe a -> b) -> Decoder b
optionalField fieldName decoder =
    JDP.optional fieldName (Decode.map Just decoder) Nothing


maybeEncode : (a -> Encode.Value) -> Maybe a -> Encode.Value
maybeEncode encoder maybeValue =
    Maybe.map encoder maybeValue
        |> Maybe.withDefault Encode.null
