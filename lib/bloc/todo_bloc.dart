import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_bloc/models/todo.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(const TodoInitial([])) {
    on<OnAddTodo>((event, emit) {
      Todo newTodo = event.newTodo;
      emit(TodoAdded([...state.todos, newTodo]));
    });

    on<OnUpdateTodo>((event, emit) {
      int index = event.index;
      Todo newTodo = event.updatedTodo;
      List<Todo> todosUpdated = state.todos;
      todosUpdated[index] = newTodo;
      emit(TodoUpdate(todosUpdated));
    });

    on<OnRemoveTodo>((event, emit) {
      int index = event.index;
      List<Todo> todosRemoved = state.todos;
      todosRemoved.removeAt(index);
      emit(TodoRemove(todosRemoved));
    });
  }
}
