module Main exposing (..)

import Html.App
import Html exposing (Html)

-- Example 1. Counter
-- import Counter exposing (model, update, view)

-- Example 2. Form Validation
import FormValidator exposing (model, update, view)

-- Example 3. Form Validation and Http request
-- import GithubPhotoFetcher exposing (init, update, view)
--
-- import Effects exposing (Never)


-- For Example 1 & 2
main =
    Html.App.beginnerProgram
        { model = model
        , update = update
        , view = view
        }


-- For Example 3
-- app =
--     StartApp.start
--         { init = init
--         , update = update
--         , view = view
--         , inputs = []
--         }
--
-- main: Signal Html
-- main =
--     app.html
--
--
-- port tasks: Signal (Task.Task Never ())
-- port tasks =
--     app.tasks
