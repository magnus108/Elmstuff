module Components.Accordion exposing (..)

import Html exposing (Html, button, div, text, h2, img)
import Html.Attributes exposing (src)
import Html.Events exposing (onClick)
import Html.App as App
import Http
import Json.Decode as Json
import Task


-- MAIN


main : Program Never
main =
    App.program
        { init = init Nothing
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


-- MODEL


type alias Model =
    { expand : Bool
    }


-- INIT


defaultModel : Model
defaultModel =
    { expand = False
    }


init : Maybe Model -> ( Model, Cmd Msg )
init model =
    let
        default = Maybe.withDefault defaultModel model
    in
        default ! []


-- MESSAGES


type Msg
    = Expand
    | Collapse


-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Expand ->
            { model | expand = True } ! []

        Collapse ->
            { model | expand = False } ! []


-- VIEW


view : Model -> Html Msg
view model =
    let
        expand = accordionExpand
        collapse = accordionCollapse
    in
        div []
            [ expand
            , collapse
            ]


accordionExpand : Html Msg
accordionExpand =
    div []
        [ button [ onClick Expand ] [ text "Expand" ]
        ]


accordionCollapse : Html Msg
accordionCollapse =
    div []
        [ button [ onClick Collapse ] [ text "Collapse" ]
        ]


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
