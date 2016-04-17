module Counter where

import Html exposing (..)
import Html.Attributes exposing (for, id, value, style, src)
import Html.Events exposing (onClick, on, targetValue)

type alias Model =
    Int


type Action
    = Increase
    | Decrease


init: Model
init = 0


update: Action -> Model -> Model
update action model =
    case action of
        Increase -> model + 1
        Decrease -> model - 1


view: Signal.Address Action -> Model -> Html
view address model =
    div
        []
        [ button [onClick address Decrease] [text "-"]
        , div [] [text (toString model)]
        , button [onClick address Increase] [text "+"]
        ]
