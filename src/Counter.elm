module Counter exposing (model, update, view)

import Html exposing (..)
import Html.Attributes exposing (style, class)
import Html.Events exposing (onClick)

type alias Model =
    Int


type Action
    = Increase
    | Decrease


model: Model
model = 0


update: Action -> Model -> Model
update action model =
    case action of
        Increase -> model + 1
        Decrease -> model - 1


view: Model -> Html Action
view model =
    div
        []
        [ button [onClick Decrease, class "counter-button"] [text "-"]
        , span [counterStyle] [text (toString model)]
        , button [onClick Increase, class "counter-button"] [text "+"]
        ]


counterStyle =
    style
        [ ("color", "red")
        , ("display", "inline-block")
        , ("margin", "0 5px")
        ]
