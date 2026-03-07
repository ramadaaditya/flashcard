import 'package:dartz/dartz.dart' hide Task;
import 'package:flashcard/core/error/failures.dart';
import 'package:flashcard/core/usecases/usecase.dart';
import 'package:flashcard/features/task_management/domain/entities/task.dart';
import 'package:flashcard/features/task_management/domain/repositories/task_repository.dart';

class GetTasks extends UseCase<List<Task>, GetTasksParams> {
  final TaskRepository repository;

  GetTasks(this.repository);

  @override
  Future<Either<Failure, List<Task>>> call(GetTasksParams params) {
    return repository.getTasks(filterByStatus: params.filterByStatus);
  }
}

class GetTasksParams {
  final TaskStatus? filterByStatus;

  const GetTasksParams({this.filterByStatus});
}
