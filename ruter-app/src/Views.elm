module Views exposing (..)

import Html exposing (..)
import Types exposing (..)


view : Model -> Html Msg
view model =
    h1 [] [ text "Elm workshop" ]
