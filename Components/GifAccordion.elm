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
    { accordion : Accordion.Model
    , gif : Gif.Model
    }


-- INIT


init : (Model, Cmd Msg)
init =
    let
        (accordion, accordionCmds) =
            Accordion.init Nothing

        (gif, gifCmds) =
            Gif.init Nothing
    in
        Model accordion gif !
            [ Cmd.map Accordion accordionCmds
            , Cmd.map Gif gifCmds ]


-- MESSAGES


type Msg
    = Accordion Accordion.Msg
    | Gif Gif.Msg


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

        Gif msg ->
            let
                ( gif, gifCmds ) =
                    Gif.update msg model.gif
            in
                { model | gif = gif } ! [Cmd.map Gif gifCmds]


-- VIEW


view : Model -> Html Msg
view model =
    if model.accordion.expand then
        div []
            [ App.map Accordion (Accordion.accordionCollapse)
            , App.map Gif (Gif.view model.gif)
            , text (toString model)
            ]
    else
        div []
            [ App.map Accordion (Accordion.accordionExpand) ]


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Sub.map Accordion (Accordion.subscriptions model.accordion)
        , Sub.map Gif (Gif.subscriptions model.gif)
        ]
