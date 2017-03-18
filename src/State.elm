module State exposing (..)

import Http
import Types exposing (..)
import RuterAPI exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FilterInput input ->
            { model | stopsAndFilters = updateFilterInput input model.stopsAndFilters }
                |> noCmd

        StopsResponse result ->
            case result of
                Ok stops ->
                    { model | stopsAndFilters = updateStops stops model.stopsAndFilters }
                        |> noCmd

                Err error ->
                    "StopsResponse failed: "
                        ++ (toString error)
                        |> Debug.crash


updateFilterInput : String -> StopsAndFilters -> StopsAndFilters
updateFilterInput input stopsAndFilters =
    { stopsAndFilters | filterInput = input }


updateStops : List Stop -> StopsAndFilters -> StopsAndFilters
updateStops stops stopsAndFilters =
    { stopsAndFilters | stops = stops }


getStops : Cmd Msg
getStops =
    RuterAPI.getStops
        |> Http.send StopsResponse


noCmd : Model -> ( Model, Cmd Msg )
noCmd model =
    ( model, Cmd.none )
