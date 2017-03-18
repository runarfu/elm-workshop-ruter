module State exposing (..)

import Http
import Types exposing (..)
import RuterAPI exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FilterInput input ->
            model
                |> updateFilterInput input
                |> noCmd

        ChooseStop stop ->
            model
                |> chooseStop stop
                |> noCmd

        DiscardStop stop ->
            model
                |> discardStop stop
                |> noCmd

        StopsResponse result ->
            case result of
                Ok stops ->
                    model
                        |> updateStops stops
                        |> noCmd

                Err error ->
                    "StopsResponse failed: "
                        ++ (toString error)
                        |> Debug.crash


updateFilterInput : String -> Model -> Model
updateFilterInput input model =
    { model | filterInput = input }


updateStops : List Stop -> Model -> Model
updateStops stops model =
    { model | stops = stops }


chooseStop : Stop -> Model -> Model
chooseStop stop model =
    let
        stopIsAlreadyChosen =
            stopListContainsElement model.chosenStops stop
    in
        if stopIsAlreadyChosen then
            model
        else
            addStopToChosenList stop model


addStopToChosenList : Stop -> Model -> Model
addStopToChosenList stop model =
    { model | chosenStops = stop :: model.chosenStops }


stopListContainsElement : List Stop -> Stop -> Bool
stopListContainsElement stopList stop =
    stopList
        |> List.any (stopEquals stop)


stopEquals : Stop -> Stop -> Bool
stopEquals stop1 stop2 =
    stop1.iD == stop2.iD


discardStop : Stop -> Model -> Model
discardStop stop model =
    { model
        | chosenStops =
            model.chosenStops
                |> List.filter (not << stopEquals stop)
    }


getStops : Cmd Msg
getStops =
    RuterAPI.getStops
        |> Http.send StopsResponse


noCmd : Model -> ( Model, Cmd Msg )
noCmd model =
    ( model, Cmd.none )
