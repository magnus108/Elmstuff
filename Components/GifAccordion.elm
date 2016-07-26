module Components.GifAccordion exposing (..)

import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Components.Gif as Gif
import Components.Accordion as Accordion


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


type alias Model =
    { accordion : Accordion.Model Gif.Model
    }


-- INIT


init : (Model, Cmd Msg)
init =
    let
        (accordion, accordionCmds) =
            Accordion.init (Gif.init Nothing)
    in
        Model accordion ! [ Cmd.map Accordion accordionCmds ]


-- MESSAGES


type Msg
    = Accordion Accordion.Msg


-- UPDATE


update : Msg -> Model -> (Model, Cmd Msg)
update message model =
    case message of
        Accordion msg ->
            let
                ( accordion, accordionCmds ) =
                    Accordion.update msg model.accordion
            in
                { model | accordion = accordion } ! [Cmd.map Accordion accordionCmds]


-- VIEW


view : Model -> Html Msg
view model =
    div [] [ App.map Accordion (Accordion.view model.accordion) ]


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.map Accordion (Accordion.subscriptions Gif.subscriptions model.accordion)
