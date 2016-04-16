module Main where

import StartApp
import Task
import GithubPhotoFetcher exposing (init, update, view)
import Effects exposing (Never)


app =
    StartApp.start
        { init = init
        , update = update
        , view = view
        , inputs = []
        }


main =
    app.html


port tasks: Signal (Task.Task Never ())
port tasks =
    app.tasks
