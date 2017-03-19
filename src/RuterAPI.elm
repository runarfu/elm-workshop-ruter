module RuterAPI exposing (..)

import Json.Decode
import Json.Decode.Pipeline
import Http
import Date exposing (Date)


getAllStopsInOslo : Http.Request (List Stop)
getAllStopsInOslo =
    let
        url =
            "../static_data/alle_stopp_i_oslo.json"
    in
        Http.get url decodeStops


getClosestStops : Int -> Http.Request (List Stop)
getClosestStops proposals =
    let
        sundtKvartalet =
            closestStopsURL 598571 6643551

        url =
            sundtKvartalet proposals
    in
        Http.get url decodeStops


closestStopsURL : Int -> Int -> Int -> String
closestStopsURL x y proposals =
    "https://reisapi.ruter.no/place/getcloseststops?coordinates="
        ++ "(x="
        ++ toString x
        ++ ",y="
        ++ toString y
        ++ ")&proposals="
        ++ (toString proposals)


getDepartures : Stop -> Http.Request (List Departure)
getDepartures stop =
    let
        url =
            "https://reisapi.ruter.no/stopvisit/getdepartures/"
                ++ toString stop.iD
    in
        Http.get url decodeDepartures


type alias Stop =
    { x : Int
    , y : Int
    , shortName : String
    , iD : Int
    , name : String
    }


decodeStops : Json.Decode.Decoder (List Stop)
decodeStops =
    Json.Decode.list decodeStop


decodeStop : Json.Decode.Decoder Stop
decodeStop =
    Json.Decode.Pipeline.decode Stop
        |> Json.Decode.Pipeline.required "X" (Json.Decode.int)
        |> Json.Decode.Pipeline.required "Y" (Json.Decode.int)
        |> Json.Decode.Pipeline.required "ShortName" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "ID" (Json.Decode.int)
        |> Json.Decode.Pipeline.required "Name" (Json.Decode.string)


type alias Departure =
    { recordedAtTime : Date
    , destinationName : String
    , expectedArrivalTime : Date
    , lineRef : String
    }


date : Json.Decode.Decoder Date
date =
    let
        convert : String -> Json.Decode.Decoder Date
        convert raw =
            case Date.fromString raw of
                Ok date ->
                    Json.Decode.succeed date

                Err error ->
                    Json.Decode.fail error
    in
        Json.Decode.string |> Json.Decode.andThen convert


decodeDepartures : Json.Decode.Decoder (List Departure)
decodeDepartures =
    Json.Decode.list decodeDeparture


decodeDeparture : Json.Decode.Decoder Departure
decodeDeparture =
    Json.Decode.Pipeline.decode Departure
        |> Json.Decode.Pipeline.required "RecordedAtTime" date
        |> Json.Decode.Pipeline.requiredAt [ "MonitoredVehicleJourney", "DestinationName" ] Json.Decode.string
        |> Json.Decode.Pipeline.requiredAt [ "MonitoredVehicleJourney", "MonitoredCall", "ExpectedArrivalTime" ] date
        |> Json.Decode.Pipeline.requiredAt [ "MonitoredVehicleJourney", "LineRef" ] Json.Decode.string
