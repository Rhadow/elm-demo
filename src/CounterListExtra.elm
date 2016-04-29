module CounterListExtra (Model, Action, init, view, update) where

import Html exposing (Html, div, text, button)
import Html.Events exposing (onClick)
import Counter


type alias ID = Int


type alias Model =
    { counters: List (ID, Counter.Model)
    , nextId: ID
    }


type Action
    = Create
    | Update ID Counter.Action
    | Delete ID


init: ID -> Model
init num =
    { counters = []
    , nextId = num
    }


update: Action -> Model -> Model
update action model =
    case action of
        Create ->
            let
                newCounter = (model.nextId, Counter.init 0)
                newCounters = model.counters ++ [newCounter]
            in
                Model newCounters (model.nextId + 1)
        Update id subAction ->
            let
                updateCounter (id', counter) =
                    if id == id' then
                        (id, Counter.update subAction counter)
                    else
                        (id', counter)
                newCounters =
                    List.map updateCounter model.counters
            in
                Model newCounters model.nextId
        Delete id ->
            { model |
                counters = List.filter (\(id', _) -> id' /= id) model.counters
            }


view: Signal.Address Action -> Model -> Html
view address model =
    let
        context id' =
            { counterAddress = Signal.forwardTo address (Update id')
            , removeAddress = Signal.forwardTo address (always (Delete id'))
            }
        createBtn = button [onClick address Create] [ text "Create" ]
        counters = List.map (\(id', counter) -> Counter.viewWithDelete (context id') counter ) model.counters
    in
        div
            []
            ([createBtn] ++ counters)
