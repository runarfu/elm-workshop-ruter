module RuterAPI exposing (..)

import Json.Decode
import Json.Decode.Pipeline
import Http


getStops : Http.Request (List Stop)
getStops =
    let
        url =
            "../static_data/alle_stopp_i_oslo.json"
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
