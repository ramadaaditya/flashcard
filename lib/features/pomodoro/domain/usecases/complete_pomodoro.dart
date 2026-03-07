import 'package:dartz/dartz.dart';
import 'package:flashcard/core/error/failures.dart';
import 'package:flashcard/core/usecases/usecase.dart';
import 'package:flashcard/features/pomodoro/domain/entities/pomodoro_session.dart';
import 'package:flashcard/features/pomodoro/domain/repositories/pomodoro_repository.dart';

class CompletePomodoro extends UseCase<PomodoroSession, String> {
  final PomodoroRepository repository;

  CompletePomodoro(this.repository);

  @override
  Future<Either<Failure, PomodoroSession>> call(String sessionId) {
    return repository.completeSession(sessionId);
  }
}
