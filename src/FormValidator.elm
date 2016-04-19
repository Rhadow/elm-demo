module FormValidator where

import Html exposing (..)
import Html.Attributes exposing (style, id, for, value, type')
import Html.Events exposing (on, onClick, targetValue)


type alias Model =
    { username: String
    , password: String
    , errorMessage: ErrorMessage
    }


type alias ErrorMessage =
    { userErrMsg: String
    , passwordErrMsg: String
    }


type Action
    = SetUser String
    | SetPassword String
    | Validate


updateErrorMessage: String -> String -> ErrorMessage
updateErrorMessage user password =
    let
        userErrMsg = if user == "" then "User must not be empty!" else ""
        passwordErrMsg =
            if password == "" then
                "Password must not be empty!"
            else
                ""
    in
        { userErrMsg = userErrMsg, passwordErrMsg = passwordErrMsg}


model: Model
model =
    { username = ""
    , password = ""
    , errorMessage =
        { userErrMsg = ""
        , passwordErrMsg = ""
        }
    }


update: Action -> Model -> Model
update action model =
    case action of
        SetUser newUser ->
            { model | username = newUser }
        SetPassword newPassword ->
            { model | password = newPassword }
        Validate ->
            let
                newErrorMessage = updateErrorMessage model.username model.password
            in { model | errorMessage = newErrorMessage }


inputWithError: String -> String -> String -> String -> String -> (String -> Signal.Message) -> Html
inputWithError inputId displayText inputValue errMsg inputType onInputHandler =
    div
        []
        [ label [for inputId] [text displayText]
        , input
            [ id inputId
            , on "input" targetValue onInputHandler
            , value inputValue
            , type' inputType
            ]
            []
        , div [style [("color", "red")]] [text errMsg]
        ]


view: Signal.Address Action -> Model -> Html
view address model =
    div
        []
        [ h1 [] [ text "Form Validation Demo" ]
        , inputWithError
            "username"
            "Username: "
            model.username
            model.errorMessage.userErrMsg
            "text"
            (\str -> Signal.message address (SetUser str))
        , inputWithError
            "password"
            "Password: "
            model.password
            model.errorMessage.passwordErrMsg
            "password"
            (\str -> Signal.message address (SetPassword str))
        , button [onClick address Validate] [text "Submit"]
        ]
