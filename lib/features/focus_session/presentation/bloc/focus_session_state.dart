import 'package:equatable/equatable.dart';
import 'package:flashcard/features/focus_session/domain/entities/focus_session.dart';

abstract class FocusSessionState extends Equatable {
  const FocusSessionState();

  @override
  List<Object?> get props => [];
}

class FocusSessionInitial extends FocusSessionState {
  const FocusSessionInitial();
}

class FocusSessionLoading extends FocusSessionState {
  const FocusSessionLoading();
}

class FocusSessionActive extends FocusSessionState {
  final FocusSession session;

  const FocusSessionActive(this.session);

  @override
  List<Object?> get props => [session];
}

class FocusSessionsLoaded extends FocusSessionState {
  final List<FocusSession> sessions;

  const FocusSessionsLoaded(this.sessions);

  @override
  List<Object?> get props => [sessions];
}

class FocusSessionEnded extends FocusSessionState {
  final FocusSession session;

  const FocusSessionEnded(this.session);

  @override
  List<Object?> get props => [session];
}

class FocusSessionError extends FocusSessionState {
  final String message;

  const FocusSessionError(this.message);

  @override
  List<Object?> get props => [message];
}
