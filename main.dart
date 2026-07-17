import 'dart:io';

import 'model.dart';
import 'taskRepository.dart';

void main() {
  TaskRepository taskRepository = TaskRepository();
  taskRepository.readTasksFromFile(taskRepository.jsonFileName);

  while (true) {
    print("\nTask Manager");
    print("1. Add Task");
    print("2. Remove Task");
    print("3. Update Task");
    print("4. List Tasks");
    print("5. sort Tasks by Priority");
    print("6. sort Tasks by Due Date");
    print("0. Exit");
    stdout.write("Choose an option: ");
    String? choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        print("Adding a new task...");
        print("Enter task title: ");
        String? title = stdin.readLineSync();
        print("Enter task priority (high, medium, low): ");
        String? priority = stdin.readLineSync();
        print("Enter task due date (YYYY-MM-DD): ");
        String? dueDateInput = stdin.readLineSync();
        DateTime? dueDate;
        if (dueDateInput != null && dueDateInput.isNotEmpty) {
          dueDate = DateTime.parse(dueDateInput);
        }
        if (title == null ||
            title.isEmpty ||
            priority == null ||
            priority.isEmpty) {
          print("Title and priority are required.");
          break;
        }
        taskRepository.saveElt({
          "title": title,
          "priority": priority,
          "dueDate": dueDate,
        });

        print("Task added successfully.");
        break;
      case '2':
        if (taskRepository.tasks.isEmpty) {
          print("No tasks available to remove.");
          break;
        }
        print("Current tasks:");
        for (var task in taskRepository.tasks) {
          print(
            "=> ID: ${task.id}, Title: ${task.title}, Priority: ${task.priority}, Due Date: ${task.dueDate?.toIso8601String()}",
          );
        }
        print("choose the ID of the task to remove:");
        String? id = stdin.readLineSync();
        if (id != null && id.isNotEmpty) {
          taskRepository.deleteElt(id);
        }

        break;
      case '3':
        print("Updating a task...");
        if (taskRepository.tasks.isEmpty) {
          print("No tasks available to update.");
          break;
        }
        print("Current tasks:");
        for (var task in taskRepository.tasks) {
          print(
            "=> ID: ${task.id}, Title: ${task.title}, Priority: ${task.priority}, Due Date: ${task.dueDate?.toIso8601String()}",
          );
        }
        print("Enter the ID of the task to update: ");
        String? id = stdin.readLineSync();
        if (id == null || id.isEmpty) {
          print("Task ID is required.");
          break;
        }
        print("what do you want to update?");
        print("1. Title");
        print("2. Due Date");
        String? updateChoice = stdin.readLineSync();
        String? newTitle;
        DateTime? newDueDate;

        switch (updateChoice) {
          case '1':
            print("Enter new task title: ");
            newTitle = stdin.readLineSync();
            if (newTitle == null || newTitle.isEmpty) {
              print("Task title is required.");
              break;
            }
            Task updatedTask = taskRepository.tasks
                .firstWhere((task) => task.id == id)
                .copyWith(newTitle, null);
            taskRepository.updateElt(id, updatedTask);

            break;
          case '2':
            print("Enter new task due date (YYYY-MM-DD): ");
            String? newDueDateInput = stdin.readLineSync();
            DateTime? newDueDate;
            if (newDueDateInput != null && newDueDateInput.isNotEmpty) {
              newDueDate = DateTime.parse(newDueDateInput);
            }
            Task updatedTask = taskRepository.tasks
                .firstWhere((task) => task.id == id)
                .copyWith(newTitle, newDueDate);
            taskRepository.updateElt(id, updatedTask);
            break;
          default:
            print("Invalid choice. Please try again.");
            break;
        }
        break;
      case '4':
        print("Listing all tasks...");
        taskRepository.listElts(sortby: null);
        break;
      case '5':
        if (taskRepository.tasks.isEmpty) {
          print("No tasks available to list by priority.");
          break;
        }
        print("Listing tasks by priority...");
        taskRepository.listElts(sortby: "priority");
        break;
      case '6':
        if (taskRepository.tasks.isEmpty) {
          print("No tasks available to list by due date.");
          break;
        }
        print("Listing tasks by due date...");
        taskRepository.listElts(sortby: "dueDate");
        break;
      case '0':
        exit(0);
      default:
        print("Invalid choice. Please try again.");
    }
  }
}
