module Views exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Simple.Fuzzy
import Types exposing (..)
import RuterAPI exposing (..)


view : Model -> Html Msg
view model =
    div [ style [ ( "width", "100%" ), ( "overflow", "hidden" ) ] ]
        [ h1 [] [ text "Sanntidsdata fra Ruter" ]
        , leftColumn model
        , rightColumn model
        ]


leftColumn : Model -> Html Msg
leftColumn model =
    div [ style [ ( "float", "left" ), ( "width", "50%" ) ] ]
        [ inputFilterBox
        , model.stops
            |> Simple.Fuzzy.filter .name model.nameFilter
            |> viewStops
        ]


rightColumn : Model -> Html Msg
rightColumn model =
    div [ style [ ( "float", "right" ), ( "width", "50%" ) ] ]
        [ viewChosenStop model.chosenStop
        , viewDepartures model.departures
        ]


viewChosenStop : Maybe Stop -> Html Msg
viewChosenStop maybeStop =
    case maybeStop of
        Just stop ->
            h2 [] [ text stop.name ]

        Nothing ->
            div [] []


viewDepartures : List Departure -> Html Msg
viewDepartures departures =
    let
        row departure =
            tr []
                [ td [] [ text departure.lineRef ]
                , td [] [ text departure.destinationName ]
                , td [] [ text (toString departure.expectedArrivalTime) ]
                ]
    in
        departures
            |> List.map row
            |> table []


inputFilterBox : Html Msg
inputFilterBox =
    input [ onInput FilterInput, autofocus True, placeholder "Filtrér" ] []


viewStops : List Stop -> Html Msg
viewStops stops =
    let
        row stop =
            div [ onClick (ChooseStop stop) ] [ text stop.name ]
    in
        stops
            |> List.sortBy .name
            |> List.map row
            |> div []
