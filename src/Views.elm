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


formatTimedelta : Maybe Date -> Date -> String
formatTimedelta maybeNow arrivalTime =
    case maybeNow of
        Just now ->
            let
                timeDelta =
                    Date.toTime arrivalTime - Date.toTime now

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

        Nothing ->
            "N/A"


colourBox : String -> Html Msg
colourBox colour =
    div
        [ style
            [ ( "float", "left" )
            , ( "width", "20px" )
            , ( "height", "20px" )
            , ( "margin", "5px" )
            , ( "border", "1 px solid rgba(0, 0, 0, .2)" )
            , ( "background", "#" ++ colour )
            ]
        ]
        []


viewDepartures : Model -> Html Msg
viewDepartures model =
    let
        headers =
            if List.length model.departures > 1 then
                tr []
                    [ th [] [ text "" ]
                    , th [] [ text "Linje" ]
                    , th [] [ text "Destinasjon" ]
                    , th [] [ text "" ]
                    , th [] [ text "Avgang" ]
                    ]
            else
                tr [] []

        row departure =
            tr []
                [ td [] [ colourBox departure.lineColour ]
                , td [] [ text departure.lineRef ]
                , td [] [ text departure.destinationName ]
                , td [] [ text (formatTimedelta model.now departure.expectedArrivalTime) ]
                , td [] [ text (toString departure.expectedArrivalTime) ]
                ]
    in
        model.departures
            |> List.map row
            |> List.append [ headers ]
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
