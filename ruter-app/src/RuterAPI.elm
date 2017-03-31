module RuterAPI exposing (..)

import Json.Decode
import Json.Decode.Pipeline
import Http
import Date exposing (Date)


type alias Stop =
    { x : Int
    , y : Int
    , shortName : String
    , stopId : Int
    , name : String
    }


type alias Departure =
    { recordedAtTime : Date
    , destinationName : String
    , expectedArrivalTime : Date
    , lineRef : String
    , lineColour : String
    }


getAllStops : Http.Request (List Stop)
getAllStops =
    let
        url =
            "http://reisapi.ruter.no/place/getstopsruter"
    in
        Http.get url decodeStops


getAllStopsInOsloFromOfflineFile : Http.Request (List Stop)
getAllStopsInOsloFromOfflineFile =
    let
        url =
            "../offline_data/stops/oslo.json"
    in
        Http.get url decodeStops


getDepartures : Stop -> Http.Request (List Departure)
getDepartures stop =
    let
        url =
            "https://reisapi.ruter.no/stopvisit/getdepartures/"
                ++ toString stop.stopId
    in
        Http.get url decodeDepartures


getDeparturesInOsloFromOfflineFile : Stop -> Http.Request (List Departure)
getDeparturesInOsloFromOfflineFile stop =
    let
        url =
            "../offline_data/departures/"
                ++ toString stop.stopId
                ++ ".json"
    in
        Http.get url decodeDepartures


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
        |> Json.Decode.Pipeline.requiredAt [ "Extensions", "LineColour" ] Json.Decode.string
