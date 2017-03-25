module Exercises exposing (ExerciseSet)

import Html exposing (..)
import Html.Attributes exposing (..)
import E00


type alias ExerciseSet =
    List ( String, String )


type alias Model =
    List ExerciseSet


main : Program Never Model a
main =
    Html.beginnerProgram
        { model = model
        , view = view
        , update = (\_ m -> m)
        }


model : Model
model =
    [ E00.exercises
    ]


viewExercises : Int -> List ( String, String ) -> Html a
viewExercises index exercises =
    let
        content ( number, description ) =
            tr []
                [ td [] [ input [ type_ "checkbox" ] [] ]
                , td [] [ text number ]
                , td [] [ text description ]
                ]
    in
        div []
            [ h2 [] [ text ("Oppgavesett " ++ (toString index)) ]
            , exercises
                |> List.map content
                |> table []
            ]


view : Model -> Html a
view model =
    let
        header =
            h1 [] [ text "Oppgaver" ]

        paragraphs =
            model
                |> List.indexedMap viewExercises
                |> div []
    in
        div [] [ header, paragraphs ]
