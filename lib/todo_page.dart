// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'todo_provider.dart';

/// Hlavná stránka aplikácie so zoznamom úloh (To-Do list) bez setState
class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final _controller = TextEditingController();
  TodoPriority priority = TodoPriority.Normal;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addTodo() {
    if (_controller.text.trim().isEmpty) {
      showMsg(context, 'Input field must not be empty');
      return;
    }

    context.read<TodoProvider>().addTodo(_controller.text.trim(), priority);
    _controller.clear();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTodoSheet,
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(title: const Text('My Todos')),
      body: Consumer<TodoProvider>(
        builder: (context, todoProvider, child) {
          final todos = todoProvider.todos;
          if (todos.isEmpty) {
            return const Center(child: Text('Nothing to do!'));
          }

          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return TodoItem(
                todo: todo,
                onChanged: (value) {
                  todoProvider.toggleTodoStatus(index, value);
                },
                onDelete: () {
                  todoProvider.removeTodo(index);
                },
              );
            },
          );
        },
      ),
    );
  }

  void _showAddTodoSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setBuilderState) => Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 16.0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _controller,
                autofocus: true,
                decoration: const InputDecoration(hintText: 'What to do?'),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Select Priority'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Radio<TodoPriority>(
                    value: TodoPriority.Low,
                    groupValue: priority,
                    onChanged: (value) {
                      setBuilderState(() {
                        priority = value!;
                      });
                    },
                  ),
                  const Text('Low'),
                  Radio<TodoPriority>(
                    value: TodoPriority.Normal,
                    groupValue: priority,
                    onChanged: (value) {
                      setBuilderState(() {
                        priority = value!;
                      });
                    },
                  ),
                  const Text('Normal'),
                  Radio<TodoPriority>(
                    value: TodoPriority.High,
                    groupValue: priority,
                    onChanged: (value) {
                      setBuilderState(() {
                        priority = value!;
                      });
                    },
                  ),
                  const Text('High'),
                ],
              ),
              const SizedBox(height: 10),
              ElevatedButton(onPressed: _addTodo, child: const Text('SAVE')),
            ],
          ),
        ),
      ),
    );
  }
}

void showMsg(BuildContext context, String s) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Caution!'),
      content: Text(s),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('CLOSE'),
        ),
      ],
    ),
  );
}

class TodoItem extends StatelessWidget {
  final MyTodo todo;
  final Function(bool) onChanged;
  final VoidCallback onDelete;

  const TodoItem({
    super.key,
    required this.todo,
    required this.onChanged,
    required this.onDelete,
  });

  Color _getPriorityColor(TodoPriority priority) {
    switch (priority) {
      case TodoPriority.Low:
        return Colors.green;
      case TodoPriority.Normal:
        return Colors.orange;
      case TodoPriority.High:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: todo.completed,
        onChanged: (value) {
          if (value != null) onChanged(value);
        },
      ),
      title: Text(
        todo.name,
        style: TextStyle(
          decoration: todo.completed ? TextDecoration.lineThrough : null,
          color: todo.completed ? Colors.grey : Colors.black87,
        ),
      ),
      subtitle: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            margin: const EdgeInsets.only(right: 6),
            decoration: BoxDecoration(
              color: _getPriorityColor(todo.priority),
              shape: BoxShape.circle,
            ),
          ),
          Text(
            'Priority: ${todo.priority.name}',
            style: TextStyle(
              color: _getPriorityColor(todo.priority),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
        onPressed: onDelete,
      ),
    );
  }
}
