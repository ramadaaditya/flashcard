import 'package:equatable/equatable.dart';

enum PomodoroType { work, shortBreak, longBreak }

class PomodoroSession extends Equatable {
  final String id;
  final PomodoroType type;
  final int durationMinutes;
  final DateTime startedAt;
  final DateTime? completedAt;
  final bool isCompleted;
  final String? taskId;

  const PomodoroSession({
    required this.id,
    required this.type,
    required this.durationMinutes,
    required this.startedAt,
    this.completedAt,
    this.isCompleted = false,
    this.taskId,
  });

  @override
  List<Object?> get props => [
        id,
        type,
        durationMinutes,
        startedAt,
        completedAt,
        isCompleted,
        taskId,
      ];
}

class PomodoroSettings extends Equatable {
  final int workDuration;
  final int shortBreakDuration;
  final int longBreakDuration;
  final int sessionsBeforeLongBreak;

  const PomodoroSettings({
    this.workDuration = 25,
    this.shortBreakDuration = 5,
    this.longBreakDuration = 15,
    this.sessionsBeforeLongBreak = 4,
  });

  @override
  List<Object> get props => [
        workDuration,
        shortBreakDuration,
        longBreakDuration,
        sessionsBeforeLongBreak,
      ];
}
