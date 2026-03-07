import 'dart:convert';

import 'package:flashcard/core/utils/typedefs.dart';
import 'package:flashcard/features/focus_session/domain/entities/focus_session.dart';

class FocusSessionModel extends FocusSession {
  const FocusSessionModel({
    required super.id,
    required super.startTime,
    super.endTime,
    super.durationMinutes,
    super.taskId,
    super.taskTitle,
    super.pomodorosCompleted,
    super.distractionCount,
    super.notes,
  });

  factory FocusSessionModel.fromMap(DataMap map) {
    return FocusSessionModel(
      id: map['id'] as String,
      startTime: DateTime.parse(map['startTime'] as String),
      endTime: map['endTime'] != null
          ? DateTime.parse(map['endTime'] as String)
          : null,
      durationMinutes: map['durationMinutes'] as int? ?? 0,
      taskId: map['taskId'] as String?,
      taskTitle: map['taskTitle'] as String?,
      pomodorosCompleted: map['pomodorosCompleted'] as int? ?? 0,
      distractionCount: map['distractionCount'] as int? ?? 0,
      notes: map['notes'] as String?,
    );
  }

  factory FocusSessionModel.fromJson(String source) =>
      FocusSessionModel.fromMap(json.decode(source) as DataMap);

  DataMap toMap() {
    return {
      'id': id,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'durationMinutes': durationMinutes,
      'taskId': taskId,
      'taskTitle': taskTitle,
      'pomodorosCompleted': pomodorosCompleted,
      'distractionCount': distractionCount,
      'notes': notes,
    };
  }

  String toJson() => json.encode(toMap());

  FocusSessionModel copyWith({
    String? id,
    DateTime? startTime,
    DateTime? endTime,
    int? durationMinutes,
    String? taskId,
    String? taskTitle,
    int? pomodorosCompleted,
    int? distractionCount,
    String? notes,
  }) {
    return FocusSessionModel(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      taskId: taskId ?? this.taskId,
      taskTitle: taskTitle ?? this.taskTitle,
      pomodorosCompleted: pomodorosCompleted ?? this.pomodorosCompleted,
      distractionCount: distractionCount ?? this.distractionCount,
      notes: notes ?? this.notes,
    );
  }
}
