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
    }


type Msg
    = FilterInput String
    | StopsResponse (Result Http.Error (List Stop))
    | ChooseStop Stop
    | DeparturesResponse (Result Http.Error (List Departure))
    | UpdateNow Time
    | RefreshDepartures Time



-- TODO DeparturesResponse burde prefikses med stopp-id, slik at
-- responser som ikke matcher valgt stopp-id (gamle requester) kan forkastes
