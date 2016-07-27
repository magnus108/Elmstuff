import Html exposing (Html, Attribute, ul, li, a, p, div, hr, input, span, text)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Navigation
import String
import Task
import UrlParser exposing (Parser, (</>), format, int, oneOf, s, string)


-- MAIN


main =
    Navigation.program (Navigation.makeParser hashParser)
        { init = init
        , view = view
        , update = update
        , urlUpdate = urlUpdate
        , subscriptions = subscriptions
        }


-- URL STUFF


type Page
    = Home
    | Blog Int
    | Gif String


pageParser : Parser (Page -> a) a
pageParser =
    oneOf
        [ format Home (s "home")
        , format Blog (s "blog" </> int)
        , format Gif (s "gif" </> string)
        ]


hashParser : Navigation.Location -> Result String Page
hashParser location =
    UrlParser.parse identity pageParser (String.dropLeft 1 location.hash)


toHash : Page -> String
toHash page =
    case page of
        Home ->
            "#home"

        Blog id ->
            "#blog/" ++ toString id

        Gif str ->
            "#gif/" ++ str


navigate : Page -> Cmd msg
navigate page =
    Navigation.newUrl (toHash page)


modify : Page -> Cmd msg
modify page =
    Navigation.modifyUrl (toHash page)


linkTo : Page -> List (Attribute msg) -> List (Html msg) -> Html msg
linkTo page attrs content =
    a ( [ href (toHash page) ] ++ attrs) content












-- MODEL


type alias Model =
    { page : Page
    }


init : Result String Page -> (Model, Cmd Msg)
init result =
    urlUpdate result (Model Home)


-- UPDATE


type Msg
    = NoOp



update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        NoOp ->
            model ! []



urlUpdate : Result String Page -> Model -> (Model, Cmd Msg)
urlUpdate result model =
  case result of
    Err _ ->
      ( model, modify model.page )

    Ok page ->
      { model
        | page = page
      }
        ! []



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ ul []
            [ viewLink Home "Home"
            , viewLink (Blog 42) "Cat Facts"
            , viewLink (Blog 13) "Alligator Jokes"
            , viewLink (Blog 26) "Workout Plan"
            , viewLink (Gif "cat") "CATS!"
            ]
        , hr [] []
        , div [] (viewPage model)
        ]


viewLink : Page -> String -> Html msg
viewLink page description =
    li [] [ linkTo page [] [ text description ] ]


viewPage : Model -> List (Html msg)
viewPage model =
    case model.page of
        Home ->
            [ text "Welcome!"
            , text "Play with the links and search bar above. (Press ENTER to trigger the zip code search.)"
            ]

        Blog id ->
            [ p [] [ text "This is blog post number" ]
            , p [] [ text (toString id) ]
            ]

        Gif str ->
            [ p [] [ text "This is a Cat" ]
            , p [] [ text str ]
            ]


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
