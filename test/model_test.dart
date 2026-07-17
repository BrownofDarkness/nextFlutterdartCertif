import 'package:test/test.dart';
import '../model.dart';

void main() {
  group('Task creation', () {
    test('LowTask should have priority "low"', () {
      final task = LowTask(title: 'Acheter du pain', dueDate: null);

      expect(task.priority, equals('low'));
    });

    test('two tasks should have different ids', () {
      final task1 = LowTask(title: 'Tâche 1', dueDate: null);
      final task2 = LowTask(title: 'Tâche 2', dueDate: null);

      expect(task1.id, isNot(equals(task2.id)));
    });
  });
}
