module Views exposing (view)

import Html exposing (..)
import Html.Events exposing (..)
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

            ChosenStop { chosenStop, departures } ->
                viewDepartures chosenStop departures

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


viewDepartures : Stop -> List Departure -> Html Msg
viewDepartures stop departures =
    let
        row departure =
            [ departure.lineRef
            , departure.destinationName
            , departure.expectedArrivalTime |> toString
            ]
                |> List.map (\content -> td [] [ text content ])
                |> tr []
    in
        div []
            [ h2 [] [ text stop.name ]
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
