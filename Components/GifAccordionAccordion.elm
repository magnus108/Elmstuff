module Components.GifAccordionAccordion exposing (..)

import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Components.GifAccordion as GifAccordion
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


type alias Model a b c d =
    { accordion : Accordion.Model a b c d
    }


-- INIT


init =
    let
        (accordion, accordionCmds) =
            Accordion.init (GifAccordion.init) GifAccordion.update GifAccordion.view GifAccordion.subscriptions
    in
        Model accordion ! [ Cmd.map Accordion accordionCmds ]


-- MESSAGES


type Msg a
    = Accordion a


-- UPDATE


update message model =
    case message of
        Accordion msg ->
            let
                ( accordion, accordionCmds ) =
                    Accordion.update msg model.accordion
            in
                { model | accordion = accordion } ! [Cmd.map Accordion accordionCmds]


-- VIEW


view model =
    div [] [ App.map Accordion (Accordion.view model.accordion) ]


-- SUBSCRIPTIONS


subscriptions model =
    Sub.map Accordion (Accordion.subscriptions model.accordion)
