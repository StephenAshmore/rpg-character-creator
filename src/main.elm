import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Array exposing (..)
import Random

-- MODEL

type alias Model =
    {
        step: Int,
        physicalStat : Int,
        mentalStat : Int,
        socialStat : Int,
        temporaryStats : List Int
    }

initialModel: Model
initialModel =
    {
        step = 1,
        physicalStat = 1,
        mentalStat = 1,
        socialStat = 1,
        temporaryStats = [0, 0, 0]
    }

init : (Model, Cmd Msg)
init  =
    ( initialModel, Cmd.none )

type Msg = Generate | GeneratedStats (List Int) | LockIn

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Generate ->
            ( { model | step = model.step + 1 },
            Random.generate GeneratedStats (Random.list 3 (Random.int 1 6))
            )
        GeneratedStats generatedStats ->
            ({ model | temporaryStats = generatedStats }, Cmd.none)
        LockIn ->
            ( { model | step = model.step + 1 },
                Cmd.none
            )

---- SUBSCRIPTIONS ----


subscriptions : Model -> Sub Msg
subscriptions model =
        Sub.none

-- STYLES
abilityScoreStyle : Attribute msg
abilityScoreStyle = 
    style
        [
            ("width", "60px")
            , ("height", "60px")
            , ("border-radius", "4px")
            -- , "position", "absolute"

            , ("display", "flex")
            , ("flex-flow", "column")
            , ("align-items", "center")
            , ("justify-content", "center")
            , ("margin", "10px")
        ]

dragStyle : Attribute msg
dragStyle =
    style
        [
            ("background-color", "blue")
            , ("opacity", "80%")
            , ("cursor", "move")

            , ("width", "60px")
            , ("height", "60px")
            , ("border-radius", "4px")
            -- , "position", "absolute"

            , ("color", "white")
            , ("display", "flex")
            , ("align-items", "center")
            , ("justify-content", "center")
            , ("margin", "10px")
        ]

-- VIEW

viewSelector : Model -> Html Msg
viewSelector model =
    if model.step == 1 then
        statsView model
    else if model.step == 2 then
        statsView2 model
    else
        statsView model


statsView : Model -> Html Msg
statsView model =
    div [] [
        h3 [] [ text "Ability Scores"],
        div [style [("display", "flex"), ("text-align", "center"), ("padding", "10px")]] [
            div [abilityScoreStyle] [
                text (toString model.physicalStat),
                h4 [] [text "Physical" ]
            ],
            div [abilityScoreStyle] [
                text (toString model.mentalStat),
                h4 [] [text "Mental" ]
            ],
            div [abilityScoreStyle] [
                text (toString model.socialStat),
                 h4 [] [text "Social" ]
            ]
        ],
        p [] [button [ onClick Generate ] [ text "Roll Ability Scores" ]]
    ]


statsView2 : Model -> Html Msg
statsView2 model =
    div [] [
        h3 [] [ text "Ability Scores"],
        div [style [("display", "flex"), ("text-align", "center"), ("padding", "10px")]] [
            div [abilityScoreStyle] [
                text (toString model.physicalStat),
                h4 [] [text "Physical" ]
            ],
            div [abilityScoreStyle] [
                text (toString model.mentalStat),
                h4 [] [text "Mental" ]
            ],
            div [abilityScoreStyle] [
                text (toString model.socialStat),
                 h4 [] [text "Social" ]
            ]
        ],
        div [style [("display", "flex"), ("text-align", "center"), ("padding", "10px")]] [
            div [dragStyle] [
                text (toString (Maybe.withDefault 1 (Array.get 0 (Array.fromList model.temporaryStats))))
            ],
            div [dragStyle] [
                text (toString (Maybe.withDefault 1 (Array.get 1 (Array.fromList model.temporaryStats))))
            ],
            div [dragStyle] [
                text (toString (Maybe.withDefault 1 (Array.get 2 (Array.fromList model.temporaryStats))))
            ]
        ],
        p [] [button [ onClick LockIn ] [ text "Lock in Ability Scores" ]]
    ]



view : Model -> Html Msg
view model =
    div [] [
        h1 [] [ text "Untitled RPG Character Creator"],
        viewSelector model
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