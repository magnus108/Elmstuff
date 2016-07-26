module Components.Gif exposing (..)

import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (..)
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
    { topic : String
    , gifUrl : String
    }


-- INIT


defaultModel : Model
defaultModel =
    { topic = "cats"
    , gifUrl = "waiting.gif"
    }


init : Maybe Model -> ( Model, Cmd Msg )
init model =
    let
        default = Maybe.withDefault defaultModel model
    in
        default ! [ getRandomGif default.topic ]


-- MESSAGES


type Msg
    = MorePlease
    | FetchSucceed String
    | FetchFail Http.Error


-- UPDATE


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        MorePlease ->
            model ! [ getRandomGif model.topic ]

        FetchSucceed newUrl ->
            { model | gifUrl = newUrl } ! []

        FetchFail _ ->
            model ! []


-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h2 [] [text model.topic]
        , button [ onClick MorePlease ] [ text "More Please!" ]
        , br [] []
        , img [src model.gifUrl] []
        ]


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


-- HTTP


getRandomGif : String -> Cmd Msg
getRandomGif topic =
    let
        url =
            "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=" ++ topic
    in
        Task.perform FetchFail FetchSucceed (Http.get decodeGifUrl url)


decodeGifUrl : Json.Decoder String
decodeGifUrl =
    Json.at ["data", "image_url"] Json.string
