module Main where

import StartApp
import Html exposing (..)
import Html.Attributes exposing (for, id, value)
import Html.Events exposing (onClick, on, targetValue)
import Maybe exposing ( Maybe(..) ) -- Maybe, Just, Nothing
import Effects exposing (Effects)


type alias Model =
    { account: String
    , errorMessage: String
    , photoUrl: Maybe String
    }


type Action =
    NoOp
    | ValidateForm
    | SetAccount String



init: (Model, Effects Action)
init =
    ({ account = ""
    , errorMessage = ""
    , photoUrl = Nothing
    }
    , Effects.none
    )


getErrorMessage: String -> String
getErrorMessage account =
    if account == "" then
        "Please enter an account name!"
    else
        ""


update: Action -> Model -> (Model, Effects Action)
update action model =
    case action of
        NoOp ->
            (model, Effects.none)
        ValidateForm ->
            ({model | errorMessage = getErrorMessage model.account}, Effects.none)
        SetAccount newAccount ->
            ({model | account = newAccount }, Effects.none)


textInput: String -> String -> String -> Html
textInput id' labelName value' =
    div [] [
        label [
            for id'
        ] [
            text labelName
        ]
        , input [
            id id'
            , value value'
        ] []
    ]


view: Signal.Address Action -> Model -> Html
view address model =
    div [] [
        h1 [] [ text "Github Profile Fetcher"]
        , div [] [
            label [
                for "account"
            ] [
                text "Github account:"
            ]
            , input [
                id "account"
                , value model.account,
                on "input" targetValue (\newVal -> Signal.message address (SetAccount newVal))
            ] []
        ]
        , div [] [
            text model.errorMessage
        ]
        , button [
            onClick address ValidateForm
        ] [
            text "Submit"
        ]
    ]


app =
    StartApp.start
        { init = init
        , update = update
        , view = view
        , inputs = []
        }


main: Signal Html
main =
    app.html
