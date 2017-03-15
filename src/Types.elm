module Types exposing (..)

import RuterAPI exposing (..)
import Http


type TopLevelType
    = NormalState Model
    | FailedState String


type alias Model =
    { stops : List Stop
    }


type Msg
    = StopsResponse (Result Http.Error (List Stop))
