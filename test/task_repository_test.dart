import 'package:test/test.dart';
import '../model.dart';
import '../task_repository.dart';
import '../exceptions.dart';

void main() {
  group('TaskRepository - addTask', () {
    test(
      'adding a task with invalid priority throws InvalidPriorityException',
      () {
        final repo = TaskRepository();
        final badTask = LowTask(title: 'Test', dueDate: null);
        badTask.priority = 'urgent'; // valeur invalide volontaire

        expect(
          () => repo.addTask(badTask),
          throwsA(isA<InvalidPriorityException>()),
        );
      },
    );
  });

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

  group('TaskRepository - updateTask', () {
    test('updating a task changes its title', () {
      final repo = TaskRepository();
      final task = LowTask(title: 'Ancien titre', dueDate: null);
      repo.addTask(task);

      final updatedTask = task.copyWith('Nouveau titre', null);
      repo.updateTask(task.id, updatedTask);

      final result = repo.tasks.firstWhere((t) => t.id == task.id);
      expect(result.title, equals('Nouveau titre'));
    });
  });

  group('TaskRepository - sort by priority', () {
    test('sorting tasks by priority puts "high" first', () {
      final repo = TaskRepository();
      repo.addTask(LowTask(title: 'Basse', dueDate: null));
      repo.addTask(UrgentTask(title: 'Urgente', dueDate: null));
      repo.addTask(MediumTask(title: 'Moyenne', dueDate: null));

      repo.listElts(sortby: 'priority');

      expect(repo.tasks.first.priority, equals('high'));
    });
  });
}
