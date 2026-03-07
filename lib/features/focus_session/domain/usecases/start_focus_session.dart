import 'package:dartz/dartz.dart';
import 'package:flashcard/core/error/failures.dart';
import 'package:flashcard/core/usecases/usecase.dart';
import 'package:flashcard/features/focus_session/domain/entities/focus_session.dart';
import 'package:flashcard/features/focus_session/domain/repositories/focus_session_repository.dart';

class StartFocusSession
    extends UseCase<FocusSession, StartFocusSessionParams> {
  final FocusSessionRepository repository;

  StartFocusSession(this.repository);

  @override
  Future<Either<Failure, FocusSession>> call(StartFocusSessionParams params) {
    return repository.startSession(
      taskId: params.taskId,
      taskTitle: params.taskTitle,
    );
  }
}

class StartFocusSessionParams {
  final String? taskId;
  final String? taskTitle;

  const StartFocusSessionParams({this.taskId, this.taskTitle});
}
