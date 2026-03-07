import 'dart:convert';

import 'package:flashcard/core/utils/typedefs.dart';
import 'package:flashcard/features/task_management/domain/entities/task.dart';

class TaskModel extends Task {
  const TaskModel({
    required super.id,
    required super.title,
    super.description,
    super.priority,
    super.status,
    required super.createdAt,
    super.dueDate,
    super.completedAt,
    super.tags,
    super.estimatedPomodoros,
    super.completedPomodoros,
  });

  factory TaskModel.fromMap(DataMap map) {
    return TaskModel(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String?,
      priority: TaskPriority.values.byName(map['priority'] as String),
      status: TaskStatus.values.byName(map['status'] as String),
      createdAt: DateTime.parse(map['createdAt'] as String),
      dueDate: map['dueDate'] != null
          ? DateTime.parse(map['dueDate'] as String)
          : null,
      completedAt: map['completedAt'] != null
          ? DateTime.parse(map['completedAt'] as String)
          : null,
      tags: List<String>.from(map['tags'] as List? ?? []),
      estimatedPomodoros: map['estimatedPomodoros'] as int? ?? 1,
      completedPomodoros: map['completedPomodoros'] as int? ?? 0,
    );
  }

  factory TaskModel.fromJson(String source) =>
      TaskModel.fromMap(json.decode(source) as DataMap);

  factory TaskModel.fromEntity(Task task) {
    return TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      priority: task.priority,
      status: task.status,
      createdAt: task.createdAt,
      dueDate: task.dueDate,
      completedAt: task.completedAt,
      tags: task.tags,
      estimatedPomodoros: task.estimatedPomodoros,
      completedPomodoros: task.completedPomodoros,
    );
  }

  DataMap toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority.name,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'tags': tags,
      'estimatedPomodoros': estimatedPomodoros,
      'completedPomodoros': completedPomodoros,
    };
  }

  String toJson() => json.encode(toMap());

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    TaskPriority? priority,
    TaskStatus? status,
    DateTime? createdAt,
    DateTime? dueDate,
    DateTime? completedAt,
    List<String>? tags,
    int? estimatedPomodoros,
    int? completedPomodoros,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      completedAt: completedAt ?? this.completedAt,
      tags: tags ?? this.tags,
      estimatedPomodoros: estimatedPomodoros ?? this.estimatedPomodoros,
      completedPomodoros: completedPomodoros ?? this.completedPomodoros,
    );
  }
}
