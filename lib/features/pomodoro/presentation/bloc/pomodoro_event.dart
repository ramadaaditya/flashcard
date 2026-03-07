import 'package:equatable/equatable.dart';
import 'package:flashcard/features/pomodoro/domain/entities/pomodoro_session.dart';

abstract class PomodoroEvent extends Equatable {
  const PomodoroEvent();

  @override
  List<Object?> get props => [];
}

class StartPomodoroTimer extends PomodoroEvent {
  final PomodoroType type;
  final String? taskId;

  const StartPomodoroTimer({required this.type, this.taskId});

  @override
  List<Object?> get props => [type, taskId];
}

class PausePomodoroTimer extends PomodoroEvent {
  const PausePomodoroTimer();
}

class ResumePomodoroTimer extends PomodoroEvent {
  const ResumePomodoroTimer();
}

class CompletePomodoroTimer extends PomodoroEvent {
  const CompletePomodoroTimer();
}

class ResetPomodoroTimer extends PomodoroEvent {
  const ResetPomodoroTimer();
}

class TimerTick extends PomodoroEvent {
  final int remainingSeconds;

  const TimerTick(this.remainingSeconds);

  @override
  List<Object?> get props => [remainingSeconds];
}

class LoadPomodoroSettings extends PomodoroEvent {
  const LoadPomodoroSettings();
}
