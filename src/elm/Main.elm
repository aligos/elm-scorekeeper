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

        Cancel ->
            { model | name = "", playerId = Nothing }

        Save ->
            if (String.isEmpty model.name) then
                model
            else
                save model

        Score player points ->
            score model player points

        Edit player ->
            { model | name = player.name, playerId = Just player.id }

        DeletePlay play ->
            deletePlay model play


deletePlay : Model -> Play -> Model
deletePlay model play =
    let
        newPlays =
            List.filter (\p -> p.id /= play.id) model.plays

        newPlayers =
            List.map
                (\player ->
                    if player.id == play.playerId then
                        { player | points = player.points - play.points }
                    else
                        player
                )
                model.players
    in
        { model | plays = newPlays, players = newPlayers }


score : Model -> Player -> Int -> Model
score model scorer points =
    let
        newPlayers =
            List.map
                (\player ->
                    if player.id == scorer.id then
                        { player
                            | points = player.points + points
                        }
                    else
                        player
                )
                model.players

        play =
            Play (List.length model.plays) scorer.id scorer.name points
    in
        { model | players = newPlayers, plays = play :: model.plays }


save : Model -> Model
save model =
    case model.playerId of
        Just id ->
            edit model id

        Nothing ->
            add model


edit : Model -> Int -> Model
edit model id =
    let
        newPlayers =
            List.map
                (\player ->
                    if player.id == id then
                        { player | name = model.name }
                    else
                        player
                )
                model.players

        newPlays =
            List.map
                (\play ->
                    if play.playerId == id then
                        { play | name = model.name }
                    else
                        play
                )
                model.plays
    in
        { model
            | players = newPlayers
            , plays = newPlays
            , name = ""
            , playerId = Nothing
        }


add : Model -> Model
add model =
    let
        player =
            Player (List.length model.players) model.name 0

        newPlayers =
            player :: model.players
    in
        { model
            | players = newPlayers
            , name = ""
        }



-- view


view : Model -> Html Msg
view model =
    div [ class "mw5 mw6-ns center pt4" ]
        [ header [ class "tc pv2 pv2-ns" ]
            [ h1 [] [ text "Score Keeper" ] ]
        , playerSection model
        , playerForm model
        , playSection model
        ]


playSection : Model -> Html Msg
playSection model =
    div [ class "pa3" ]
        [ playListHeader
        , playList model
        ]


playList : Model -> Html Msg
playList model =
    model.plays
        |> List.map play
        |> ul [ class "measure h4 overflow-auto" ]


play : Play -> Html Msg
play play =
    li [ class "list dib w-100" ]
        [ span
            [ class "lnr lnr-cross-circle remove mr2 dark-red pointer"
            , onClick (DeletePlay play)
            ]
            []
        , span [] [ text play.name ]
        , span [ class "fr mr2 ph2" ] [ text (toString play.points) ]
        ]


playListHeader : Html Msg
playListHeader =
    header [ class "ph2 bg-light-gray h2" ]
        [ div [ class "fl pv2" ] [ text "Plays" ]
        , div [ class "fr pv2" ] [ text "Points" ]
        ]


playerSection : Model -> Html Msg
playerSection model =
    div [ class "pa3" ]
        [ playerListHeader
        , playerList model
        , pointTotal model
        ]


playerListHeader : Html Msg
playerListHeader =
    header [ class "ph2 bg-light-gray h2" ]
        [ div [ class "fl pv2" ] [ text "Name" ]
        , div [ class "fr pv2" ] [ text "Points" ]
        ]


playerList : Model -> Html Msg
playerList model =
    --ul [ class "measure h4 overflow-auto" ]
    --    (List.map player model.players)
    model.players
        |> List.sortBy .name
        |> List.map player
        |> ul [ class "measure h4 overflow-auto" ]


player : Player -> Html Msg
player player =
    li [ class "h2 list fr" ]
        [ span
            [ class "pointer mh2 lnr lnr-pencil"
            , onClick (Edit player)
            ]
            []
        , span [ class "mh2" ]
            [ text player.name ]
        , button
            [ type_ "button"
            , class "btn-thin pointer mh2 f6 link dim br1 ba pa1 mb2 dib bg-white"
            , onClick (Score player 2)
            ]
            [ text "2pt" ]
        , button
            [ type_ "button"
            , class "btn-thin pointer mh2 f6 link dim br1 ba pa1 mb2 dib bg-white"
            , onClick (Score player 3)
            ]
            [ text "3pt" ]
        , span [ class "mh3" ]
            [ text (toString player.points) ]
        ]


pointTotal : Model -> Html Msg
pointTotal model =
    let
        total =
            List.map .points model.plays
                |> List.sum
    in
        footer [ class "ph2 ph2-ns mv2 bt b--black-10 black-70" ]
            [ div [ class "fr" ]
                [ span [ class "pa1 dib" ] [ text "Total:" ]
                , span [ class "pa1 dib" ] [ text (toString total) ]
                ]
            ]


playerForm : Model -> Html Msg
playerForm model =
    Html.form [ class "pa3 flex w-100 black-80", onSubmit Save ]
        [ input
            [ type_ "text"
            , class "input-reset ba b--black-20 pa2 mb2 db w-60 mr2"
            , placeholder "Add/Edit Player"
            , onInput Input
            , value model.name
            ]
            []
        , button [ type_ "submit", class "w-20 btn-default pointer mr2 f6 link dim br2 ph3 pv2 mb2 dib white bg-dark-blue" ] [ text "Save" ]
        , button [ type_ "button", class "w-20 btn-default pointer mr2 f6 link dim br2 ph3 pv2 mb2 dib white bg-dark-green", onClick Cancel ] [ text "Cancle" ]
        ]


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = initModel
        , view = view
        , update = update
        }
