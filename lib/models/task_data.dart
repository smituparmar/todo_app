import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:todo_flutter/models/task.dart';
import 'package:todo_flutter/database_helper.dart';

class TaskData extends ChangeNotifier {
  final dbHelper = DatabaseHelper.instance;

  List<Task> _tasks = [];

  int get taskCount {
    return _tasks.length;
  }

  void initTask() async {
    await setTask();
    print('total task $taskCount');
  }

  UnmodifiableListView<Task> get getTask {
    _tasks.forEach((element) {
      print(element.name);
    });
    return UnmodifiableListView(_tasks);
  }

  void setTask() async {
    final allRows = await dbHelper.queryAllRows();
    print('query all rows:');
    allRows.forEach((row) => _tasks.add(Task(name: row['task'])));
  }

  void addTask(String newTaskTitle) {
    final task = Task(name: newTaskTitle);
    _tasks.add(task);
    _insert(newTaskTitle);
    notifyListeners();
  }

  void updateTask(Task task) {
    task.toggleDone();
    notifyListeners();
  }

  void deleteTask(Task task, int index) {
    print(getTask);
    print(index);
    _tasks.remove(task);
    _delete(index);
    notifyListeners();
  }

  void _insert(newTaskTitle) async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnTask: newTaskTitle,
      DatabaseHelper.columnStatus: false,
    };
    final id = await dbHelper.insert(row);
    print('inserted row id: $id');
    _query();
  }

  void _query() async {
    final allRows = await dbHelper.queryAllRows();
    print('query all rows:');
    allRows.forEach((row) => print(row));
  }

//  void _update() async {
//    // row to update
//    Map<String, dynamic> row = {
//      DatabaseHelper.columnId: 1,
//      DatabaseHelper.: 'Mary',
//      DatabaseHelper.columnAge: 32
//    };
//    final rowsAffected = await dbHelper.update(row);
//    print('updated $rowsAffected row(s)');
//  }

  void _delete(index) async {
    // Assuming that the number of rows is the id for the last row.
    final rowsDeleted = await dbHelper.delete(index);
    print('deleted $rowsDeleted row(s): row $index');
  }
}
