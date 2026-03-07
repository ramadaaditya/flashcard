import 'dart:convert';

import 'package:flashcard/core/utils/typedefs.dart';
import 'package:flashcard/features/pomodoro/domain/entities/pomodoro_session.dart';

class PomodoroSessionModel extends PomodoroSession {
  const PomodoroSessionModel({
    required super.id,
    required super.type,
    required super.durationMinutes,
    required super.startedAt,
    super.completedAt,
    super.isCompleted,
    super.taskId,
  });

  factory PomodoroSessionModel.fromMap(DataMap map) {
    return PomodoroSessionModel(
      id: map['id'] as String,
      type: PomodoroType.values.byName(map['type'] as String),
      durationMinutes: map['durationMinutes'] as int,
      startedAt: DateTime.parse(map['startedAt'] as String),
      completedAt: map['completedAt'] != null
          ? DateTime.parse(map['completedAt'] as String)
          : null,
      isCompleted: map['isCompleted'] as bool? ?? false,
      taskId: map['taskId'] as String?,
    );
  }

  factory PomodoroSessionModel.fromJson(String source) =>
      PomodoroSessionModel.fromMap(json.decode(source) as DataMap);

  DataMap toMap() {
    return {
      'id': id,
      'type': type.name,
      'durationMinutes': durationMinutes,
      'startedAt': startedAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'isCompleted': isCompleted,
      'taskId': taskId,
    };
  }

  String toJson() => json.encode(toMap());

  PomodoroSessionModel copyWith({
    String? id,
    PomodoroType? type,
    int? durationMinutes,
    DateTime? startedAt,
    DateTime? completedAt,
    bool? isCompleted,
    String? taskId,
  }) {
    return PomodoroSessionModel(
      id: id ?? this.id,
      type: type ?? this.type,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      isCompleted: isCompleted ?? this.isCompleted,
      taskId: taskId ?? this.taskId,
    );
  }
}
