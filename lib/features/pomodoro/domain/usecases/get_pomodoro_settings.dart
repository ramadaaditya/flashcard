import 'package:dartz/dartz.dart';
import 'package:flashcard/core/error/failures.dart';
import 'package:flashcard/core/usecases/usecase.dart';
import 'package:flashcard/features/pomodoro/domain/entities/pomodoro_session.dart';
import 'package:flashcard/features/pomodoro/domain/repositories/pomodoro_repository.dart';

class GetPomodoroSettings extends UseCase<PomodoroSettings, NoParams> {
  final PomodoroRepository repository;

  GetPomodoroSettings(this.repository);

  @override
  Future<Either<Failure, PomodoroSettings>> call(NoParams params) {
    return repository.getSettings();
  }
}
