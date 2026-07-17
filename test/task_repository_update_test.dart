import 'package:test/test.dart';
import '../model.dart';
import '../task_repository.dart';

void main() {
  group('TaskRepository - updateTask', () {
    test('updating a task changes its title', () {
      final repo = TaskRepository();
      final task = LowTask(title: 'Ancien titre', dueDate: null);
      repo.addTask(task);

      final updatedTask = task.copyWith('Nouveau titre', null, null);
      repo.updateTask(task.id, updatedTask);

      final result = repo.tasks.firstWhere((t) => t.id == task.id);
      expect(result.title, equals('Nouveau titre'));
    });
  });
}
