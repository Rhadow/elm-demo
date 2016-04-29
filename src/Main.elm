module Main where

import StartApp
import Html exposing (Html)
import DoubleGifFetcher exposing (init, update, view)
import Task
import Effects exposing (Never)


app =
    StartApp.start
        { init = init "cat" "dog"
        , update = update
        , view = view
        , inputs = []
        }


main: Signal Html
main =
    app.html


port tasks: Signal (Task.Task Never ())
port tasks =
    app.tasks
