module Routes exposing (..)

import Url
import Url.Parser exposing ((</>), (<?>), Parser, map, oneOf, parse, string, top)


type Route
    = Home
    | User String
    | NotFound


routeParser : Parser (Route -> a) a
routeParser =
    oneOf
        [ map Home top
        , map User string
        ]


toRoute : Url.Url -> Route
toRoute url =
    Maybe.withDefault NotFound (parse routeParser url)
