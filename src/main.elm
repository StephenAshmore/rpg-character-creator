import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Random

-- MODEL

type alias Model =
    {
        physicalStat : Int,
        mentalStat : Int,
        socialStat : Int,
        temporaryStats : List Int
    }

initialModel: Model
initialModel =
    {
        physicalStat = 1,
        mentalStat = 1,
        socialStat = 1,
        temporaryStats = [0, 0, 0]
    }

init : (Model, Cmd Msg)
init =
    ( initialModel, Cmd.none )

type Msg = Generate | GeneratedStats (List Int)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Generate ->
            ( model,
            Random.generate GeneratedStats (Random.list 3 (Random.int 1 6))
            )
        GeneratedStats generatedStats ->
            (Model model.physicalStat model.mentalStat model.socialStat generatedStats, Cmd.none)

---- SUBSCRIPTIONS ----


subscriptions : Model -> Sub Msg
subscriptions model =
        Sub.none

-- STYLES
abilityScoreStyle : Attribute msg
abilityScoreStyle = 
    style
        [
            ("margin", "10px")
        ]

-- VIEW

view : Model -> Html Msg
view model =
    div [] [
        h1 [] [ text "Untitled RPG Character Creator"],
        h3 [] [ text "Ability Scores"],
        div [style [("display", "flex"), ("text-align", "center"), ("padding", "10px")]] [
            div [abilityScoreStyle] [
                p [] [ text (toString model.physicalStat) ],
                p [] [ h4 [] [text "Physical" ] ]
            ],
            div [abilityScoreStyle] [
                p [] [ text (toString model.mentalStat) ],
                p [] [ h4 [] [text "Mental" ] ]
            ],
            div [abilityScoreStyle] [
                p [] [ text (toString model.socialStat) ],
                p [] [ h4 [] [text "Social" ] ]
            ]
        ],
        p [] [text (toString model.temporaryStats)],
        p [] [button [ onClick Generate ] [ text "Roll Ability Scores" ]]
    ]

    ---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }