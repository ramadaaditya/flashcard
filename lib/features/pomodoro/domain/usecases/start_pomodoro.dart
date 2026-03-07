import 'package:dartz/dartz.dart';
import 'package:flashcard/core/error/failures.dart';
import 'package:flashcard/core/usecases/usecase.dart';
import 'package:flashcard/features/pomodoro/domain/entities/pomodoro_session.dart';
import 'package:flashcard/features/pomodoro/domain/repositories/pomodoro_repository.dart';

class StartPomodoro extends UseCase<PomodoroSession, StartPomodoroParams> {
  final PomodoroRepository repository;

  StartPomodoro(this.repository);

  @override
  Future<Either<Failure, PomodoroSession>> call(StartPomodoroParams params) {
    return repository.startSession(
      type: params.type,
      durationMinutes: params.durationMinutes,
      taskId: params.taskId,
    );
  }
}

class StartPomodoroParams {
  final PomodoroType type;
  final int durationMinutes;
  final String? taskId;

  const StartPomodoroParams({
    required this.type,
    required this.durationMinutes,
    this.taskId,
  });
}
