import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_bloc/models/todo.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(const TodoState([], TodoStatus.initial)) {
    on<OnFetchTodos>(fetchTodo);

    on<OnAddTodo>(addTodo);

    on<OnUpdateTodo>(updateTodo);

    on<OnRemoveTodo>(removeTodo);
  }

  FutureOr<void> fetchTodo(OnFetchTodos event, Emitter<TodoState> emit) async {
    emit(TodoState(state.todos, TodoStatus.loading));
    await Future.delayed(const Duration(milliseconds: 1500), () {
      emit(TodoState([Todo('title', 'description')], TodoStatus.success));
    });
  }

  FutureOr<void> addTodo(OnAddTodo event, Emitter<TodoState> emit) {
    Todo newTodo = event.newTodo;
    emit(TodoState([...state.todos, newTodo], TodoStatus.success));
  }

  FutureOr<void> updateTodo(OnUpdateTodo event, Emitter<TodoState> emit) {
    int index = event.index;
    Todo newTodo = event.updatedTodo;
    List<Todo> todosUpdated = state.todos;
    todosUpdated[index] = newTodo;
    emit(TodoState(todosUpdated, TodoStatus.success));
  }

  FutureOr<void> removeTodo(OnRemoveTodo event, Emitter<TodoState> emit) {
    int index = event.index;
    List<Todo> todosRemoved = state.todos;
    todosRemoved.removeAt(index);
    emit(TodoState(todosRemoved, TodoStatus.success));
  }
}
