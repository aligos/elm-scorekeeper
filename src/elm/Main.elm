import Html exposing (..)
import Html.Events exposing (onInput)
import Html.Attributes exposing (..)

main =
  Html.beginnerProgram { model = model, view = view, update = update }

-- MODEL
type alias Model = 
  { content : String 
  }

model : Model
model =
  { content = "" }

-- UPDATE-
type Msg = 
  Change String
  
update : Msg -> Model -> Model
update msg model =
  case msg of
    Change newContent ->
      { model | content = newContent }

-- VIEW-
view : Model -> Html Msg
view model =
  div [ class "dib dtc-ns v-mid w-100 tl tr-ns mt2 mt0-ns" ]
    [ input [ placeholder "Text to reverse", onInput Change ] []
    , span [ class "ph1-ns" ] [ text (String.reverse model.content) ]
    ]