module Views exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import String
import Char
import Types exposing (..)
import RuterAPI exposing (..)


view : TopLevelType -> Html Msg
view topLevelType =
    case topLevelType of
        NormalState model ->
            div []
                [ h1 [] [ text "Sanntidsdata fra Ruter" ]
                , viewFilterInput model
                , model.stops
                    |> filterStops model.filterInput
                    |> viewStops
                ]

        FailedState errorMessage ->
            div []
                [ h1 [] [ text "Oh noes!" ]
                , p [] [ text errorMessage ]
                ]


viewFilterInput : Model -> Html Msg
viewFilterInput model =
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
