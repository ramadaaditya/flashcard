import 'package:equatable/equatable.dart';

class FocusSession extends Equatable {
  final String id;
  final DateTime startTime;
  final DateTime? endTime;
  final int durationMinutes;
  final String? taskId;
  final String? taskTitle;
  final int pomodorosCompleted;
  final int distractionCount;
  final String? notes;

  const FocusSession({
    required this.id,
    required this.startTime,
    this.endTime,
    this.durationMinutes = 0,
    this.taskId,
    this.taskTitle,
    this.pomodorosCompleted = 0,
    this.distractionCount = 0,
    this.notes,
  });

  bool get isActive => endTime == null;

  int get actualDurationMinutes {
    if (endTime != null) {
      return endTime!.difference(startTime).inMinutes;
    }
    return DateTime.now().difference(startTime).inMinutes;
  }

  @override
  List<Object?> get props => [
        id,
        startTime,
        endTime,
        durationMinutes,
        taskId,
        taskTitle,
        pomodorosCompleted,
        distractionCount,
        notes,
      ];
}
