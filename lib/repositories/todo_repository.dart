import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/models/todo.dart';

const todoListKey = 'todo_list';

class TodoRepository {
  TodoRepository() {
    SharedPreferences.getInstance().then(
      (value) => {sharedPreferences = value},
    );
  }

  late SharedPreferences sharedPreferences;

  void saveTodoList(List<Todo> todos) {
    final jsonString = json.encode(todos);
    sharedPreferences.setString(todoListKey, jsonString);
  }

  Future<List<Todo>> loadTodoList() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final String jsonString = sharedPreferences.getString(todoListKey) ?? '[]';
    final List jsonDecoded = jsonDecode(jsonString);
    return jsonDecoded.map((e) => Todo.fromJson(e)).toList();
  }
}
