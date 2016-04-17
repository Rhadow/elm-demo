module Counter where

import Html exposing (..)
import Html.Attributes exposing (style, class)
import Html.Events exposing (onClick)

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
        [ button [onClick address Decrease, class "counter-button"] [text "-"]
        , div [counterStyle] [text (toString model)]
        , button [onClick address Increase, class "counter-button"] [text "+"]
        ]


counterStyle: Attribute
counterStyle =
    style
        [ ("color", "red")
        , ("display", "inline-block")
        , ("margin", "0 5px")
        ]
