import 'package:flashcard/core/utils/typedefs.dart';
import 'package:flashcard/features/task_management/domain/entities/task.dart';

abstract class TaskRepository {
  ResultFuture<Task> createTask(Task task);

  ResultFuture<List<Task>> getTasks({TaskStatus? filterByStatus});

  ResultFuture<Task> getTaskById(String id);

  ResultFuture<Task> updateTask(Task task);

  ResultVoid deleteTask(String id);

  ResultFuture<List<Task>> searchTasks(String query);
}
