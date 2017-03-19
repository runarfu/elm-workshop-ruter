module Views exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Time exposing (Time)
import Date exposing (Date)
import Strftime
import Types exposing (..)
import RuterAPI exposing (..)


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Sanntidsdata fra Ruter" ]
        , case model of
            Initialized ->
                initialized

            ChoosingStops { availableStops } ->
                viewStops availableStops

            ChosenStop { chosenStop, departures, now } ->
                viewDepartures chosenStop departures now

            Crashed { errorMessage } ->
                viewCrashReport errorMessage
        ]


initialized : Html Msg
initialized =
    div [] [ text "" ]


viewStops : List Stop -> Html Msg
viewStops availableStops =
    let
        row stop =
            div [] [ button [ onClick (ChooseStop stop) ] [ text stop.name ] ]
    in
        availableStops
            |> List.map row
            |> div []


googleCalendarUrl : Departure -> String
googleCalendarUrl departure =
    let
        txt =
            "Ta linje " ++ departure.lineRef ++ " mot " ++ departure.destinationName

        timeString =
            departure.expectedArrivalTime
                |> Strftime.format "%Y%m%dT%H%M%S"
    in
        "https://calendar.google.com/calendar/render?action=TEMPLATE"
            ++ "&text="
            ++ Http.encodeUri txt
            ++ "&dates="
            ++ timeString
            ++ "/"
            ++ timeString


viewDateDifference : Date.Date -> Date.Date -> String
viewDateDifference date1 date2 =
    let
        timeDelta =
            Date.toTime date1
                - Date.toTime date2
    in
        if timeDelta > 0 then
            formatTimedelta timeDelta
        else
            "- " ++ formatTimedelta ((-1) * timeDelta)


formatTimedelta : Time.Time -> String
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


viewDepartures : Stop -> List Departure -> Maybe Date -> Html Msg
viewDepartures stop departures date =
    let
        calendarLink departure =
            a [ googleCalendarUrl departure |> href, target "_blank" ] [ text "📅" ]

        now =
            date
                |> Maybe.withDefault (Date.fromTime 0)

        row departure =
            [ departure.lineRef
            , departure.destinationName
            , viewDateDifference departure.expectedArrivalTime now
            , departure.expectedArrivalTime |> toString
            ]
                |> List.map (\content -> td [] [ text content ])
                |> List.append [ calendarLink departure ]
                |> tr []
    in
        div []
            [ h2 [] [ text stop.name ]
            , p [] [ text (toString now) ]
            , departures
                |> List.map row
                |> table []
            ]


viewCrashReport : String -> Html Msg
viewCrashReport errorMessage =
    div []
        [ h2 [] [ text "Oh noes!" ]
        , p [] [ text errorMessage ]
        ]
