module Views exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import String
import Char
import Types exposing (..)
import RuterAPI exposing (..)


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Sanntidsdata fra Ruter" ]
        , viewStopsAndFilters model
        ]


viewStopsAndFilters : Model -> Html Msg
viewStopsAndFilters model =
    div []
        [ viewFilterInput
        , model.stops
            |> List.sortBy .name
            |> filterStops model.filterInput
            |> viewStops
        ]


viewFilterInput : Html Msg
viewFilterInput =
    input
        [ onInput FilterInput
        , autofocus True
        , placeholder "Filtrér"
        ]
        []


filterStops : String -> List Stop -> List Stop
filterStops filterText stops =
    let
        matches stop =
            String.contains (String.map Char.toLower filterText) (String.map Char.toLower stop.name)
    in
        stops
            |> List.filter matches


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
