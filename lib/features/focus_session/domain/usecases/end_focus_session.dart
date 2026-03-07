import 'package:dartz/dartz.dart';
import 'package:flashcard/core/error/failures.dart';
import 'package:flashcard/core/usecases/usecase.dart';
import 'package:flashcard/features/focus_session/domain/entities/focus_session.dart';
import 'package:flashcard/features/focus_session/domain/repositories/focus_session_repository.dart';

class EndFocusSession extends UseCase<FocusSession, EndFocusSessionParams> {
  final FocusSessionRepository repository;

  EndFocusSession(this.repository);

  @override
  Future<Either<Failure, FocusSession>> call(EndFocusSessionParams params) {
    return repository.endSession(
      sessionId: params.sessionId,
      notes: params.notes,
    );
  }
}

class EndFocusSessionParams {
  final String sessionId;
  final String? notes;

  const EndFocusSessionParams({required this.sessionId, this.notes});
}
