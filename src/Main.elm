module Main where

import StartApp.Simple
import Html exposing (Html)
import Counter exposing (init, update, view)


main: Signal Html
main =
    StartApp.Simple.start
        { model = init
        , update = update
        , view = view
        }
