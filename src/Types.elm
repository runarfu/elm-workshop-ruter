module Types exposing (..)

import RuterAPI exposing (..)
import Http
import Time exposing (Time)
import Date exposing (Date)


type Model
    = Initialized
    | ChoosingStops { stopFilter : String, availableStops : List Stop }
    | ChosenStop { chosenStop : Stop, departures : List Departure, now : Maybe Date }
    | Crashed { errorMessage : String }


type alias HttpResponse a =
    Result Http.Error a


type Msg
    = StopFilterInput String
    | ChooseStop Stop
    | StopsResponse (HttpResponse (List Stop))
    | DeparturesResponse (HttpResponse (List Departure))
    | Tick Time
