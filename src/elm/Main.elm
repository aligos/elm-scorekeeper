import Html exposing (..)
import Html.Events exposing (onInput)
import Html.Attributes exposing (..)

main =
  Html.beginnerProgram { model = model, view = view, update = update }

-- MODEL
type alias Model = 
  { userName : String
  , password : String
  , passwordAgain : String
  }

model : Model
model =
  Model "" "" ""

-- UPDATE-
type Msg
  = UserName String
  | Password String
  | PasswordAgain String

  
update : Msg -> Model -> Model
update msg model =
  case msg of
    UserName userName ->
      { model | userName = userName }
    Password password ->
      { model | password = password }
    PasswordAgain password ->
      { model | passwordAgain = password }


-- VIEW-
view : Model -> Html Msg
view model =
  div [ class "mw7 mw6-ns center bg-light-gray pa3 ph6-ns" ]
    [ input [ class "w-100", type_ "text", placeholder "Username", onInput UserName ] []
    , input [ class "w-100", type_ "password", placeholder "Password", onInput Password ] []
    , input [ class "w-100", type_ "password", placeholder "Re-enter Password", onInput PasswordAgain ] []
    , viewValidation model
    ]


viewValidation : Model -> Html msg
viewValidation model =
  let
    (color, message) =
      if model.password == model.passwordAgain && model.password /= "" && model.passwordAgain /= "" then
        ("green", "OK")
      else if model.password == "" || model.passwordAgain == "" then
        ("orange", "Password is Empty")
      else
        ("red", "Password do not match!")
  in
    div [ class "tc", style [("color", color)] ] [ text message ]