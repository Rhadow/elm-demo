module GifFetcherList (Model, Action, init, update, view) where

import Html exposing (Html, text, button, div, input)
import Html.Events exposing (on, targetValue, onClick)
import Html.Attributes exposing (value)
import Effects exposing (Effects)
import GifFetcher


type alias ID = Int


type alias Model =
    { gifFetchers: List (ID, GifFetcher.Model)
    , topic: String
    , nextID: ID
    }


type Action
    = Create
    | Update ID GifFetcher.Action
    | UpdateTopic String


init: ID -> (Model, Effects Action)
init initialID =
    ( Model [] "" initialID
    , Effects.none
    )


update: Action -> Model -> (Model, Effects Action)
update action model =
    case action of
        Create ->
            let
                (newFetcher, newEffects) = GifFetcher.init model.topic
                newFetchers = model.gifFetchers ++ [(model.nextID, newFetcher)]
            in
                if model.topic /= "" then
                    ( Model newFetchers "" (model.nextID + 1)
                    , Effects.map (Update model.nextID) newEffects)
                else
                    (model, Effects.none)
        UpdateTopic newTopic ->
            ({ model | topic = newTopic }, Effects.none)
        Update id subAction ->
            let
                updateFetchers (fetcherID, fetcher) =
                    if fetcherID == id then
                        let
                            (newFetcher, newEffects) =
                                GifFetcher.update subAction fetcher
                        in
                            (id, newFetcher, newEffects)
                    else
                        (fetcherID, fetcher, Effects.none)


                fetchersWithEffects =
                    List.map updateFetchers model.gifFetchers
                newEffects =
                    List.map
                        (\(fetcherID, _, fxs) ->
                            Effects.map (Update fetcherID) fxs)
                        fetchersWithEffects
                newFetchers =
                    List.map
                        (\(fetcherID, fetcher, _) -> (fetcherID, fetcher))
                        fetchersWithEffects
            in
                ( Model newFetchers model.topic model.nextID
                , Effects.batch newEffects
                )


view: Signal.Address Action -> Model -> Html
view address model =
    let
        topicInput =
            input
                [ on
                    "input"
                    targetValue
                    (\val -> Signal.message address (UpdateTopic val))
                , value model.topic
                ]
                []
        createBtn =
            button [onClick address Create] [ text "Create" ]
        fetchers =
            List.map
                (\(fetcherID, fetcher) ->
                    GifFetcher.view (Signal.forwardTo address (Update fetcherID)) fetcher)
                model.gifFetchers
    in
        div [] ([topicInput, createBtn] ++ fetchers)
