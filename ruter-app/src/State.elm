module State exposing (..)

import Http
import Time exposing (Time)
import Date exposing (Date)
import Types exposing (..)
import RuterAPI exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        StopsResponse response ->
            response
                |> updateStops model
                |> noCmd

        DeparturesResponse response ->
            response
                |> updateDepartures model
                |> noCmd

        FilterInput input ->
            model
                |> updateFilter input
                |> noCmd

        ChooseStop stop ->
            model
                |> updateChosenStop stop
                |> discardCurrentDepartures
                |> do (getDepartures stop)

        UpdateNow time ->
            model
                |> updateNow time
                |> noCmd

        RefreshDepartures _ ->
            model
                |> do (getDeparturesIfStopIsChosen model.chosenStop)


updateStops : Model -> Result Http.Error (List Stop) -> Model
updateStops model result =
    case result of
        Ok stops ->
            { model | stops = stops }

        Err errorMessage ->
            { model | errorMessage = Just (toString errorMessage) }


updateDepartures : Model -> Result Http.Error (List Departure) -> Model
updateDepartures model result =
    case result of
        Ok departures ->
            { model | departures = departures }

        Err errorMessage ->
            { model | errorMessage = Just (toString errorMessage) }


updateFilter : String -> Model -> Model
updateFilter input model =
    { model | nameFilter = input }


discardCurrentDepartures : Model -> Model
discardCurrentDepartures model =
    { model | departures = [] }


updateChosenStop : Stop -> Model -> Model
updateChosenStop stop model =
    { model | chosenStop = Just stop }


updateNow : Time -> Model -> Model
updateNow time model =
    { model
        | now =
            time
                |> Date.fromTime
                |> Just
    }


getAllStopsInOslo : Cmd Msg
getAllStopsInOslo =
    RuterAPI.getAllStops
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
