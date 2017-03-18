module Types exposing (..)

import RuterAPI exposing (..)
import Http
import Time exposing (Time)


type Model
    = Initialized
    | ChoosingStops { availableStops : List Stop }
    | ChosenStop { chosenStop : Stop, departures : List Departure }
    | Crashed { errorMessage : String }


type alias HttpResponse a =
    Result Http.Error a


type Msg
    = ChooseStop Stop
    | StopsResponse (HttpResponse (List Stop))
    | DeparturesResponse (HttpResponse (List Departure))
    | Tick Time
