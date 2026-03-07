import 'package:flashcard/features/task_management/data/models/task_model.dart';

abstract class TaskRemoteDataSource {
  Future<List<TaskModel>> getTasks();
  Future<TaskModel> createTask(TaskModel task);
  Future<TaskModel> updateTask(TaskModel task);
  Future<void> deleteTask(String id);
}

/// TODO: Replace with actual API implementation
class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  @override
  Future<List<TaskModel>> getTasks() async {
    throw UnimplementedError('Connect to your backend');
  }

  @override
  Future<TaskModel> createTask(TaskModel task) async {
    throw UnimplementedError('Connect to your backend');
  }

  @override
  Future<TaskModel> updateTask(TaskModel task) async {
    throw UnimplementedError('Connect to your backend');
  }

  @override
  Future<void> deleteTask(String id) async {
    throw UnimplementedError('Connect to your backend');
  }
}
