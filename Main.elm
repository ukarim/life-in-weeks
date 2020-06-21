port module Main exposing(..)

import Html exposing (Html)
import Html.Attributes as Attr
import Html.Events as Event
import Browser exposing (Document)

import Date exposing (Date)
import Debug


type alias Model =
    { now: Date
    , birthDate: Maybe Date
    , inputString: String
    , errorMessage: Maybe String
    }


type Msg
    = InputChanged String
    | DateSubmitted String


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }


type alias Flags =
    { currYear: Int
    , currMonth: Int
    , currDay: Int
    , birthDate: Maybe String
    }


init: Flags -> (Model, Cmd Msg)
init flags =
    let
        now = Date.dateOf flags.currYear flags.currMonth flags.currDay
        birthDate = case flags.birthDate of
                        Just savedInput ->
                            Result.toMaybe (Date.parse savedInput)
                        Nothing ->
                            Nothing
    in
        ((Model now birthDate "" Nothing), Cmd.none)


-- UPDATE --

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        InputChanged input ->
            ({ model | inputString = input }, Cmd.none)

        DateSubmitted input ->
            let
                date = Date.parse input
            in
                case date of
                    Ok birthDate ->
                        ({ model | birthDate = Just birthDate, errorMessage = Nothing }, saveBirthDate input)
                    Err err ->
                        ( { model | birthDate = Nothing, errorMessage = Just err }, Cmd.none )

-- VIEW --


view: Model -> Html Msg
view model =
    Html.div [ Attr.class "container" ]
        [ formView model
        , case model.birthDate of
            Just birthDate ->
                calendarView model.now birthDate
            Nothing ->
                Html.div [] []
        , case model.errorMessage of
            Just err ->
                Html.p [ Attr.class "error-message" ]
                    [ Html.text err]
            Nothing ->
                Html.p [] []
        ]


formView: Model -> Html Msg
formView model =
    Html.form [ Event.onSubmit (DateSubmitted model.inputString) ]
        [ Html.p []
            [ Html.text "Please, submit your birth date" ]
        , Html.input
            [ Attr.placeholder "yyyy-mm-dd"
            , Attr.value model.inputString
            , Event.onInput InputChanged
            ] []
        , Html.br [] []
        , Html.input [ Attr.type_ "submit", Attr.value "submit" ] []
        ]


calendarView: Date -> Date -> Html Msg
calendarView now birthDate =
    Html.div [ Attr.class "calendar-wrapper" ]
        [ yearsView now birthDate [] birthDate.year
        ]


yearsView: Date -> Date -> (List (Html Msg)) -> Int -> Html Msg
yearsView now birthDate htmlContent yearAcc =
    if yearAcc < (birthDate.year + 80) then
        let
            newHtmlContent = oneYearView now birthDate yearAcc 1 []
        in
            yearsView now birthDate (newHtmlContent :: htmlContent) (yearAcc + 1)
    else
        Html.div [] ( List.reverse htmlContent )


oneYearView: Date -> Date -> Int -> Int -> (List (Html Msg)) -> Html Msg
oneYearView now birthDate year week htmlAcc =
    if week < 53 then
        let
            className = if (shouldColor now birthDate (Date year 0 0 week))
                        then "colored-cell week-cell" 
                        else "week-cell"
            weekCell = Html.span[ Attr.class className ] []
        in
            oneYearView now birthDate year (week + 1) (weekCell :: htmlAcc)
    else
        Html.div [] ( Html.text ((String.fromInt year) ++ " ") ::  (List.reverse htmlAcc))


-- UTILS --

port saveBirthDate: String -> Cmd msg


shouldColor: Date -> Date -> Date -> Bool
shouldColor now birthDate checkingDate =
    checkingDate.year <= now.year
    && not (checkingDate.year == birthDate.year 
            && checkingDate.week < birthDate.week
            || checkingDate.year == now.year 
            && checkingDate.week >= now.week)


