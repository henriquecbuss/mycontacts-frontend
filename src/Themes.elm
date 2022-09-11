module Themes exposing (Theme, default)

import Css exposing (rem)


type alias Theme =
    { colors :
        { background : Css.Color
        , foreground : Css.Color
        , white : Css.Color
        , primary :
            { lightest : Css.Color
            , lighter : Css.Color
            , light : Css.Color
            , main : Css.Color
            , dark : Css.Color
            }
        , danger :
            { light : Css.Color
            , main : Css.Color
            , dark : Css.Color
            }
        , success :
            { main : Css.Color
            }
        , gray :
            { lightest : Css.Color
            , light : Css.Color
            , medium : Css.Color
            , dark : Css.Color
            }
        }
    , borderWidth : Css.Rem
    , borderRadius : Css.Rem
    }


default : Theme
default =
    { colors =
        { background = Css.hex "f6f5fc"
        , foreground = Css.hex "222222"
        , white = Css.hex "ffffff"
        , primary =
            { lightest = Css.hex "e0e3ff"
            , lighter = Css.hex "a8b0f4"
            , light = Css.hex "6674f4"
            , main = Css.hex "5061fc"
            , dark = Css.hex "3346f8"
            }
        , danger =
            { light = Css.hex "fc6a6a"
            , main = Css.hex "fc5050"
            , dark = Css.hex "f63131"
            }
        , success =
            { main = Css.hex "51ca73"
            }
        , gray =
            { lightest = Css.hex "dfdfdf"
            , light = Css.hex "bcbcbc"
            , medium = Css.hex "aaaaaa"
            , dark = Css.hex "666666"
            }
        }
    , borderWidth = rem 0.125
    , borderRadius = rem 0.25
    }
