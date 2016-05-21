module GithubPhotoFetcher exposing (..)

import Html exposing (..)
import Html.Attributes exposing (for, id, value, style, src)
import Html.Events exposing (onClick, onInput)
import Http
import Task
import Json.Decode as Json exposing ((:=))
import Debug exposing (log)


type alias Model =
    { account: String
    , errorMessage: String
    , photoUrl: String
    }


type Msg
    = NoOp
    | ValidateForm
    | SetAccount String
    | SetProfileUrl String
    | FetchFailed Http.Error


decodeUrl: Json.Decoder String
decodeUrl = "avatar_url" := Json.string


getProfilePicture: String -> Cmd Msg
getProfilePicture account =
    let
        url = "https://api.github.com/users/" ++ account
    in
        Task.perform FetchFailed SetProfileUrl (Http.get decodeUrl url)

-- MODEL

initialModel: Model
initialModel =
    { account = ""
    , errorMessage = ""
    , photoUrl = "./assets/no-profile.png"
    }


init: (Model, Cmd Msg)
init =
    (initialModel, Cmd.none)

-- UPDATE

update: Msg -> Model -> (Model, Cmd Msg)
update action model =
    case action of
        NoOp ->
            (model, Cmd.none)
        ValidateForm ->
            if model.account == "" then
                ( {model | errorMessage = "Please enter an account name!"}
                , Cmd.none
                )
            else
                ( {model | errorMessage = ""}
                , getProfilePicture model.account
                )
        SetAccount newAccount ->
            ({model | account = newAccount }, Cmd.none)
        SetProfileUrl photoUrl ->
            ( { model
              | photoUrl = photoUrl
              }
            , Cmd.none
            )
        FetchFailed _ ->
            ( { model
              | photoUrl = ""
              , errorMessage = "No such user!"
              }
            , Cmd.none
            )

-- VIEW

view: Model -> Html Msg
view model =
    div
        []
        [ h1 [] [ text "Github Profile Fetcher"]
        , div
            []
            [ label [for "account"] [text "Github account:"]
            , input
                [ id "account"
                , value model.account
                , onInput SetAccount
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
        , button [onClick ValidateForm] [text "Submit"]
        , img [src model.photoUrl] []
        ]
