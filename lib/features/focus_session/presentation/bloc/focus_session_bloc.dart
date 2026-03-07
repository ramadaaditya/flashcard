import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flashcard/features/focus_session/domain/usecases/end_focus_session.dart';
import 'package:flashcard/features/focus_session/domain/usecases/get_focus_sessions.dart';
import 'package:flashcard/features/focus_session/domain/usecases/start_focus_session.dart';
import 'package:flashcard/features/focus_session/presentation/bloc/focus_session_event.dart';
import 'package:flashcard/features/focus_session/presentation/bloc/focus_session_state.dart';

class FocusSessionBloc extends Bloc<FocusSessionEvent, FocusSessionState> {
  final StartFocusSession _startFocusSession;
  final EndFocusSession _endFocusSession;
  final GetFocusSessions _getFocusSessions;

  FocusSessionBloc({
    required StartFocusSession startFocusSession,
    required EndFocusSession endFocusSession,
    required GetFocusSessions getFocusSessions,
  })  : _startFocusSession = startFocusSession,
        _endFocusSession = endFocusSession,
        _getFocusSessions = getFocusSessions,
        super(const FocusSessionInitial()) {
    on<StartFocusSessionEvent>(_onStart);
    on<EndFocusSessionEvent>(_onEnd);
    on<LoadFocusSessions>(_onLoad);
  }

  Future<void> _onStart(
    StartFocusSessionEvent event,
    Emitter<FocusSessionState> emit,
  ) async {
    emit(const FocusSessionLoading());
    final result = await _startFocusSession(StartFocusSessionParams(
      taskId: event.taskId,
      taskTitle: event.taskTitle,
    ));
    result.fold(
      (failure) => emit(FocusSessionError(failure.message)),
      (session) => emit(FocusSessionActive(session)),
    );
  }

  Future<void> _onEnd(
    EndFocusSessionEvent event,
    Emitter<FocusSessionState> emit,
  ) async {
    emit(const FocusSessionLoading());
    final result = await _endFocusSession(EndFocusSessionParams(
      sessionId: event.sessionId,
      notes: event.notes,
    ));
    result.fold(
      (failure) => emit(FocusSessionError(failure.message)),
      (session) => emit(FocusSessionEnded(session)),
    );
  }

  Future<void> _onLoad(
    LoadFocusSessions event,
    Emitter<FocusSessionState> emit,
  ) async {
    emit(const FocusSessionLoading());
    final result = await _getFocusSessions(GetFocusSessionsParams(
      from: event.from,
      to: event.to,
    ));
    result.fold(
      (failure) => emit(FocusSessionError(failure.message)),
      (sessions) => emit(FocusSessionsLoaded(sessions)),
    );
  }
}
