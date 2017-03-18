module Main exposing (..)

import Html
import Time exposing (Time)
import State exposing (..)
import Types exposing (..)
import Views exposing (..)


main : Program Never Model Msg
main =
    Html.program
        { init = ( Initialized, getStops )
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


initCmd : Cmd Msg
initCmd =
    getStops


subscriptions : Model -> Sub Msg
subscriptions topLevel =
    Time.every (1 * Time.second) Tick
