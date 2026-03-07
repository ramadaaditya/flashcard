import 'package:equatable/equatable.dart';

abstract class FocusSessionEvent extends Equatable {
  const FocusSessionEvent();

  @override
  List<Object?> get props => [];
}

class StartFocusSessionEvent extends FocusSessionEvent {
  final String? taskId;
  final String? taskTitle;

  const StartFocusSessionEvent({this.taskId, this.taskTitle});

  @override
  List<Object?> get props => [taskId, taskTitle];
}

class EndFocusSessionEvent extends FocusSessionEvent {
  final String sessionId;
  final String? notes;

  const EndFocusSessionEvent({required this.sessionId, this.notes});

  @override
  List<Object?> get props => [sessionId, notes];
}

class LoadFocusSessions extends FocusSessionEvent {
  final DateTime? from;
  final DateTime? to;

  const LoadFocusSessions({this.from, this.to});

  @override
  List<Object?> get props => [from, to];
}

class RecordDistractionEvent extends FocusSessionEvent {
  final String sessionId;

  const RecordDistractionEvent(this.sessionId);

  @override
  List<Object?> get props => [sessionId];
}
