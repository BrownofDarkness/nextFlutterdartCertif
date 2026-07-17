import 'dart:convert';
import 'dart:io';

import 'utils/exceptions.dart';
import 'models/task_model.dart';
import 'repositories/default_repository.dart';

class TaskRepository implements Repository<Task> {
  String jsonFileName = "tasks.json";
  List<Task> _tasks = [];
  get tasks => _tasks;

  void addTask(Task task) {
    if (task.priority != 'high' &&
        task.priority != 'medium' &&
        task.priority != 'low') {
      throw InvalidPriorityException(
        "Invalid priority: ${task.priority}. Valid values are 'high', 'medium', or 'low'.",
      );
    }
    _tasks.add(task);
  }

  void removeTask(String id) {
    if (!_tasks.any((task) => task.id == id)) {
      throw TaskNotFoundException("Task with id $id not found.");
    }
    _tasks.removeWhere((task) => task.id == id);
  }

  void updateTask(String id, Task updatedTask) {
    if (!_tasks.any((task) => task.id == id)) {
      throw TaskNotFoundException("Task with id $id not found.");
    }

    final index = _tasks.indexWhere((task) => task.id == id);
    _tasks[index] = updatedTask;
  }

  void readTasksFromFile(String filePath) {
    File file = File(filePath);
    if (file.existsSync()) {
      String jsonString = file.readAsStringSync();
      List<dynamic> jsonList = jsonDecode(jsonString);
      _tasks = jsonList.map((json) => Task.fromJson(json)).toList();
    }
  }

  void writeTasksToFile(String filePath) {
    File file = File(filePath);
    if (!file.existsSync()) {
      file.createSync();
    }
    if (_tasks.isEmpty) {
      file.writeAsStringSync('[]');
      return;
    }
    String jsonString = jsonEncode(
      _tasks.map((task) => task.toJson()).toList(),
    );
    file.writeAsStringSync(jsonString);
  }

  @override
  void saveElt(Map<String, dynamic> elmt) {
    try {
      Task? task;
      if (elmt["priority"] == 'high') {
        task = UrgentTask(title: elmt["title"], dueDate: elmt["dueDate"]);
      } else if (elmt["priority"] == 'medium') {
        task = MediumTask(title: elmt["title"], dueDate: elmt["dueDate"]);
      } else if (elmt["priority"] == 'low') {
        task = LowTask(title: elmt["title"], dueDate: elmt["dueDate"]);
      }

      if (task == null) {
        throw InvalidPriorityException("Invalid priority: ${elmt["priority"]}");
      }
      addTask(task);
      writeTasksToFile(jsonFileName);
    } on InvalidPriorityException catch (e) {
      print(e.message);
    }
  }

  @override
  void listElts({String? sortby}) {
    try {
      if (sortby != null && sortby == 'priority') {
        //sort by priority
        const priorityWeight = {'high': 3, 'medium': 2, 'low': 1};

        _tasks.sort((a, b) {
          return priorityWeight[b.priority]!.compareTo(
            priorityWeight[a.priority]!,
          );
        });
      }

      if (sortby != null && sortby == 'dueDate') {
        _tasks.sort((a, b) {
          if (a.dueDate == null && b.dueDate == null) return 0;
          if (a.dueDate == null) return 1;
          if (b.dueDate == null) return -1;
          return a.dueDate!.compareTo(b.dueDate!);
        });
      }
    } finally {
      if (_tasks.isEmpty) {
        print("No tasks available.");
      } else {
        print("Current tasks:");
      }
      for (var task in _tasks) {
        print(
          "=>+ ID: ${task.id}, Title: ${task.title}, Priority: ${task.priority}, Due Date: ${task.dueDate?.toIso8601String()}",
        );
      }
    }
  }

  @override
  void updateElt(String id, Task newelt) {
    try {
      updateTask(id, newelt);
      writeTasksToFile(jsonFileName);
      print("Task updated successfully.");
    } on TaskNotFoundException catch (e) {
      print(e.message);
    }
  }

  @override
  void deleteElt(String id) {
    try {
      removeTask(id);
      writeTasksToFile(jsonFileName);
      print("Task removed successfully.");
    } on TaskNotFoundException catch (e) {
      print(e.message);
    }
  }
}
