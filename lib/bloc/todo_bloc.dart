import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_bloc/models/todo.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(const TodoInitial([])) {
    on<OnAddTodo>(addTodo);

    on<OnUpdateTodo>(updateTodo);

    on<OnRemoveTodo>(removeTodo);
  }

  FutureOr<void> addTodo(OnAddTodo event, Emitter<TodoState> emit) async {
    emit(TodoLoading(state.todos));
    await Future.delayed(const Duration(milliseconds: 1500));
    Todo newTodo = event.newTodo;
    emit(TodoAdded([...state.todos, newTodo]));
  }

  FutureOr<void> updateTodo(OnUpdateTodo event, Emitter<TodoState> emit) async {
    emit(TodoLoading(state.todos));
    await Future.delayed(const Duration(milliseconds: 1500));
    int index = event.index;
    Todo newTodo = event.updatedTodo;
    List<Todo> todosUpdated = state.todos;
    todosUpdated[index] = newTodo;
    emit(TodoUpdate(todosUpdated));
  }

  FutureOr<void> removeTodo(OnRemoveTodo event, Emitter<TodoState> emit) async {
    emit(TodoLoading(state.todos));
    await Future.delayed(const Duration(milliseconds: 1500));
    int index = event.index;
    List<Todo> todosRemoved = state.todos;
    todosRemoved.removeAt(index);
    emit(TodoRemove(todosRemoved));
  }
}
