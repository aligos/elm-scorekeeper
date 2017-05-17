module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


-- model


type alias Model =
    { players : List Player
    , name : String
    , playerId : Maybe Int
    , plays : List Play
    }


type alias Player =
    { id : Int
    , name : String
    , points : Int
    }


type alias Play =
    { id : Int
    , playerId : Int
    , name : String
    , points : Int
    }


initModel : Model
initModel =
    { players = []
    , name = ""
    , playerId = Nothing
    , plays = []
    }



-- update


type Msg
    = Edit Player
    | Score Player Int
    | Input String
    | Save
    | Cancel
    | DeletePlay Play


update : Msg -> Model -> Model
update msg model =
    case msg of
        Input name ->
            { model | name = name }

        _ ->
            model



-- view


view : Model -> Html Msg
view model =
    div [ class "mw5 mw6-ns center pt4" ]
        [ header [ class "tc pv2 pv2-ns" ]
            [ h1 [] [ text "Score Keeper" ] ]
        , playerForm model
        , p [] [ text (toString model) ]
        ]


playerForm : Model -> Html Msg
playerForm model =
    Html.form [ class "pa4 black-80", onSubmit Save ]
        [ input
            [ type_ "text"
            , class "input-reset ba b--black-20 pa2 mb2 db w-100"
            , placeholder "Add/Edit Player"
            , onInput Input
            , value model.name
            ]
            []
        , button [ type_ "submit", class "btn-default mr2 f6 link dim br2 ph3 pv2 mb2 dib white bg-dark-blue" ] [ text "Save" ]
        , button [ type_ "button", class "btn-default mr2 f6 link dim br2 ph3 pv2 mb2 dib white bg-dark-green", onClick Cancel ] [ text "Cancle" ]
        ]


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = initModel
        , view = view
        , update = update
        }
