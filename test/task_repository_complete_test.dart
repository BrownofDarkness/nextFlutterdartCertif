import 'package:test/test.dart';
import '../models/task_model.dart';
import '../repositories/task_repository.dart';

void main() {
  group('TaskRepository - completeTask', () {
    test('completeTask marks a task as completed', () {
      final repo = TaskRepository();
      final task = LowTask(title: 'À terminer', dueDate: null);
      repo.addTask(task);

      repo.completeTask(task.id);

      final result = repo.tasks.firstWhere((t) => t.id == task.id);
      expect(result.isCompleted, isTrue);
    });

    test('completeTask does not throw for non-existent id, just logs', () {
      final repo = TaskRepository();
      expect(() => repo.completeTask('id-inexistant'), returnsNormally);
    });
  });
}
