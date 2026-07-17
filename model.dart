import 'dart:math';

abstract class Task {
  final String id;
  String title;
  String priority;
  DateTime? dueDate;

  Task({required this.title, required this.priority, this.dueDate, String? id})
    : id =
          id ??
          '${DateTime.now().microsecondsSinceEpoch}-${Random().nextInt(999999)}';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'priority': priority,
      'dueDate': dueDate?.toIso8601String(),
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    final priority = json['priority'];
    final title = json['title'];
    final dueDate = json['dueDate'] != null
        ? DateTime.parse(json['dueDate'])
        : null;
    final id = json['id'];

    switch (priority) {
      case 'high':
        return UrgentTask(id: id, title: title, dueDate: dueDate);
      case 'low':
        return LowTask(id: id, title: title, dueDate: dueDate);
      case 'medium':
      default:
        return MediumTask(id: id, title: title, dueDate: dueDate);
    }
  }
}

class UrgentTask extends Task {
  UrgentTask({required String title, DateTime? dueDate, String? id})
    : super(title: title, priority: "high", dueDate: dueDate, id: id);

  UrgentTask copyWith(String? title, DateTime? dueDate) {
    return UrgentTask(
      id: this.id,
      title: title ?? this.title,
      dueDate: dueDate ?? this.dueDate,
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
  LowTask({required String title, DateTime? dueDate, String? id})
    : super(title: title, priority: "low", dueDate: dueDate, id: id);

  LowTask copyWith(String? title, DateTime? dueDate) {
    return LowTask(
      id: this.id,
      title: title ?? this.title,
      dueDate: dueDate ?? this.dueDate,
    );
  }

  @override
  String toString() {
    return "$title (pas pressé)";
  }
}

class MediumTask extends Task {
  MediumTask({required String title, DateTime? dueDate, String? id})
    : super(title: title, priority: "medium", dueDate: dueDate, id: id);

  MediumTask copyWith(String? title, DateTime? dueDate) {
    return MediumTask(
      id: this.id,
      title: title ?? this.title,
      dueDate: dueDate ?? this.dueDate,
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
