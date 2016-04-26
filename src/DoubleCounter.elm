module DoubleCounter where

import Html exposing (div, Html)
import Signal exposing (forwardTo)
import Counter


type alias Model =
    { top: Counter.Model
    , bottom: Counter.Model
    }


type Action
    = Top Counter.Action
    | Bottom Counter.Action


init: Int -> Int -> Model
init topVal bottomVal =
    { top = Counter.init topVal
    , bottom = Counter.init bottomVal
    }


update: Action -> Model -> Model
update action model =
    case action of
        Top act ->
            Model (Counter.update act model.top) model.bottom
        Bottom act ->
            Model model.top (Counter.update act model.bottom)

view: Signal.Address Action -> Model -> Html
view address model =
    div
        []
        [ Counter.view (forwardTo address Top) model.top
        , Counter.view (forwardTo address Bottom) model.bottom
        ]
