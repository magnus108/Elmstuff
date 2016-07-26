module Components.Accordion exposing (..)

import Html exposing (Html, button, div, text, h2, img)
import Html.Attributes exposing (src)
import Html.Events exposing (onClick)
import Html.App as App
import Http
import Json.Decode as Json
import Task


import Components.Gif as Gif


main : Program Never
main =
    App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


-- MODEL


type alias Model component =
    { expand : Bool
    , component: component
    }


-- INIT


init=
    let
        (component, componentCmds) = Gif.init Nothing
    in
        Model False component ! [ Cmd.map Modify componentCmds ]


-- MESSAGES


type Msg componentMsg
    = Expand
    | Collapse
    | Modify componentMsg


-- UPDATE


update msg model =
    case msg of

        Expand ->
            { model | expand = True } ! []

        Collapse ->
            { model | expand = False } ! []

        Modify componentMsg ->
            let
                ( component, componentCmds ) =
                    Gif.update componentMsg model.component
            in
                { model | component = component } ! [Cmd.map Modify componentCmds]

-- VIEW


view model =
    let
        expand =
            div [] [ button [ onClick Expand ] [ text "Expand" ] ]

        collapse =
            div [] [ button [ onClick Collapse ] [ text "Collapse" ] ]

        content =
            div [] [ App.map Modify (Gif.view model.component) ]

        result =
            if model.expand then [collapse, content] else [expand]
    in
        div [] result


-- SUBSCRIPTIONS


subscriptions model =
    Sub.map Modify (Gif.subscriptions model.component)
