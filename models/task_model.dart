import 'dart:math';

import '../utils/exceptions.dart';

abstract class Task {
  final String id;
  String title;
  String priority;
  DateTime? dueDate;
  bool isCompleted;

  Task({
    required this.title,
    required this.priority,
    this.dueDate,
    String? id,
    this.isCompleted = false,
  }) : id =
           id ??
           '${DateTime.now().microsecondsSinceEpoch}-${Random().nextInt(999999)}';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'priority': priority,
      'dueDate': dueDate?.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    final priority = json['priority'];
    final title = json['title'];
    final isCompleted = json['isCompleted'] ?? false;
    final dueDate = json['dueDate'] != null
        ? DateTime.parse(json['dueDate'])
        : null;
    final id = json['id'];

    switch (priority) {
      case 'high':
        return UrgentTask(
          id: id,
          title: title,
          dueDate: dueDate,
          isCompleted: isCompleted,
        );
      case 'low':
        return LowTask(
          id: id,
          title: title,
          dueDate: dueDate,
          isCompleted: isCompleted,
        );
      case 'medium':
        return MediumTask(
          id: id,
          title: title,
          dueDate: dueDate,
          isCompleted: isCompleted,
        );
      default:
        throw InvalidPriorityException("Invalid priority: $priority");
    }
  }
}

class UrgentTask extends Task {
  UrgentTask({required super.title, super.dueDate, super.id, super.isCompleted})
    : super(priority: "high");

  UrgentTask copyWith(String? title, DateTime? dueDate, bool? isCompleted) {
    return UrgentTask(
      id: id,
      title: title ?? this.title,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  String toString() {
    final dueInfo = dueDate != null
        ? " - Échéance: ${dueDate!.toIso8601String()}"
        : " - Aucune échéance";
    return "🔥 URGENT: $title $dueInfo";
  }
}

class LowTask extends Task {
  LowTask({required super.title, super.dueDate, super.id, super.isCompleted})
    : super(priority: "low");

  LowTask copyWith(String? title, DateTime? dueDate, bool? isCompleted) {
    return LowTask(
      id: id,
      title: title ?? this.title,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  String toString() {
    return "$title (pas pressé)";
  }
}

class MediumTask extends Task {
  MediumTask({required super.title, super.dueDate, super.id, super.isCompleted})
    : super(priority: "medium");

  MediumTask copyWith(String? title, DateTime? dueDate, bool? isCompleted) {
    return MediumTask(
      id: id,
      title: title ?? this.title,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  String toString() {
    final dueInfo = dueDate != null
        ? " (à faire avant le ${dueDate!.toIso8601String()})"
        : "";
    return "Tâche: $title$dueInfo";
  }
}
