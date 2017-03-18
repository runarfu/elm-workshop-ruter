module Types exposing (..)

import RuterAPI exposing (..)
import Http


type alias Model =
    { filterInput : String
    , stops : List Stop
    , chosenStops : List Stop
    }


type Msg
    = FilterInput String
    | ChooseStop Stop
    | DiscardStop Stop
    | StopsResponse (Result Http.Error (List Stop))
