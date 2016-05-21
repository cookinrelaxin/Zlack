module Main exposing (..)

import Html exposing(..)
import Html.Attributes exposing(..)
import Http
import Task exposing (Task)
import Json.Decode exposing (Decoder, string, (:=))
import Html.App

-- MODEL

type alias Model = 
    { username : String }

-- INIT

init : (Model, Cmd Msg)
init =
    ({username = ""}, fetchCmd)

-- MESSAGES

type Msg
    = Fetch
    | FetchSuccess String
    | FetchError Http.Error

-- VIEW

view : Model -> Html Msg
view model =
    div
        []
        [ h4 [] [ text ("Your temporary username is " ++ model.username ++ ". It will expire in <INSERT EXPIRATION DATE HERE>") ]
        , h4 [] [ text "My Channels" ]
        , ul [class "subscribed-channels"]
            [ li [] [ text "<SOME CHANNEL>" ]
            , li [] [ text "<ANOTHER CHANNEL>" ]
            , li [] [ text "<YET ANOTHER CHANNEL>" ]
            ]
        , button [class "ui loading button"] [ text "Create a new channel" ]
        , h4 [] [ text "Find new channels or users" ]
        , input [type' "text", placeholder "e.g. Punk Rock"] [ ]
        ]

-- UPDATE

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Fetch ->
            (model, fetchCmd)
        FetchSuccess response ->
            ({model | username = response}, Cmd.none)
        FetchError _ ->
            (model, Cmd.none)

-- SUBSCRIPTIONS

-- COMMANDS

-- TASKS

fetchCmd : Cmd Msg
fetchCmd =
    Task.perform FetchError FetchSuccess fetchTask

fetchTask : Task Http.Error String
fetchTask =
    Http.post
        ("username" := string)
        "http://localhost:4000/api/v1/users?guest=true"
        --(Http.string """{"guest": true}""")
        Http.empty

-- MAIN

main : Program Never
main =
    Html.App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = (always Sub.none)
        }
