module Types exposing (..)

import RuterAPI exposing (..)
import Http
import Time exposing (Time)


type Model
    = Initialized
    | ChoosingStops { availableStops : List Stop }
    | ChosenStop { chosenStop : Stop, departures : List Departure }
    | Crashed { errorMessage : String }


type Msg
    = FilterInput String
    | ChooseStop Stop
    | StopsResponse (Result Http.Error (List Stop))
    | DeparturesResponse (Result Http.Error (List Departure))
    | Tick Time
