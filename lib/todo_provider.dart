import 'package:flutter/material.dart';

/// Enum pre úroveň priority úlohy
enum TodoPriority { Low, Normal, High }

/// Dátový model pre jednu úlohu
class MyTodo {
  int id;
  String name;
  bool completed;
  TodoPriority priority;

  MyTodo({
    required this.id,
    required this.name,
    this.completed = false,
    required this.priority,
  });
}

/// Trieda TodoProvider rozširujúca ChangeNotifier pre centralizovanú správu stavu
class TodoProvider extends ChangeNotifier {
  final List<MyTodo> _todos = [];

  List<MyTodo> get todos => List.unmodifiable(_todos);

  /// Pridanie novej úlohy
  void addTodo(String name, TodoPriority priority) {
    final todo = MyTodo(
      id: DateTime.now().millisecondsSinceEpoch,
      name: name,
      priority: priority,
    );
    _todos.add(todo);
    notifyListeners();
  }

  /// Prepnutie stavu dokončenia úlohy
  void toggleTodoStatus(int index, bool value) {
    if (index >= 0 && index < _todos.length) {
      _todos[index].completed = value;
      notifyListeners();
    }
  }

  /// Odstránenie úlohy
  void removeTodo(int index) {
    if (index >= 0 && index < _todos.length) {
      _todos.removeAt(index);
      notifyListeners();
    }
  }
}
