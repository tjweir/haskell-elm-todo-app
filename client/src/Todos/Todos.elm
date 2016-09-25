module Todos.Todos exposing (..)

import Html exposing (..)
import Http
import Todo.Todo as Todo
import Task
import Api


type alias Model =
    { todos : List Todo.Model
    , selectedTodo : Maybe Todo.Model
    }


initialModel : Model
initialModel =
    { todos = []
    , selectedTodo = Nothing
    }


type Msg
    = FetchTodosDone (List Todo.Model)
    | FetchTodosFail Http.Error
    | AddNewTodo Todo.Model
    | NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchTodosDone todos ->
            { model | todos = todos } ! []

        FetchTodosFail error ->
            ( model, Cmd.none )

        AddNewTodo todo ->
            ( { model | todos = model.todos ++ [ todo ] }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )


getTodos : Cmd Msg
getTodos =
    Api.getTodos
        |> Task.perform FetchTodosFail FetchTodosDone


listView : Model -> Html Msg
listView model =
    ul []
        (List.map itemView model.todos)


itemView : Todo.Model -> Html Msg
itemView todo =
    li []
        [ text todo.description ]
