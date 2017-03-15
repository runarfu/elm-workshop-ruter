module Types exposing (..)

import RuterAPI exposing (..)
import Http


type TopLevelType
    = NormalState Model
    | FailedState String


type alias Model =
    { filterInput : String
    , stops : List Stop
    }


type Msg
    = FilterInput String
    | StopsResponse (Result Http.Error (List Stop))
