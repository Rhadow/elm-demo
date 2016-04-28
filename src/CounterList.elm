module CounterList (Model, Action, init, update, view) where

import Html exposing (Html, button, span, text, div)
import Html.Events exposing (onClick)
import Counter


type alias ID = Int


type alias Model =
    { counterList: List
        { id': ID
        , counter: Counter.Model
        }
    , nextId: ID
    }


type Action
    = CreateCounter
    | UpdateCounter ID Counter.Action
    | DeleteCounter


init: ID -> Model
init id' =
    { counterList = []
    , nextId = id'
    }


update: Action -> Model -> Model
update action model =
    case action of
        CreateCounter ->
            let
                newCounter =
                    { counter = Counter.init 0
                    , id' = model.nextId
                    }
                newCounters =
                    model.counterList ++ [newCounter]
            in
                { model | counterList = newCounters, nextId = model.nextId + 1}
        UpdateCounter id' subAction ->
            let
                updateTargetCounter counter =
                    if counter.id' == id' then
                        { counter | counter =
                            Counter.update subAction counter.counter
                        }
                    else
                        counter
                newCounters =
                    List.map (updateTargetCounter) model.counterList
            in
                { model | counterList = newCounters }
        DeleteCounter ->
            { model | counterList = List.drop 1 model.counterList }


view: Signal.Address Action -> Model -> Html
view address model =
    let
        counters = (List.map
            (\counter ->
                Counter.view
                    (Signal.forwardTo address (UpdateCounter counter.id'))
                    counter.counter
            )
            model.counterList
        )
        deleteBtn = button [onClick address DeleteCounter] [ text "Delete"]
        createBtn = button [onClick address CreateCounter] [ text "Create"]
    in
        div
            []
            ([createBtn, deleteBtn] ++ counters)
