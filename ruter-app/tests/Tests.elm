module Tests exposing (..)

import Test exposing (..)
import Expect
import Time exposing (second, minute, hour)
import Utils


all : Test
all =
    describe "Elm workshop - Ruter"
        [ tests_Utils ]


tests_Utils : Test
tests_Utils =
    describe "formatTimedelta"
        ([ ( 10 * second, "00:00:10" )
         , ( 2 * hour + 3 * minute + 7 * second, "02:03:07" )
         , ( 6 * hour + 2 * minute, "06:02:00" )
         , ( 3 * hour + 17 * second, "03:00:17" )
         ]
            |> List.map
                (\( time, expectedFormatString ) ->
                    test (toString time ++ " is formatted as " ++ expectedFormatString) <|
                        \() ->
                            Expect.equal (Utils.formatTimedelta time) expectedFormatString
                )
        )
