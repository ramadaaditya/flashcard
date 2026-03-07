import 'dart:convert';

import 'package:flashcard/core/constants/app_constants.dart';
import 'package:flashcard/core/error/exceptions.dart';
import 'package:flashcard/features/task_management/data/models/task_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class TaskLocalDataSource {
  Future<List<TaskModel>> getTasks();
  Future<TaskModel?> getTaskById(String id);
  Future<void> saveTask(TaskModel task);
  Future<void> deleteTask(String id);
  Future<void> saveTasks(List<TaskModel> tasks);
}

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  final SharedPreferences sharedPreferences;

  TaskLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<List<TaskModel>> getTasks() async {
    final jsonString = sharedPreferences.getString(AppConstants.tasksBox);
    if (jsonString == null) return [];
    try {
      final List<dynamic> decoded = json.decode(jsonString);
      return decoded
          .map((e) => TaskModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      throw const CacheException('Failed to parse tasks');
    }
  }

  @override
  Future<TaskModel?> getTaskById(String id) async {
    final tasks = await getTasks();
    try {
      return tasks.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveTask(TaskModel task) async {
    final tasks = await getTasks();
    final index = tasks.indexWhere((t) => t.id == task.id);
    if (index >= 0) {
      tasks[index] = task;
    } else {
      tasks.add(task);
    }
    await saveTasks(tasks);
  }

  @override
  Future<void> deleteTask(String id) async {
    final tasks = await getTasks();
    tasks.removeWhere((t) => t.id == id);
    await saveTasks(tasks);
  }

  @override
  Future<void> saveTasks(List<TaskModel> tasks) async {
    final encoded = json.encode(tasks.map((t) => t.toMap()).toList());
    await sharedPreferences.setString(AppConstants.tasksBox, encoded);
  }
}
