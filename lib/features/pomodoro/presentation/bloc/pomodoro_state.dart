import 'package:equatable/equatable.dart';
import 'package:flashcard/features/pomodoro/domain/entities/pomodoro_session.dart';

enum TimerStatus { initial, running, paused, completed }

class PomodoroState extends Equatable {
  final TimerStatus status;
  final PomodoroType currentType;
  final int remainingSeconds;
  final int totalSeconds;
  final int completedSessions;
  final PomodoroSettings settings;
  final String? currentSessionId;
  final String? errorMessage;

  const PomodoroState({
    this.status = TimerStatus.initial,
    this.currentType = PomodoroType.work,
    this.remainingSeconds = 1500,
    this.totalSeconds = 1500,
    this.completedSessions = 0,
    this.settings = const PomodoroSettings(),
    this.currentSessionId,
    this.errorMessage,
  });

  PomodoroState copyWith({
    TimerStatus? status,
    PomodoroType? currentType,
    int? remainingSeconds,
    int? totalSeconds,
    int? completedSessions,
    PomodoroSettings? settings,
    String? currentSessionId,
    String? errorMessage,
  }) {
    return PomodoroState(
      status: status ?? this.status,
      currentType: currentType ?? this.currentType,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      completedSessions: completedSessions ?? this.completedSessions,
      settings: settings ?? this.settings,
      currentSessionId: currentSessionId ?? this.currentSessionId,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        currentType,
        remainingSeconds,
        totalSeconds,
        completedSessions,
        settings,
        currentSessionId,
        errorMessage,
      ];
}
