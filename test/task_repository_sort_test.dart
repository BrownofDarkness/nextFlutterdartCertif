import 'package:test/test.dart';
import '../models/task_model.dart';
import '../repositories/task_repository.dart';

void main() {
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
