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
}
