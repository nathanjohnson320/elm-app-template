module Pages.Home exposing (..)

import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)


type Msg
    = Click


type alias Model =
    { message : String
    }


defaultModel : Model
defaultModel =
    { message = "" }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Click ->
            ( { model | message = "Home page click!" }, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ div []
            [ button [ onClick Click ] [ text "Home Click" ] ]
        , div
            []
            [ text <| "Home page" ++ model.message ]
        ]


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        []
