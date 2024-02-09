module Main exposing (Model, Msg(..), init, main, subscriptions, update, view)

import Browser exposing (Document)
import Browser.Navigation as Nav
import Html exposing (a, button, div, input, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Pages.Home
import Routes exposing (Route(..), toRoute)
import Url
import Url.Builder exposing (absolute, crossOrigin)



-- MAIN


main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }



-- MODEL


type alias Model =
    { content : String
    , environment : String
    , key : Nav.Key
    , url : Url.Url
    , route : Route
    , home : Pages.Home.Model
    }


type alias Flags =
    { environment : String
    }


init : Flags -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( { content = ""
      , environment = flags.environment
      , key = key
      , url = url
      , route = toRoute url
      , home = Pages.Home.defaultModel
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = Change String
    | LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | NavigateAway
    | LoadUser String
    | HomeMsg Pages.Home.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Change newContent ->
            ( { model | content = newContent }, Cmd.none )

        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            ( { model | url = url, route = toRoute url }
            , Cmd.none
            )

        NavigateAway ->
            ( model, Nav.load <| crossOrigin "https://www.google.com" [] [] )

        LoadUser user_id ->
            ( model, Nav.pushUrl model.key <| absolute [ user_id ] [] )

        HomeMsg homeMsg ->
            let
                ( homeModel, homeCmd ) =
                    Pages.Home.update homeMsg model.home
            in
            ( { model | home = homeModel }, Cmd.map HomeMsg homeCmd )



-- VIEW


view : Model -> Document Msg
view model =
    { title = "My Elm Demo"
    , body =
        [ div []
            [ div []
                [ a [ href "/" ] [ text <| "Home" ]
                ]
            , div []
                [ a [ href "/user-1" ] [ text <| "User-1's Page" ]
                ]
            , div []
                [ button [ onClick NavigateAway ] [ text "To Google!" ] ]
            , div []
                [ button [ onClick <| LoadUser "user-1" ] [ text "To Tweet!" ] ]
            , case model.route of
                Home ->
                    Html.map HomeMsg (Pages.Home.view model.home)

                User user_id ->
                    div []
                        [ text <| "Looking at " ++ user_id ]

                NotFound ->
                    div [] [ text "uh oh not found" ]
            ]
        ]
    }



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Sub.map HomeMsg (Pages.Home.subscriptions model.home)
        ]
