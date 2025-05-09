import 'package:d_info/d_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_bloc/bloc/todo_bloc.dart';
import 'package:todo_app_bloc/models/todo.dart';
import 'package:todo_app_bloc/widgets/simple_input.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  addTodo() {
    final edtTitle = TextEditingController();
    final edtDescription = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          contentPadding: const EdgeInsets.all(16),
          children: [
            SimpleInput(
              edtTitle: edtTitle,
              edtDescription: edtDescription,
              onTap: () {
                Todo newTodo = Todo(edtTitle.text, edtDescription.text);
                context.read<TodoBloc>().add(OnAddTodo(newTodo));
                Navigator.pop(context);
                DInfo.snackBarSuccess(context, 'Todo added successfully');
              },
              actionTitle: 'Add Todo',
            ),
          ],
        );
      },
    );
  }

  updateTodo(int index, Todo todo) {
    final edtTitle = TextEditingController();
    final edtDescription = TextEditingController();
    edtTitle.text = todo.title;
    edtDescription.text = todo.description;
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          contentPadding: const EdgeInsets.all(16),
          children: [
            SimpleInput(
              edtTitle: edtTitle,
              edtDescription: edtDescription,
              onTap: () {
                Todo newTodo = Todo(edtTitle.text, edtDescription.text);
                context.read<TodoBloc>().add(OnUpdateTodo(index, newTodo));
                Navigator.pop(context);
                DInfo.snackBarSuccess(context, 'Todo updated successfully');
              },
              actionTitle: 'Update Todo',
            ),
          ],
        );
      },
    );
  }

  removeTodo(int index) {
    DInfo.dialogConfirmation(
      context,
      'Remove Todo',
      'Are you sure remove this?',
    ).then((bool? yes) {
      if (yes ?? false) {
        context.read<TodoBloc>().add(OnRemoveTodo(index));
        DInfo.snackBarSuccess(context, 'Todo removed successfully');
      }
    });
  }

  @override
  void initState() {
    context.read<TodoBloc>().add(OnFetchTodos());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todo List')),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state.status == TodoStatus.initial) {
            return SizedBox.shrink();
          }
          if (state.status == TodoStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == TodoStatus.failed) {
            return const Center(child: Text('Failed to load todos'));
          }
          List<Todo> todos = state.todos;
          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              Todo todo = todos[index];
              return ListTile(
                leading: CircleAvatar(child: Text('${index + 1}')),
                title: Text(todo.title),
                subtitle: Text(todo.description),
                trailing: PopupMenuButton(
                  itemBuilder: (context) {
                    return [
                      const PopupMenuItem(
                        value: 'update',
                        child: Text('Update'),
                      ),
                      const PopupMenuItem(
                        value: 'remove',
                        child: Text('Remove'),
                      ),
                    ];
                  },
                  onSelected: (value) {
                    switch (value) {
                      case 'update':
                        updateTodo(index, todo);
                        break;
                      case 'remove':
                        removeTodo(index);
                        break;
                      default:
                        DInfo.snackBarError(context, 'Unknown action');
                        break;
                    }
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addTodo,
        child: const Icon(Icons.add),
      ),
    );
  }
}
