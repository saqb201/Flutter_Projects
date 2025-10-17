import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/todo_view_model.dart';
import '../model/todo_model.dart';

class TodoScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TodoViewModel(),
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 235, 163, 248),
        appBar: AppBar(title: Text('ToDo with MVVM App' , style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.purple,
        centerTitle: true,
        ),
        body: Consumer<TodoViewModel>(
          builder: (context, viewModel, child) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            labelText: 'Enter task',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          viewModel.addTodo(_controller.text);
                          _controller.clear();
                        },
                        child: Text('Add'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: viewModel.todos.length,
                    itemBuilder: (context, index) {
                      TodoModel todo = viewModel.todos[index];
                      return ListTile(
                        leading: Checkbox(
                          value: todo.isDone,
                          onChanged: (_) {
                            viewModel.toggleTodo(todo.id);
                          },
                        ),
                        title: Text(
                          todo.title,
                          style: TextStyle(
                            decoration: todo.isDone
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            viewModel.deleteTodo(todo.id);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
