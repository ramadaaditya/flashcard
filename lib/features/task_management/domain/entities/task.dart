import 'package:equatable/equatable.dart';

enum TaskPriority { low, medium, high, urgent }

enum TaskStatus { todo, inProgress, done }

class Task extends Equatable {
  final String id;
  final String title;
  final String? description;
  final TaskPriority priority;
  final TaskStatus status;
  final DateTime createdAt;
  final DateTime? dueDate;
  final DateTime? completedAt;
  final List<String> tags;
  final int estimatedPomodoros;
  final int completedPomodoros;

  const Task({
    required this.id,
    required this.title,
    this.description,
    this.priority = TaskPriority.medium,
    this.status = TaskStatus.todo,
    required this.createdAt,
    this.dueDate,
    this.completedAt,
    this.tags = const [],
    this.estimatedPomodoros = 1,
    this.completedPomodoros = 0,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        priority,
        status,
        createdAt,
        dueDate,
        completedAt,
        tags,
        estimatedPomodoros,
        completedPomodoros,
      ];
}
