import 'package:test/test.dart';
import '../models/task_model.dart';
import '../repositories/task_repository.dart';
import '../utils/exceptions.dart';

void main() {
  group('TaskRepository - removeTask', () {
    test('removing an existing task removes it from the list', () {
      final repo = TaskRepository();
      final task = LowTask(title: 'À supprimer', dueDate: null);
      repo.addTask(task);

      repo.removeTask(task.id);

      expect(repo.tasks.any((t) => t.id == task.id), isFalse);
    });

    test('removing a non-existent id throws TaskNotFoundException', () {
      final repo = TaskRepository();

      expect(
        () => repo.removeTask('id-inexistant'),
        throwsA(isA<TaskNotFoundException>()),
      );
    });
  });

  group('TaskRepository - deleteElt', () {
    test('deleteElt removes task and does not throw for valid id', () {
      final repo = TaskRepository();
      final task = LowTask(title: 'À supprimer', dueDate: null);
      repo.addTask(task);

      expect(() => repo.deleteElt(task.id), returnsNormally);
      expect(repo.tasks.any((t) => t.id == task.id), isFalse);
    });
  });
}
