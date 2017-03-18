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
        , viewChosenStops model
        , viewStopsAndFilters model
        ]


viewChosenStops : Model -> Html Msg
viewChosenStops model =
    let
        row stop =
            div []
                [ button [ onClick (DiscardStop stop) ] [ text "-" ]
                , span [] [ text stop.name ]
                ]
    in
        model.chosenStops
            |> List.sortBy .name
            |> List.map row
            |> p []


viewStopsAndFilters : Model -> Html Msg
viewStopsAndFilters model =
    [ viewFilterInput
    , model.stops
        |> List.sortBy .name
        |> filterStops model.filterInput
        |> viewStops
    ]
        |> p []


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
    stops
        |> List.map stopRow
        |> table []


stopRow : Stop -> Html Msg
stopRow stop =
    [ button [ onClick (ChooseStop stop) ] [ text "+" ]
    , text stop.name
    , text stop.shortName
    , text (toString stop.iD)
    ]
        |> List.map (\content -> td [] [ content ])
        |> tr []
