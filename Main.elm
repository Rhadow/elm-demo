module Main where

import Html exposing (..)
import Task
import Effects exposing (Effects, Never)
import StartApp

import App exposing (init, update, view, Model)


app: StartApp.App Model
app = StartApp.start
    {
        init = init,
        view = view,
        update = update,
        inputs = []
    }

main: Signal Html
main =
    app.html

port tasks : Signal (Task.Task Never ())
port tasks =
    app.tasks
