module DoubleGifFetcher (Model, Action, init, update, view) where

import Html exposing (Html, div)
import Effects exposing (Effects)
import GifFetcher


type alias Model =
    { top: GifFetcher.Model
    , bottom: GifFetcher.Model
    }


type Action
    = Top GifFetcher.Action
    | Bottom GifFetcher.Action


init: String -> String -> (Model, Effects Action)
init topTopic bottomTopic =
    let
        (topModel, topEffects) = GifFetcher.init topTopic
        (bottomModel, bottomEffects) = GifFetcher.init bottomTopic
    in
        ( { top = topModel, bottom = bottomModel}
        , Effects.batch
            [ Effects.map Top topEffects
            , Effects.map Bottom bottomEffects
            ]
        )


update: Action -> Model -> (Model, Effects Action)
update action model =
    case action of
        Top subAction ->
            let
                (newModel, newEffects) =
                    GifFetcher.update subAction model.top
            in
                (Model newModel model.bottom, Effects.map Top newEffects)
        Bottom subAction ->
            let
                (newModel, newEffects) =
                    GifFetcher.update subAction model.bottom
            in
                (Model model.top newModel, Effects.map Bottom newEffects)


view: Signal.Address Action -> Model -> Html
view address model =
    div
        []
        [ GifFetcher.view (Signal.forwardTo address Top) model.top
        , GifFetcher.view (Signal.forwardTo address Bottom) model.bottom
        ]
