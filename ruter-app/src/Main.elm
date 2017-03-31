module Main exposing (..)

import Html
import State exposing (..)
import Types exposing (..)
import Views exposing (..)
import Exercises


main : Program Never Model Msg
main =
    Html.program
        { init =
            ( initModel, Cmd.none )
        , view =
            Exercises.withProgress view
            -- Vanligvis ville man brukt `view = view` over, men for å få med en
            -- progresjonsindikator (gamification under workshopen) legger vi på
            -- en ekstra view-funksjon som legger dette til på toppen av siden.
        , update = update
        , subscriptions = subscriptions
        }


initModel : Model
initModel =
    "Her er det noe tekst"


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
