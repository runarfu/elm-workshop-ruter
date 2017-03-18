module RuterAPI exposing (..)

import Json.Decode
import Json.Decode.Pipeline
import Http


getClosestStops : Int -> Http.Request (List Stop)
getClosestStops proposals =
    let
        x =
            597152

        y =
            6643471

        url =
            "http://127.0.0.1:5000/"
                ++ "http://reisapi.ruter.no/place/getcloseststops?coordinates="
                ++ "(x="
                ++ toString x
                ++ ",y="
                ++ toString y
                ++ ")&proposals="
                ++ (toString proposals)
    in
        Http.get url decodeStops


type alias Stop =
    { x : Int
    , y : Int
    , zone : String
    , shortName : String
    , isHub : Bool
    , iD : Int
    , name : String
    , district : String
    , placeType : String
    }


decodeStops : Json.Decode.Decoder (List Stop)
decodeStops =
    Json.Decode.list decodeStop


decodeStop : Json.Decode.Decoder Stop
decodeStop =
    Json.Decode.Pipeline.decode Stop
        |> Json.Decode.Pipeline.required "X" (Json.Decode.int)
        |> Json.Decode.Pipeline.required "Y" (Json.Decode.int)
        |> Json.Decode.Pipeline.required "Zone" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "ShortName" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "IsHub" (Json.Decode.bool)
        |> Json.Decode.Pipeline.required "ID" (Json.Decode.int)
        |> Json.Decode.Pipeline.required "Name" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "District" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "PlaceType" (Json.Decode.string)
