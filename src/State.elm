module State exposing (..)

import Http
import Time exposing (Time)
import Date exposing (Date)
import Types exposing (..)
import RuterAPI exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case model of
        Initialized ->
            case msg of
                StopsResponse result ->
                    model
                        |> updateWithResultOrCrash result updateStops
                        |> noCmd

                _ ->
                    noCmd model

        ChoosingStops { availableStops } ->
            case msg of
                StopFilterInput input ->
                    model
                        |> updateStopFilter input
                        |> noCmd

                ChooseStop stop ->
                    ChosenStop { chosenStop = stop, departures = [], now = Nothing }
                        |> andCmd (getDepartures stop)

                _ ->
                    noCmd model

        ChosenStop { chosenStop, departures, now } ->
            case msg of
                DeparturesResponse result ->
                    model
                        |> updateWithResultOrCrash result (updateDepartures chosenStop now)
                        |> andCmd (getDepartures chosenStop)

                Tick time ->
                    model
                        |> updateNow time
                        |> noCmd

                _ ->
                    noCmd model

        Crashed _ ->
            noCmd model


updateNow : Time -> Model -> Model
updateNow time model =
    case model of
        ChosenStop { chosenStop, departures, now } ->
            ChosenStop { chosenStop = chosenStop, departures = departures, now = time |> Date.fromTime |> Just }

        _ ->
            model


updateWithResultOrCrash : Result Http.Error a -> (a -> Model -> Model) -> Model -> Model
updateWithResultOrCrash result function model =
    case result of
        Ok value ->
            model
                |> function value

        Err error ->
            model
                |> crash (toString error)


updateStops : List Stop -> Model -> Model
updateStops stops model =
    ChoosingStops { availableStops = stops, stopFilter = "" }


updateDepartures : Stop -> Maybe Date -> List Departure -> Model -> Model
updateDepartures stop date departures model =
    ChosenStop { chosenStop = stop, now = date, departures = departures }


updateStopFilter : String -> Model -> Model
updateStopFilter input model =
    case model of
        ChoosingStops { availableStops, stopFilter } ->
            ChoosingStops { availableStops = availableStops, stopFilter = input }

        _ ->
            model


getStops : Cmd Msg
getStops =
    RuterAPI.getAllStopsInOslo
        |> Http.send StopsResponse


getDepartures : Stop -> Cmd Msg
getDepartures stop =
    RuterAPI.getDepartures stop
        |> Http.send DeparturesResponse


noCmd : Model -> ( Model, Cmd Msg )
noCmd model =
    ( model, Cmd.none )


andCmd : Cmd Msg -> Model -> ( Model, Cmd Msg )
andCmd cmd model =
    ( model, cmd )


crash : String -> Model -> Model
crash errorMessage model =
    Crashed { errorMessage = errorMessage }
