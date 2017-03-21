module State exposing (..)

import Http
import Types exposing (..)
import RuterAPI exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        StopsResponse response ->
            response
                |> crashIfError
                |> updateStops model
                |> noCmd

        DeparturesResponse response ->
            response
                |> crashIfError
                |> updateDepartures model
                |> do (getDeparturesIfStopIsChosen model.chosenStop)

        FilterInput input ->
            model
                |> updateFilter input
                |> noCmd

        ChooseStop stop ->
            model
                |> updateChosenStop stop
                |> do (getDepartures stop)


updateStops : Model -> List Stop -> Model
updateStops model stops =
    { model | stops = stops }


updateDepartures : Model -> List Departure -> Model
updateDepartures model departures =
    { model | departures = departures }


updateFilter : String -> Model -> Model
updateFilter input model =
    { model | nameFilter = input }


updateChosenStop : Stop -> Model -> Model
updateChosenStop stop model =
    { model | chosenStop = Just stop }


getAllStopsInOslo : Cmd Msg
getAllStopsInOslo =
    RuterAPI.getAllStopsInOslo
        |> Http.send StopsResponse


getDeparturesIfStopIsChosen : Maybe Stop -> Cmd Msg
getDeparturesIfStopIsChosen maybeStop =
    case maybeStop of
        Just stop ->
            getDepartures stop

        Nothing ->
            Cmd.none


getDepartures : Stop -> Cmd Msg
getDepartures stop =
    RuterAPI.getDepartures stop
        |> Http.send DeparturesResponse


crashIfError : Result e v -> v
crashIfError result =
    case result of
        Ok value ->
            value

        Err error ->
            error
                |> toString
                |> Debug.crash


noCmd : Model -> ( Model, Cmd Msg )
noCmd model =
    ( model, Cmd.none )


do : Cmd Msg -> Model -> ( Model, Cmd Msg )
do cmd model =
    ( model, cmd )
