module Exercises exposing (withProgress)

import Html exposing (..)
import Html.Attributes exposing (..)
import Types exposing (..)


{- README
   Denne filen inneholder oppgavene i workshopen.
   Det eneste du skal gjøre i denne filen er å tikke boksene etterhvert
   som du løser oppgavene. Det gjør du ved å endre `[ ]` til `[x]`.
   Dette gjør at progresjonsindikatoren i toppen av appen din viser hvor langt
   du har kommet.
-}


exercises : List String
exercises =
    [ """ [ ] Installér Elm og kjør `elm reactor` i `ruter-app`-katalogen.
              Start opp siden i en nettleser og se at den kjører.
      """
    , """ [ ] Vis frem innholdet i modellen.
      """
    , """ [ ] Legg til et input-felt. Dette skal senere brukes til å filtrere
              en liste over stoppested, for å raskt kunne finne frem til ønsket
              stopp uten å måtte scrolle gjennom en veldig lang liste.
      """
    , """ [ ] Utvid modellen til å kunne holde på verdien i input-feltet,
              og sørg for at modellen blir oppdatert når man taster inn i feltet.
      """
    , """ [ ] Lag en `Cmd` som henter data fra en nettside,
              f.eks. https://httpbin.org/get.
              Send denne kommandoen til Elm, og putt responsen i modellen.
      """
    , """ [ ] Endre kommandoen du lagde til å hente fra
              http://reisapi.ruter.no/place/getstopsruter istedet.
              Hvis du vil teste med en mindre mengde data (eller det er nettverkskrøll),
              kan du gå mot ../offline_data/stops/stops.json istedet. Så lenge
              du bruker `elm-reactor` blir alle slike filer under katalogen du
              stod i da du startet `elm-reactor` tilgjengelige over HTTP.
      """
    , """ [ ] Lag en record-type for stopp-informasjon. Stopp-informasjonen har
              mange felt, og det anbefales å velge ut noen få av dem i starten
              som virker interessante, og eventuelt legge til flere etter hvert.
              JSON-parsing i Elm ignorerer ekstra felt, så det er enkelt å ta
              små steg.
      """
    , """ [ ] Lag en JSON-parser som parser stopp-informasjon og bruker
              record-typen fra forrige oppgave.
      """
    , """ [ ] Hent inn stopp ved oppstart av applikasjonen, og vis frem informasjon om stoppene.
      """
    , """ [ ] Filtrér stopplisten. Velg det du selv synes er fornuftig
              med sensitive/insensitive casing, start/slutt av navn, eller kanskje
              også en fuzzy-matcher?
      """
    , """ [ ] Utvid modelltypen til å holde på et valgt stopp.
              Legg til en knapp på hver stoppested-rad hvor man kan velge
              stoppet.
      """
    , """ [ ] Lag en record-type for departures-informasjon.
      """
    , """ [ ] Lag en JSON-parser som parser departures-informasjon og bruker
              record-typen fra forrige oppgave.
      """
    , """ [ ] Hent inn neste avganger for valgt stopp (etter at et stopp er valgt).
              Hvis du bruker den lokale lista over stoppesteder, finnes det korresponderende
              filer for departures-informasjon under offline_data/departures.
              Merk at her vil tidspunktene bli helt feil.
      """
    , """ [ ] Vis frem avgangene når de er lastet inn.
      """
    , """ [ ] Finn en måte å vise hvor lang tid det er igjen til de ulike avgangene.
              Dette kan f.eks. gjøres ved å sørge for at modellen har et feltet
              for nåværende tidspunkt, og så kan dette sammenliknes med avgangstidene.
      """
    , """ [ ] Oppdater departures for valgt stopp med jevne mellomrom, ikke bare
              etter at et stopp er valgt.
      """
    , """ [ ] Få ting til å se pent ut (hvis du ikke allerede har gjort det).
              OBS: `elm-reactor` støtter ikke css-filer. Det finnes hovedsaklig 2 løsninger:
              - Skrive stylingen i Elm-koden (se http://package.elm-lang.org/packages/elm-lang/html/2.0.0/Html-Attributes#style)
              - Bruke https://github.com/tomekwi/elm-live
      """
    ]



-- Du kan ignorere all koden under denne linja, eller se på den og kanskje lære noe :-)


withProgress : (Model -> Html Msg) -> Model -> Html Msg
withProgress viewFunction model =
    div []
        [ exercises
            |> List.map parseExercise
            |> viewProgress
        , viewFunction model
        ]


type alias Exercise =
    { isCompleted : Bool
    , description : String
    }


parseExercise : String -> Exercise
parseExercise string =
    let
        prefix =
            string
                |> String.trim
                |> String.left 4
                |> String.trim

        suffix =
            string
                |> String.trim
                |> String.dropLeft 4
                |> String.trim
    in
        { isCompleted = prefix == "[x]"
        , description = suffix
        }


viewProgress : List Exercise -> Html Msg
viewProgress exercises =
    let
        totalExercises =
            exercises
                |> List.length

        completedExercises =
            exercises
                |> List.filter .isCompleted
                |> List.length

        txt =
            (toString completedExercises)
                ++ "/"
                ++ (toString totalExercises)

        mouseOver =
            txt
                ++ " oppgaver er løst!"
    in
        p [ style [ ( "text-align", "center" ) ] ]
            [ progress
                [ value (toString completedExercises)
                , Html.Attributes.max (toString totalExercises)
                , title mouseOver
                ]
                []
            , span [ style [ ( "margin-left", "1em" ) ] ] [ text txt ]
            ]
