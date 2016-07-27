module Components.Collection exposing (..)

import Html.App as App

import Html exposing (Html, div, text, button)
import Html.Events exposing (onClick)


-- MAIN

import Components.Gif as Gif


main : Program Never
main =
    App.program
        { init = init (Gif.init Nothing) Gif.update Gif.view Gif.subscriptions
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


-- MODEL

type alias Model component init update view subscriptions =
    { uid : Int
    , components : List (IndexedComponent component)
    , init : init
    , update : update
    , view : view
    , subscriptions : subscriptions
    }

type alias IndexedComponent component =
    { id : Int
    , model : component
    }


-- INIT

init componentInit componentUpdate componentView componentSubscriptions =
    Model 0 [] componentInit componentUpdate componentView componentSubscriptions ! []


-- MESSAGES


type Msg componentMsg
    = Insert
    | Remove
    | Modify Int componentMsg


-- UPDATE


update message model =
    case message of
        Insert ->
            let
                ( component, cmds ) = model.init
            in
                { model
                    | components = model.components ++ [ IndexedComponent model.uid component ]
                    , uid = model.uid + 1
                } ! [Cmd.map (Modify model.uid) cmds]

        Remove ->
            { model | components = List.drop 1 model.components } ! []

        Modify id componentMsg ->
            let
                (components, cmds) =
                    List.unzip ( List.map (updateHelp model.update id componentMsg) model.components )
            in
                { model | components = components } ! cmds


updateHelp update id msg model =
    if model.id /= id then
        (model, Cmd.none)
    else
        let
            ( component, cmds) =
                update msg model.model
        in
            ( IndexedComponent id component
            , Cmd.map (Modify id) cmds
            )


-- VIEW

view model =
    let
        remove =
            button [ onClick Remove ] [ text "Remove" ]

        insert =
            button [ onClick Insert ] [ text "Add" ]

        components =
            List.map (viewIndexedComponent model.view) model.components

        result =
            insert :: remove :: components
    in
        div [] result

viewIndexedComponent view {id, model} =
    App.map (Modify id) (view model)


-- SUBSCRIPTIONS


subscriptions model =
    Sub.batch (List.map (subHelp model.subscriptions) model.components)

subHelp subscriptions {id, model} =
    Sub.map (Modify id) (subscriptions model)
