module Main where

import StartApp.Simple
import Html exposing (Html)
import DoubleCounter exposing (init, update, view)


main: Signal Html
main =
    StartApp.Simple.start
        { model = init 0 0
        , update = update
        , view = view
        }
