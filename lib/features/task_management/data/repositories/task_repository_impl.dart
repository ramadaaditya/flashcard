import 'package:dartz/dartz.dart' hide Task;
import 'package:flashcard/core/error/exceptions.dart';
import 'package:flashcard/core/error/failures.dart';
import 'package:flashcard/features/task_management/data/datasources/task_local_datasource.dart';
import 'package:flashcard/features/task_management/data/models/task_model.dart';
import 'package:flashcard/features/task_management/domain/entities/task.dart';
import 'package:flashcard/features/task_management/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource localDataSource;

  TaskRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, Task>> createTask(Task task) async {
    try {
      final model = TaskModel.fromEntity(task);
      await localDataSource.saveTask(model);
      return Right(model);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Task>>> getTasks({
    TaskStatus? filterByStatus,
  }) async {
    try {
      var tasks = await localDataSource.getTasks();
      if (filterByStatus != null) {
        tasks = tasks.where((t) => t.status == filterByStatus).toList();
      }
      return Right(tasks);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Task>> getTaskById(String id) async {
    try {
      final task = await localDataSource.getTaskById(id);
      if (task == null) {
        return const Left(CacheFailure('Task not found'));
      }
      return Right(task);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Task>> updateTask(Task task) async {
    try {
      final model = TaskModel.fromEntity(task);
      await localDataSource.saveTask(model);
      return Right(model);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTask(String id) async {
    try {
      await localDataSource.deleteTask(id);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Task>>> searchTasks(String query) async {
    try {
      final tasks = await localDataSource.getTasks();
      final filtered = tasks
          .where((t) =>
              t.title.toLowerCase().contains(query.toLowerCase()) ||
              (t.description?.toLowerCase().contains(query.toLowerCase()) ??
                  false))
          .toList();
      return Right(filtered);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
