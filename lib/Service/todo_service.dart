import 'package:hive_flutter/adapters.dart';
import 'package:todo/model/todo_model.dart';

class TodoService {
  Box<TodoModel>? _todoBox;

  Future<void> openBox() async {
    _todoBox = await Hive.openBox('todos');
  }

  Future<void> closeBox() async {
    await _todoBox!.close();
  }

  Future<void> addTodo(TodoModel todo) async {
    if (_todoBox == null) {
      await openBox();
    }
    await _todoBox!.add(todo);
  }

  Future<List<TodoModel>> getTodos() async {
    if (_todoBox == null) {
      await openBox();
    }
    return _todoBox!.values.toList();
  }

  Future<void> updateTodo(int index, TodoModel todo) async {
    if (_todoBox == null) {
      await openBox();
    }
    await _todoBox!.putAt(index, todo);
  }

  Future<void> deleteTodo(int index) async {
    if (_todoBox == null) {
      await openBox();
    }
    await _todoBox!.deleteAt(index);
  }
}
