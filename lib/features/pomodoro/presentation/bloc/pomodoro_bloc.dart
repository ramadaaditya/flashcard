import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flashcard/core/usecases/usecase.dart';
import 'package:flashcard/features/pomodoro/domain/entities/pomodoro_session.dart';
import 'package:flashcard/features/pomodoro/domain/usecases/complete_pomodoro.dart';
import 'package:flashcard/features/pomodoro/domain/usecases/get_pomodoro_settings.dart';
import 'package:flashcard/features/pomodoro/domain/usecases/start_pomodoro.dart';
import 'package:flashcard/features/pomodoro/presentation/bloc/pomodoro_event.dart';
import 'package:flashcard/features/pomodoro/presentation/bloc/pomodoro_state.dart';

class PomodoroBloc extends Bloc<PomodoroEvent, PomodoroState> {
  final StartPomodoro _startPomodoro;
  final CompletePomodoro _completePomodoro;
  final GetPomodoroSettings _getSettings;

  Timer? _timer;

  PomodoroBloc({
    required StartPomodoro startPomodoro,
    required CompletePomodoro completePomodoro,
    required GetPomodoroSettings getSettings,
  })  : _startPomodoro = startPomodoro,
        _completePomodoro = completePomodoro,
        _getSettings = getSettings,
        super(const PomodoroState()) {
    on<LoadPomodoroSettings>(_onLoadSettings);
    on<StartPomodoroTimer>(_onStart);
    on<PausePomodoroTimer>(_onPause);
    on<ResumePomodoroTimer>(_onResume);
    on<CompletePomodoroTimer>(_onComplete);
    on<ResetPomodoroTimer>(_onReset);
    on<TimerTick>(_onTick);
  }

  Future<void> _onLoadSettings(
    LoadPomodoroSettings event,
    Emitter<PomodoroState> emit,
  ) async {
    final result = await _getSettings(const NoParams());
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (settings) {
        final totalSeconds = settings.workDuration * 60;
        emit(state.copyWith(
          settings: settings,
          totalSeconds: totalSeconds,
          remainingSeconds: totalSeconds,
        ));
      },
    );
  }

  Future<void> _onStart(
    StartPomodoroTimer event,
    Emitter<PomodoroState> emit,
  ) async {
    final duration = _getDurationForType(event.type);
    final totalSeconds = duration * 60;

    final result = await _startPomodoro(StartPomodoroParams(
      type: event.type,
      durationMinutes: duration,
      taskId: event.taskId,
    ));

    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (session) {
        emit(state.copyWith(
          status: TimerStatus.running,
          currentType: event.type,
          totalSeconds: totalSeconds,
          remainingSeconds: totalSeconds,
          currentSessionId: session.id,
        ));
        _startTimer();
      },
    );
  }

  void _onPause(PausePomodoroTimer event, Emitter<PomodoroState> emit) {
    _timer?.cancel();
    emit(state.copyWith(status: TimerStatus.paused));
  }

  void _onResume(ResumePomodoroTimer event, Emitter<PomodoroState> emit) {
    emit(state.copyWith(status: TimerStatus.running));
    _startTimer();
  }

  Future<void> _onComplete(
    CompletePomodoroTimer event,
    Emitter<PomodoroState> emit,
  ) async {
    _timer?.cancel();
    if (state.currentSessionId != null) {
      await _completePomodoro(state.currentSessionId!);
    }
    final newCompleted = state.currentType == PomodoroType.work
        ? state.completedSessions + 1
        : state.completedSessions;

    emit(state.copyWith(
      status: TimerStatus.completed,
      completedSessions: newCompleted,
      remainingSeconds: 0,
    ));
  }

  void _onReset(ResetPomodoroTimer event, Emitter<PomodoroState> emit) {
    _timer?.cancel();
    final totalSeconds = _getDurationForType(state.currentType) * 60;
    emit(state.copyWith(
      status: TimerStatus.initial,
      remainingSeconds: totalSeconds,
      totalSeconds: totalSeconds,
    ));
  }

  void _onTick(TimerTick event, Emitter<PomodoroState> emit) {
    if (event.remainingSeconds <= 0) {
      add(const CompletePomodoroTimer());
    } else {
      emit(state.copyWith(remainingSeconds: event.remainingSeconds));
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      add(TimerTick(state.remainingSeconds - 1));
    });
  }

  int _getDurationForType(PomodoroType type) {
    return switch (type) {
      PomodoroType.work => state.settings.workDuration,
      PomodoroType.shortBreak => state.settings.shortBreakDuration,
      PomodoroType.longBreak => state.settings.longBreakDuration,
    };
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
