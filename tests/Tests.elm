module Tests exposing (..)

import Test exposing (..)
import Expect
import Time exposing (second, minute, hour)
import String
import Date
import Views
import RuterAPI


all : Test
all =
    describe "Elm workshop - Ruter"
        [ describe "formatTimedelta"
            ([ ( 10 * second, "00:00:10" )
             , ( 2 * hour + 3 * minute + 7 * second, "02:03:07" )
             , ( 6 * hour + 2 * minute, "06:02:00" )
             , ( 3 * hour + 17 * second, "03:00:17" )
             ]
                |> List.map
                    (\( time, expectedFormatString ) ->
                        test (toString time ++ " is formatted as " ++ expectedFormatString) <|
                            \() ->
                                Expect.equal (Views.formatTimedelta time) expectedFormatString
                    )
            )
        , describe "googleCalendarUrl"
            [ test "dates are formatted correctly" <|
                \() ->
                    Views.googleCalendarUrl departureMock
                        |> String.contains "dates=20170319T094100/20170319T094100"
                        |> Expect.true "URL contains same date twice"
            , test "text is URL encoded" <|
                \() ->
                    Views.googleCalendarUrl departureMock
                        |> String.contains "text=Ta%20linje%2017%20mot%20Rikshospitalet"
                        |> Expect.true "text is URL encoded"
            , test "the entire URL is correct" <|
                \() ->
                    Views.googleCalendarUrl departureMock
                        |> Expect.equal "https://calendar.google.com/calendar/render?action=TEMPLATE&text=Ta%20linje%2017%20mot%20Rikshospitalet&dates=20170319T094100/20170319T094100"
            ]
        ]


departureMock : RuterAPI.Departure
departureMock =
    let
        time =
            "2017-03-19T09:41:00+01:00"
                |> Date.fromString
                |> Result.withDefault (Date.fromTime 0)
    in
        { recordedAtTime = Date.fromTime 0
        , destinationName = "Rikshospitalet"
        , expectedArrivalTime = time
        , lineRef = "17"
        }
