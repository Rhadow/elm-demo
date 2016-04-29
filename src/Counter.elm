module Counter (Model, Action, init, update, view, viewWithDelete) where

import Html exposing (Html, button, span, text, div)
import Html.Events exposing (onClick)


type alias Model = Int


type alias Context =
    { counterAddress: Signal.Address Action
    , removeAddress: Signal.Address ()
    }


type Action
    = Increase
    | Decrease


init: Int -> Model
init val = val


update: Action -> Model -> Model
update action model =
    case action of
        Increase -> model + 1
        Decrease -> model - 1


view: Signal.Address Action -> Model -> Html
view address model =
    div
        []
        [ button [onClick address Decrease] [ text "-" ]
        , span [] [ toString model |> text ]
        , button [onClick address Increase] [ text "+" ]
        ]


viewWithDelete: Context -> Model -> Html
viewWithDelete context model =
    div
        []
        [ button [onClick context.counterAddress Decrease] [ text "-" ]
        , span [] [ toString model |> text ]
        , button [onClick context.counterAddress Increase] [ text "+" ]
        , button [onClick context.removeAddress ()] [ text "X" ]
        ]
