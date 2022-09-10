module WebData exposing (WebData(..))

{-| Represent data coming from the web

@docs WebData

-}


type WebData error data
    = Loading
    | Loaded data
    | WithError error
