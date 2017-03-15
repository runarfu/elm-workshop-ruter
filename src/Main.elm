module Main exposing (..)

import Html
import State exposing (..)
import Types exposing (..)
import Views exposing (..)


main : Program Never TopLevelType Msg
main =
    Html.program
        { init = ( NormalState initModel, initCmd )
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


initModel : Model
initModel =
    { stops = []
    }


initCmd : Cmd Msg
initCmd =
    getStops


subscriptions : TopLevelType -> Sub Msg
subscriptions topLevel =
    Sub.none
