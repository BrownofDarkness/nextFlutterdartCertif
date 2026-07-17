class TaskNotFoundException implements Exception {
  final String message;
  TaskNotFoundException(this.message);
}

class InvalidPriorityException implements Exception {
  final String message;
  InvalidPriorityException(this.message);
}
