module GifFetcher (Model, Action, init, update, view) where

import Html exposing (Html, div, button, text, img, h2)
import Html.Attributes exposing (src)
import Html.Events exposing (onClick)
import Effects exposing (Effects)
import Http
import Task
import Json.Decode as Json exposing ((:=))


type alias Model =
    { gifUrl: String
    , topic: String
    }


type Action
    = GetRandomGif
    | ReceiveGif (Maybe String)


init: String -> (Model, Effects Action)
init topic =
    (
      { gifUrl = "./assets/waiting.gif"
      , topic = topic
      }
    , getRandomGif topic
    )


update: Action -> Model -> (Model, Effects Action)
update action model =
    case action of
        GetRandomGif ->
            ( Model "./assets/waiting.gif" model.topic
            , getRandomGif model.topic
            )
        ReceiveGif maybeUrl ->
            case maybeUrl of
                Nothing ->
                    (model, Effects.none)
                Just newGifUrl ->
                    (Model newGifUrl model.topic, Effects.none)


view: Signal.Address Action -> Model -> Html
view address model =
    div
        []
        [ h2 [] [text model.topic]
        , img [ src model.gifUrl ] []
        , button [onClick address GetRandomGif] [text "More!"]
        ]


getRandomGif: String -> Effects Action
getRandomGif topic =
    Http.get gifDecoder (randomUrl topic)
    |> Task.toMaybe
    |> Task.map ReceiveGif
    |> Effects.task


gifDecoder: Json.Decoder String
gifDecoder =
    Json.at ["data"] ("image_url" := Json.string)


randomUrl : String -> String
randomUrl topic =
    Http.url "http://api.giphy.com/v1/gifs/random"
        [ ("api_key", "dc6zaTOxFJmzC")
        , ("tag", topic)
        ]
