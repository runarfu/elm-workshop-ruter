module State exposing (..)

import Types exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        KunDenneGreiaHer ->
            ( model, Cmd.none )
