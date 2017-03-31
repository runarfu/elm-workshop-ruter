module Utils exposing (..)

import Time exposing (Time)


formatTimedelta : Time -> String
formatTimedelta timeDelta =
    let
        hours =
            timeDelta
                |> Time.inHours
                |> floor

        afterHours =
            timeDelta - (toFloat hours * Time.hour)

        minutes =
            afterHours
                |> Time.inMinutes
                |> floor

        afterMinutes =
            afterHours - (toFloat minutes * Time.minute)

        seconds =
            afterMinutes
                |> Time.inSeconds
                |> floor
    in
        [ hours, minutes, seconds ]
            |> List.map toString
            |> List.map (String.padLeft 2 '0')
            |> String.join ":"
