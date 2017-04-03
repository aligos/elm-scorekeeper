import Html exposing (..)
import Html.Events exposing (onInput)

-- APP
main : Program Never Model Msg
main =
  Html.beginnerProgram { model = model, view = view, update = update }

-- MODEl-
type alias Model = String
model : Model
model =
  "Hello World"

-- UPDATE-
type Msg = UpdateName String

update : Msg -> Model -> Model
update msg model =
  case msg of
    UpdateName name ->
      "Hello " ++ name

-- VIEW-
view : Model -> Html Msg
view model =
  div []
    [ label [] [ text "Your Name: " ]
    , input [ onInput UpdateName ] []
    , div [] [text model ]
    ]