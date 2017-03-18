module State exposing (..)

import Http
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

                _ ->
                    noCmd model

        ChoosingStops { availableStops } ->
            case msg of
                ChooseStop stop ->
                    ChosenStop { chosenStop = stop, departures = [] }
                        |> andCmd (getDepartures stop)

                _ ->
                    noCmd model

        ChosenStop { chosenStop, departures } ->
            case msg of
                DeparturesResponse result ->
                    model
                        |> updateWithResultOrCrash result (updateDepartures chosenStop)

                _ ->
                    noCmd model

        Crashed _ ->
            noCmd model


updateWithResultOrCrash : Result Http.Error a -> (a -> Model -> Model) -> Model -> ( Model, Cmd Msg )
updateWithResultOrCrash result function model =
    case result of
        Ok value ->
            model
                |> function value
                |> noCmd

        Err error ->
            model
                |> crash (toString error)


updateStops : List Stop -> Model -> Model
updateStops stops model =
    ChoosingStops { availableStops = stops }


updateDepartures : Stop -> List Departure -> Model -> Model
updateDepartures stop departures model =
    ChosenStop { chosenStop = stop, departures = departures }


getStops : Cmd Msg
getStops =
    RuterAPI.getClosestStops 10
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


crash : String -> Model -> ( Model, Cmd Msg )
crash errorMessage model =
    ( Crashed { errorMessage = errorMessage }, Cmd.none )
