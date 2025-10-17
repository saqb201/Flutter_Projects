import 'package:flutter/material.dart';
import '../model/todo_model.dart';

class TodoViewModel extends ChangeNotifier {
  final List<TodoModel> _todos = [];

  List<TodoModel> get todos => _todos;

  void addTodo(String title) {
    if (title.isEmpty) return;
    _todos.add(TodoModel(id: DateTime.now().toString(), title: title));
    notifyListeners();
  }

  void toggleTodo(String id) {
    final todo = _todos.firstWhere((todo) => todo.id == id);
    todo.toggleDone();
    notifyListeners();
  }

  void deleteTodo(String id) {
    _todos.removeWhere((todo) => todo.id == id);
    notifyListeners();
  }
}
