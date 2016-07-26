module Components.Accordion exposing (..)

import Html exposing (Html, button, div, text, h2, img)
import Html.Attributes exposing (src)
import Html.Events exposing (onClick)
import Html.App as App
import Http
import Json.Decode as Json
import Task








import Components.Gif as Gif


-- MAIN


main : Program Never
main =
    App.program
        { init = init (Gif.init Nothing)
        , view = view cView
        , update = update Gif.update
        , subscriptions = subscriptions Gif.subscriptions
        }



cView cmodel =
    Gif.view cmodel






-- MODEL


type alias Model component =
    { expand : Bool
    , component: component
    }


-- INIT


init model =
    let
        (component, componentCmds) = model
    in
        Model False component !
            [ Cmd.map Modify componentCmds ]


-- MESSAGES


type Msg componentMsg
    = Expand
    | Collapse
    | Modify componentMsg


-- UPDATE


update gifs msg model =
    case msg of

        Expand ->
            { model | expand = True } ! []

        Collapse ->
            { model | expand = False } ! []

        Modify componentMsg ->
            let
                ( component, componentCmds ) =
                    gifs componentMsg model.component
            in
                { model | component = component } ! [Cmd.map Modify componentCmds]

-- VIEW


view viewComponent model =
    let
        expand = accordionExpand

        collapse = accordionCollapse

        content =
            accordionContent viewComponent model.component

        result =
            if model.expand then [ collapse, content] else [ expand ]
    in
        div [] result


accordionContent viewComponent model =
    div [] [ App.map Modify (viewComponent model) ]


accordionExpand =
    div [] [ button [ onClick Expand ] [ text "Expand" ] ]


accordionCollapse =
    div [] [ button [ onClick Collapse ] [ text "Collapse" ] ]


-- SUBSCRIPTIONS


subscriptions gifS model =
    Sub.map Modify (gifS model.component)
