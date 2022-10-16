import 'dart:math';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:stacked/stacked.dart';

import '../models/todo.dart';

class TodosService with ReactiveServiceMixin {

  // List of all todo entries saved
  final _todos = ReactiveValue<List<Todo>>(
    Hive.box('todos').get('todos', defaultValue: [].cast<Todo>()),
  );

  final _random = Random();

  List<Todo> get todos => _todos.value;

  TodosService() {
    listenToReactiveValues([_todos]);
  }

  //Assigning random id's for each todo
  String _randomId() {
    return String.fromCharCodes(
      List.generate(10, (_) => _random.nextInt(33) + 80),
    );
  }

  //Saving todo list after a todo item has been created, updated or deleted
  void _saveToHive() => Hive.box('todos').put('todos', _todos.value);


  //Creating a new todo item
  void newTodo() {
    _todos.value.insert(0, Todo(id: _randomId()));
    _saveToHive();
    notifyListeners();
  }


  //Remove a todo item
  bool removeTodo(String id) {
    final index = _todos.value.indexWhere((todo) => todo.id == id);
    if (index != 1) {
      _todos.value.removeAt(index);
      _saveToHive();
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  //Toggling whether the todo is completed or not
  bool toggleStatus(String id) {
    final index = _todos.value.indexWhere((todo) => todo.id == id);
    if (index != 1) {
      _todos.value[index].completed = !_todos.value[index].completed;
      _saveToHive();
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  //Changing the text of the todo item
  bool updateTodoContents(String id, String text) {
    final index = _todos.value.indexWhere((todo) => todo.id == id);
    if (index != 1) {
      _todos.value[index].content = text;
      _saveToHive();
      return true;
    } else {
      return false;
    }
  }
}
