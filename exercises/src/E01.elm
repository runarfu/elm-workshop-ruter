module E01 exposing (..)

import Html exposing (..)
import Http


-- README
-- Her bruker vi `Html.program` istedet for `Html.beginnerProgram`.
-- Denne modellen åpner for `Commands` og `Subscriptions`.
-- De norske navnene er erstattet med konvensjonelle navn.


exercises : List String
exercises =
    [ """
    TODO 1.0 Lag en `Cmd` som henter data fra en nettside,
    f.eks. https://httpbin.org/get. Send denne kommandoen til Elm, og putt
    responsen i modellen.
      """
    , """
    TODO 1.1 Endre kommandoen du lagde til å hente fra ../offline_data/stops/stops.json
    istedet.
      """
    ]


type alias Model =
    String


getSomething : Cmd Msg
getSomething =
    let
        request =
            Http.getString "https://httpbin.org/get"
    in
        Http.send HttpBinGetResponse request


type Msg
    = HttpBinGetResponse (Result Http.Error String)


main : Program Never Model Msg
main =
    Html.program
        { init = ( initialModel, getSomething )
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


initialModel : Model
initialModel =
    "Dette er startverdien for datamodellen vår"


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        HttpBinGetResponse result ->
            case result of
                Ok value ->
                    ( value, Cmd.none )

                Err error ->
                    ( "Error! " ++ (toString error), Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Andre oppgave" ]
        , p [] [ text model ]
        ]
