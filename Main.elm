module Main exposing(..)

import Html
import Browser exposing (Document)

main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }

type alias Model =
    { year: Int
    , month: Int
    , day: Int
    , submitted: Bool
    }

type Msg
    = NoOps

init: () -> (Model, Cmd Msg)
init _ =
    ((Model 0 0 0 False), Cmd.none)


view: Model -> (Document Msg)
view model =
    { title = "life in weeks"
    , body = [ Html.text "life in weeks" ]
    }


update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        NoOps -> (model, Cmd.none)


-- Date utils

-- Number of days in the specific month
daysInMonth: Int -> Int -> Int
daysInMonth year month =
    case month of
        1 -> 31
        2 -> if isLeapYear(year) then 29 else 28
        3 -> 31
        4 -> 30
        5 -> 31
        6 -> 30
        7 -> 31
        8 -> 31
        9 -> 30
        10 -> 31
        11 -> 30
        12 -> 31
        _ -> 30

isLeapYear: Int -> Bool
isLeapYear year =
    modBy 400 year == 0 || modBy 100 year /= 0 && modBy 4 year == 0

-- Number of the day in the provided year
dayNumber: Int -> Int -> Int -> Int
dayNumber year month day =
    if month < 2 then
        day
    else
        let
            prevMonth = month - 1
            acc = (daysInMonth year prevMonth) + day
        in
            dayNumber year prevMonth acc

-- Number of the week in the provided date
weekNumber: Int -> Int -> Int -> Int
weekNumber year month day =
    ((dayNumber year month day) // 7) + 1

