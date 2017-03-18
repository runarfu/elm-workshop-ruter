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


getStops : Cmd Msg
getStops =
    RuterAPI.getStops
        |> Http.send StopsResponse


noCmd : Model -> ( Model, Cmd Msg )
noCmd model =
    ( model, Cmd.none )
