module Main exposing (..)

import Html
import State exposing (..)
import Types exposing (..)
import Views exposing (..)


main : Program Never Model Msg
main =
    Html.program
        { init = ( initModel, initCmd )
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


initModel : Model
initModel =
    { stops = [], filterInput = "", chosenStops = [] }


initCmd : Cmd Msg
initCmd =
    getStops


subscriptions : Model -> Sub Msg
subscriptions topLevel =
    Sub.none
