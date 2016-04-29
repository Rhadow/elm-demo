module Main where

import StartApp
import Html exposing (Html)
import GifFetcherList exposing (init, update, view)
import Task
import Effects exposing (Never)


app =
    StartApp.start
        { init = init 0
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
