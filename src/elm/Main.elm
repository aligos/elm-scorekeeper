import Html exposing (..)
import Html.Events exposing (onClick)
import Html.Attributes exposing (..)

-- APP
main =
  Html.beginnerProgram { model = 0, view = view, update = update }

-- UPDATE-
type Msg = Increment | Decrement

update msg model =
  case msg of
    Increment ->
      model + 1

    Decrement ->
      model - 1

-- VIEW-
view : a -> Html Msg
view model =
  div [ class "dib dtc-ns v-mid w-100 tl tr-ns mt2 mt0-ns" ]
    [ button [ class "b--black-20 bg-white black br2", onClick Decrement ] [ text "-" ]
    , span [ class "ph1-ns" ] [ text (toString model) ]
    , button [ class "b--black-20 bg-white black br2", onClick Increment ] [text "+" ]
    ]