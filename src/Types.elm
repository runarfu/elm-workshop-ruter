module Types exposing (..)

import Http
import RuterAPI exposing (..)


type alias Model =
    { nameFilter : String
    , stops : List Stop
    , chosenStop : Maybe Stop
    , departures : List Departure
    }


type Msg
    = FilterInput String
    | StopsResponse (Result Http.Error (List Stop))
    | ChooseStop Stop
    | DeparturesResponse (Result Http.Error (List Departure))



-- TODO DeparturesResponse burde prefikses med stopp-id, slik at
-- responser som ikke matcher valgt stopp-id (gamle requester) kan forkastes
