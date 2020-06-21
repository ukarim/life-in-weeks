module Date exposing (Date , parse, dateOf, toString)

import Array
import Regex exposing (Regex)


type alias Date =
    { year: Int
    , month: Int
    , day: Int
    , week: Int
    }


dateOf: Int -> Int -> Int -> Date
dateOf year month day =
    let
        week = weekNumber year month day
    in
        (Date year month day week)


toString: Date -> String
toString date =
    let
        year = String.fromInt date.year
        month = monthName date.month
        day = String.fromInt date.day
    in
        month ++ " " ++ day ++ " " ++ year


dateRegex: Regex
dateRegex =
    Maybe.withDefault Regex.never <|
        Regex.fromString "^([12]\\d{3}-(0[1-9]|1[0-2])-(0[1-9]|[12]\\d|3[01]))$"


parse: String -> Result String Date
parse input =
    if (Regex.contains dateRegex input) then
        let
            parts = String.split "-" input
                    |> List.map String.toInt
                    |> Array.fromList

            date = applyOnDate (\d i -> { d | year = i }) (Array.get 0 parts) (Ok (Date 0 0 0 0))
                    |> applyOnDate (\d i -> { d | month = i }) (Array.get 1 parts)
                    |> applyOnDate (\d i -> { d | day = i }) (Array.get 2 parts)
                    |> setWeek
        in
            date
    else
        Err "Invalid date format. Need [yyyy-mm-dd]"


setWeek: Result String Date -> Result String Date
setWeek maybeDate =
    case maybeDate of
        Ok date ->
            let
                week = weekNumber date.year date.month date.day
            in
                Ok { date | week = week }
        Err err ->
            Err err


applyOnDate: (Date -> Int -> Date) -> (Maybe (Maybe Int)) -> Result String Date -> Result String Date
applyOnDate fun value maybeDate =
    case maybeDate of
        Ok date ->
            case value of
                Just maybeInt ->
                    case maybeInt of
                        Just int -> 
                            Ok (fun date int)
                        Nothing ->
                            Err "invalid date part"
                Nothing ->
                    Err "invalid date part"
        Err err ->
            Err err


monthName: Int -> String
monthName month =
    case month of
        1 -> "Jan"
        2 -> "Feb"
        3 -> "Mar"
        4 -> "Apr"
        5 -> "May"
        6 -> "Jun"
        7 -> "Jul"
        8 -> "Aug"
        9 -> "Sep"
        10 -> "Oct"
        11 -> "Nov"
        12 -> "Dec"
        _ -> "Unknown"


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


weekNumber: Int -> Int -> Int -> Int
weekNumber year month day =
    ((dayNumber year month day) // 7) + 1

