module State exposing (..)

import Http
import Types exposing (..)
import RuterAPI exposing (..)


update : Msg -> TopLevelType -> ( TopLevelType, Cmd Msg )
update msg topLevel =
    case topLevel of
        NormalState model ->
            case msg of
                StopsResponse result ->
                    case result of
                        Ok stops ->
                            model
                                |> updateStops stops
                                |> noCmd

                        Err error ->
                            "StopsResponse failed: "
                                ++ (toString error)
                                |> failed

        FailedState _ ->
            ( topLevel, Cmd.none )


updateStops : List Stop -> Model -> Model
updateStops stops model =
    { model | stops = stops }


getStops : Cmd Msg
getStops =
    RuterAPI.getStops
        |> Http.send StopsResponse


noCmd : Model -> ( TopLevelType, Cmd Msg )
noCmd topLevel =
    ( NormalState topLevel, Cmd.none )


failed : String -> ( TopLevelType, Cmd Msg )
failed errorMessage =
    ( FailedState errorMessage, Cmd.none )
