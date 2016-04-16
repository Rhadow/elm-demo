module GithubPhotoFetcher where

import Html exposing (..)
import Html.Attributes exposing (for, id, value, style, src)
import Html.Events exposing (onClick, on, targetValue)
import Effects exposing (Effects)
import Http
import Task
import Json.Decode as Json exposing ((:=))
import Debug exposing (log)


type alias Model =
    { account: String
    , errorMessage: String
    , photoUrl: String
    }


type Action
    = NoOp
    | ValidateForm
    | SetAccount String
    | SetProfileUrl (Maybe String)


getErrorMessage: String -> String
getErrorMessage account =
    if account == "" then
        "Please enter an account name!"
    else
        ""


decodeUrl: Json.Decoder String
decodeUrl = "avatar_url" := Json.string


getProfilePicture: String -> Effects Action
getProfilePicture account =
    Http.get decodeUrl ("https://api.github.com/users/" ++ account)
        |> Task.toMaybe
        |> Task.map SetProfileUrl
        |> Effects.task

-- MODEL

initialModel: Model
initialModel =
    { account = ""
    , errorMessage = ""
    , photoUrl = "./assets/no-profile.png"
    }


init: (Model, Effects Action)
init =
    (initialModel, Effects.none)

-- UPDATE

update: Action -> Model -> (Model, Effects Action)
update action model =
    case action of
        NoOp ->
            (model, Effects.none)
        ValidateForm ->
            if model.account == "" then
                ( {model | errorMessage = "Please enter an account name!"}
                , Effects.none
                )
            else
                ( {model | errorMessage = ""}
                , getProfilePicture model.account
                )
        SetAccount newAccount ->
            ({model | account = newAccount }, Effects.none)
        SetProfileUrl maybePhotoUrl ->
            ({model | photoUrl = Maybe.withDefault initialModel.photoUrl maybePhotoUrl }, Effects.none)

-- VIEW

view: Signal.Address Action -> Model -> Html
view address model =
    div
        []
        [ h1 [] [ text "Github Profile Fetcher"]
        , div
            []
            [ label [for "account"] [text "Github account:"]
            , input
                [ id "account"
                , value model.account
                , on "input" targetValue (\newVal -> Signal.message address (SetAccount newVal))
                ]
                []
            ]
        , div
            [ style
                [ ("color", "red")
                , ("font-weight", "bold")
                ]
            ]
            [text model.errorMessage]
        , button [onClick address ValidateForm] [text "Submit"]
        , img [src model.photoUrl] []
        ]
