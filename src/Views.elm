module Views exposing (view)

import Html exposing (..)
import Types exposing (..)
import RuterAPI exposing (..)


view : TopLevelType -> Html Msg
view topLevelType =
    case topLevelType of
        NormalState model ->
            div []
                [ h1 [] [ text "Sanntidsdata fra Ruter" ]
                , viewStops model.stops
                ]

        FailedState errorMessage ->
            div []
                [ h1 [] [ text "Oh noes!" ]
                , p [] [ text errorMessage ]
                ]


viewStops : List Stop -> Html Msg
viewStops stops =
    let
        headersAndFunctions =
            [ ( "Navn", .name )
            , ( "Kortnavn", .shortName )
            , ( "ID", .iD >> toString )
            ]

        functions =
            headersAndFunctions
                |> List.map Tuple.second

        header txt =
            th [] [ text txt ]

        tableHeaders =
            headersAndFunctions
                |> List.map Tuple.first
                |> List.map header
                |> tr []
    in
        stops
            |> List.map (viewStop functions)
            |> List.append [ tableHeaders ]
            |> table []


viewStop : List (Stop -> String) -> Stop -> Html Msg
viewStop functions stop =
    let
        row function =
            td [] [ text (function stop) ]
    in
        functions
            |> List.map row
            |> tr []
