import 'package:flutter/material.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/widgets/todo_list_item.dart';

class TodoList extends StatefulWidget {
  TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<Todo> todos = [];

  Todo? todoDeleated;
  int? todoDeleatedPosition;

  final TextEditingController todoInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: todoInputController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Adicione um Tarefa",
                          hintText: "Ex: Estudando flutter...",
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (todoInputController.text != "") {
                            Todo newTodo = Todo(
                              title: todoInputController.text,
                              dateTime: DateTime.now(),
                            );

                            todos.add(newTodo);
                          }
                        });
                        todoInputController.clear();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff00d7f3),
                        padding: EdgeInsets.all(14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: Icon(Icons.add, size: 30, color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (Todo todo in todos)
                        TodoListItem(todo: todo, onDelete: onDelete),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Você possui ${todos.length} tarefas pendentes.",
                      ),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        dialogClearList();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff00d7f3),
                        padding: EdgeInsets.all(14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: Text(
                        "Limpar Tudo",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void dialogClearList() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Remover todas as tarefas"),
            content: Text(
              "Voce têm certeza que deseja remover todas as tarefas?",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Cancelar",
                  style: TextStyle(color: Color(0xff00d7f3)),
                ),
              ),
              TextButton(
                onPressed: () {
                  onClearList();
                  Navigator.of(context).pop();
                },
                child: Text("Confirmar", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

  void onDelete(Todo todo) {
    Todo todoDeleted = todo;
    int todoPositionDeleted = todos.indexOf(todo);

    setState(() {
      todos.remove(todo);
    });

    showSnackBar(
      todoDeleted: todoDeleted,
      todoPositionDeleted: todoPositionDeleted,
    );
  }

  void onClearList() {
    List<Todo> todosCopy = [...todos];

    setState(() {
      todos.clear();
    });

    showSnackBar(todosDeleted: todosCopy);
  }

  void showSnackBar({
    Todo? todoDeleted,
    int? todoPositionDeleted,
    List<Todo>? todosDeleted,
  }) {
    List<Todo> todosCopy = [];

    if (todosDeleted != null) {
      todosCopy = [...todosDeleted];
    }

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          todoDeleted != null
              ? "A tarefa '${todoDeleted.title}' foi removida com sucesso!"
              : "${todosCopy.length} tarefas foram removidas com sucesso!",
          style: TextStyle(color: Color(0xff060708)),
        ),
        backgroundColor: Colors.white,
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: "Desfazer",
          textColor: Color(0xff00d7f3),
          onPressed: () {
            setState(() {
              if (todoDeleted != null) {
                todos.insert(todoPositionDeleted!, todoDeleted);
              }

              if (todosDeleted != null) {
                todos = [...todosCopy];
              }
            });
          },
        ),
      ),
    );
  }
}
