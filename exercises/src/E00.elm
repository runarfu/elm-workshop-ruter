module E00 exposing (..)

import Html exposing (..)


-- Eksempelprogram med norske navn på *alt* som vi definerer selv - for å tydeliggjøre
-- at ofte brukte begreper som `Msg` og `Model` er konvensjoner, og trenger ikke
-- å bli fulgt.


exercises : List ( String, String )
exercises =
    [ ( "0.1", "Vis frem startverdien i datamodellen." )
    , ( "0.2", "Endre datamodellen når det skrives i input-feltet." )
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
