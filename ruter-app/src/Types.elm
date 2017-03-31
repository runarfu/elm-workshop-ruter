module Types exposing (..)

import Http
import Date exposing (Date)
import Time exposing (Time)
import RuterAPI exposing (..)


type alias Model =
    { nameFilter : String
    , stops : List Stop
    , chosenStop : Maybe Stop
    , departures : List Departure
    , now : Maybe Date
    , errorMessage : Maybe String
    }


type Msg
    = FilterInput String
    | StopsResponse (Result Http.Error (List Stop))
    | ChooseStop Stop
    | DeparturesResponse (Result Http.Error (List Departure))
    | UpdateNow Time
    | RefreshDepartures Time
