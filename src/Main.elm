module Main exposing (..)

import Html.App
import Html exposing (Html)

-- Example 1. Counter
-- import Counter exposing (model, update, view)

-- Example 2. Form Validation
-- import FormValidator exposing (model, update, view)

-- Example 3. Form Validation and Http request
-- import GithubPhotoFetcher exposing (init, update, view)


-- For Example 1 & 2
-- main =
--     Html.App.beginnerProgram
--         { model = model
--         , update = update
--         , view = view
--         }


-- For Example 3
main =
    Html.App.program
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }
