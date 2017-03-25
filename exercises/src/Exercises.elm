module Exercises exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import String
import E00
import E01


model : Model
model =
    [ E00.exercises
    , E01.exercises
    ]
        |> List.concat
        |> List.map parseExercise


type alias Model =
    List Exercise


type alias Exercise =
    { isCompleted : Bool
    , description : String
    }


main : Program Never Model a
main =
    Html.beginnerProgram
        { model = model
        , view = view
        , update = (\_ m -> m)
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
        { isCompleted = prefix /= "TODO"
        , description = suffix
        }


viewExercises : List Exercise -> Html a
viewExercises exercises =
    let
        row exercise =
            tr []
                [ td []
                    [ input
                        [ type_ "checkbox"
                        , checked exercise.isCompleted
                        , disabled True
                        ]
                        []
                    ]
                , td [] [ text exercise.description ]
                ]
    in
        exercises
            |> List.map row
            |> table []


viewCounts : Model -> Html a
viewCounts model =
    let
        totalExercises =
            List.length model

        finished =
            model
                |> List.filter .isCompleted
                |> List.length
    in
        toString finished
            ++ "/"
            ++ toString totalExercises
            |> text


view : Model -> Html a
view model =
    let
        header =
            h1 [] [ text "Oppgaver" ]

        counts =
            h2 [] [ viewCounts model ]

        paragraphs =
            viewExercises model
    in
        div [] [ header, counts, paragraphs ]
