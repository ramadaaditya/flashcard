import 'package:dartz/dartz.dart' hide Task;
import 'package:flashcard/core/error/failures.dart';
import 'package:flashcard/core/usecases/usecase.dart';
import 'package:flashcard/features/task_management/domain/entities/task.dart';
import 'package:flashcard/features/task_management/domain/repositories/task_repository.dart';

class CreateTask extends UseCase<Task, Task> {
  final TaskRepository repository;

  CreateTask(this.repository);

  @override
  Future<Either<Failure, Task>> call(Task task) {
    return repository.createTask(task);
  }
}
