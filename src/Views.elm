module Views exposing (..)

import Date exposing (Date)
import Time exposing (inMinutes)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Simple.Fuzzy
import Types exposing (..)
import RuterAPI exposing (..)


view : Model -> Html Msg
view model =
    div [ style [ ( "width", "100%" ), ( "overflow", "hidden" ) ] ]
        [ header model
        , leftColumn model
        , rightColumn model
        ]


header : Model -> Html Msg
header model =
    let
        time =
            model.now
                |> Maybe.map toString
                |> Maybe.map ((++) " ")
                |> Maybe.withDefault ""
    in
        h1 [] [ text ("Sanntidsdata fra Ruter" ++ time) ]


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
        , viewDepartures model
        ]


viewChosenStop : Maybe Stop -> Html Msg
viewChosenStop maybeStop =
    case maybeStop of
        Just stop ->
            h2 [] [ text stop.name ]

        Nothing ->
            div [] []


timeDeltaInMinutes : Maybe Date -> Date -> String
timeDeltaInMinutes maybeNow arrivalTime =
    case maybeNow of
        Just now ->
            let
                time1 =
                    Date.toTime now

                time2 =
                    Date.toTime arrivalTime

                timeDelta =
                    time2 - time1
            in
                timeDelta
                    |> inMinutes
                    |> ceiling
                    |> toString

        Nothing ->
            "N/A"


viewDepartures : Model -> Html Msg
viewDepartures model =
    let
        row departure =
            tr []
                [ td [] [ text departure.lineRef ]
                , td [] [ text departure.destinationName ]
                , td [] [ text (timeDeltaInMinutes model.now departure.expectedArrivalTime) ]
                , td [] [ text (toString departure.expectedArrivalTime) ]
                ]
    in
        model.departures
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
