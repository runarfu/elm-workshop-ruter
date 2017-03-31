module E00 exposing (..)

import Html exposing (..)


-- README
-- Eksempelprogram med norske navn på *alt* som vi definerer selv - for å tydeliggjøre
-- at ofte brukte begreper som `Msg` og `Model` er konvensjoner, og trenger ikke
-- å bli fulgt.


exercises : List String
exercises =
    [ "TODO 0.0 Vis frem startverdien i datamodellen."
    , "TODO 0.1 Endre datamodellen når det skrives i input-feltet."
    , "TODO 0.2 Legg til en knapp som blanker ut datamodellen."
    ]


type alias DataModellenVaar =
    String


type Meldingstype
    = KunEnVerdiForeloepig


main : Program Never DataModellenVaar Meldingstype
main =
    Html.beginnerProgram
        { model = initiellDatamodell
        , view = visningsfunksjon
        , update = oppdateringsfunksjon
        }


initiellDatamodell : DataModellenVaar
initiellDatamodell =
    "Dette er startverdien for datamodellen vår"


oppdateringsfunksjon : Meldingstype -> DataModellenVaar -> DataModellenVaar
oppdateringsfunksjon meldingstype datamodell =
    case meldingstype of
        KunEnVerdiForeloepig ->
            datamodell


visningsfunksjon : DataModellenVaar -> Html Meldingstype
visningsfunksjon datamodell =
    h1 [] [ text "Første oppgave" ]