module Main exposing (..)

import Html.App as App

import Html exposing (Html, div, text, button)
import Html.Events exposing (onClick)

import Components.GifAccordion as GifAccordion


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
    { gifAccordions : List IndexedGifAccordion
    , uid : Int
    }


type alias IndexedGifAccordion =
    { id : Int
    , model : GifAccordion.Model
    }


-- INIT


defaultModel : Model
defaultModel =
    { gifAccordions = []
    , uid = 0
    }


init : Maybe Model -> ( Model, Cmd Msg )
init model =
    let
        default = Maybe.withDefault defaultModel model
    in
        default ! []


-- MESSAGES


type Msg
    = Insert
    | Remove
    | SubMsg Int GifAccordion.Msg


-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        Insert ->
            let
                ( newGifAccordion, cmds ) = GifAccordion.init
            in
                { model
                    | gifAccordions = model.gifAccordions ++ [ IndexedGifAccordion model.uid newGifAccordion ]
                    , uid = model.uid + 1
                } ! [Cmd.map (SubMsg model.uid) cmds]

        Remove ->
            { model | gifAccordions = List.drop 1 model.gifAccordions } ! []

        SubMsg id subMsg ->
            let
                (newGifAccordions, cmds) =
                    List.unzip (List.map (updateHelp id subMsg) model.gifAccordions)
            in
                { model | gifAccordions = newGifAccordions } ! cmds


updateHelp : Int -> GifAccordion.Msg -> IndexedGifAccordion -> ( IndexedGifAccordion, Cmd Msg )
updateHelp targetId msg gifAccordion =
    if gifAccordion.id /= targetId then
        (gifAccordion, Cmd.none )
    else
        let
            ( newGifAccordion, cmds) =
                GifAccordion.update msg gifAccordion.model
        in
            ( IndexedGifAccordion targetId newGifAccordion
            , Cmd.map (SubMsg targetId) cmds
            )


-- VIEW


view : Model -> Html Msg
view model =
    let
        remove =
            button [ onClick Remove ] [ text "Remove" ]

        insert =
            button [ onClick Insert ] [ text "Add" ]

        counters =
            List.map viewIndexedGifAccordion model.gifAccordions

    in
        if (List.length model.gifAccordions > 0) then
            div [] (remove :: insert :: counters)
        else
            div [] (insert :: counters)


viewIndexedGifAccordion : IndexedGifAccordion -> Html Msg
viewIndexedGifAccordion {id, model} =
    App.map (SubMsg id) (GifAccordion.view model)


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch (List.map subHelp model.gifAccordions)


subHelp : IndexedGifAccordion -> Sub Msg
subHelp {id, model} =
    Sub.map (SubMsg id) (GifAccordion.subscriptions model)
