module Components.GifCollection exposing (..)

import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Components.Gif as Gif
import Components.Collection as Collection


-- MAIN


main : Program Never
main =
    App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


-- MODEL


type alias Model a b c d e =
    { t : Collection.Model a b c d e
    }


-- INIT


init =
    let
        (t, cmds) =
            Collection.init (Gif.init Nothing) Gif.update Gif.view Gif.subscriptions
    in
        Model t ! [ Cmd.map Message cmds ]


-- MESSAGES


type Msg a
    = Message a


-- UPDATE


update message model =
    case message of
        Message msg ->
            let
                ( t, cmds ) =
                    Collection.update msg model.t
            in
                { model | t = t } ! [Cmd.map Message cmds]


-- VIEW


view model =
    div [] [ App.map Message (Collection.view model.t) ]


-- SUBSCRIPTIONS


subscriptions model =
    Sub.map Message (Collection.subscriptions model.t)
