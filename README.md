# elm-workshop-ruter
Elm-workshop. Henter og presenterer sanntidsdata fra Ruter sitt API.

## Relevant dokumentasjon
* Installasjon av Elm og tips til IDE-oppsett: https://guide.elm-lang.org/install.html (jeg anbefaler Atom med Elm-plugins)
* Introduksjon av Elm: https://guide.elm-lang.org/
* Ruter-API: http://reisapi.ruter.no/help

## Hvordan jobbe med workshopen
For å komme i gang med workshopen, gjør følgende trinn:
* Installér Elm og eventuell IDE (med Elm-plugins).
* Klon dette repoet.
* Start opp `elm-reactor` i `ruter-app`-katalogen. Du kan da åpne http://localhost:8000 i nettleseren.
* Navigér til http://localhost:8000/src/Main.elm i nettleseren. Dette kompilerer `Main.elm` og alle dens avhengigheter,
og viser deg den resulterende Elm-appen. Etter kodeendringer trenger du bare å refreshe siden i nettleseren for å kompilere koden på ny.
* I `src/Exercises.elm` finner du en liste med oppgaver. Utfør disse i rekkefølge (eller som du ønsker). Hvis du krysser av boksene etterhvert som du løser oppgaver  (ved å endre `[ ]` til `[x]`) får du en progresjonsindikator i toppen av Elm-appen.

## Tester
Det finnes et minimalt sett med enhetstester under `ruter-app/tests`. Disse kan kjøres ved å kjøre `elm-test` i `ruter-app`-katalogen. Disse kan du kjøre om du vil, og eventuelt legge til egne tester.

## Ruter-API
Ruter-APIet har mange endepunkt (se http://reisapi.ruter.no/help) men det er i workshopen lagt opp til å bruke disse to:
* http://reisapi.ruter.no/place/getstopsruter for stoppesteder
* http://reisapi.ruter.no/stopvisit/getdepartures/{stopp-id} - f.eks. http://reisapi.ruter.no/stopvisit/getdepartures/3011440

## Parsing av JSON i Elm
Parsing av JSON kan være litt kronglete, men når du først har gjort det noen ganger er det ganske greit.
Følgende lenker kan være nyttige:
* Guide: https://guide.elm-lang.org/interop/json.html
* Standardmodulen for JSON-dekoding: http://package.elm-lang.org/packages/elm-lang/core/5.1.1/Json-Decode
* Alternativ modul for å dekode JSON (foretrukket av mange): http://package.elm-lang.org/packages/NoRedInk/elm-decode-pipeline/latest 
* Verktøy for å generere JSON-dekodere (og -enkodere) fra eksempel-JSON: http://noredink.github.io/json-to-elm/

## Ekstra tips
* Test kode og del med andre, direkte i nettleseren: https://runelm.io/
