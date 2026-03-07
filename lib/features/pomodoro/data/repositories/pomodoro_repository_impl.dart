import 'package:dartz/dartz.dart';
import 'package:flashcard/core/error/exceptions.dart';
import 'package:flashcard/core/error/failures.dart';
import 'package:flashcard/features/pomodoro/data/datasources/pomodoro_local_datasource.dart';
import 'package:flashcard/features/pomodoro/data/models/pomodoro_session_model.dart';
import 'package:flashcard/features/pomodoro/domain/entities/pomodoro_session.dart';
import 'package:flashcard/features/pomodoro/domain/repositories/pomodoro_repository.dart';
import 'package:uuid/uuid.dart';

class PomodoroRepositoryImpl implements PomodoroRepository {
  final PomodoroLocalDataSource localDataSource;
  final Uuid uuid;

  PomodoroRepositoryImpl({
    required this.localDataSource,
    required this.uuid,
  });

  @override
  Future<Either<Failure, PomodoroSession>> startSession({
    required PomodoroType type,
    required int durationMinutes,
    String? taskId,
  }) async {
    try {
      final session = PomodoroSessionModel(
        id: uuid.v4(),
        type: type,
        durationMinutes: durationMinutes,
        startedAt: DateTime.now(),
        taskId: taskId,
      );
      await localDataSource.saveSession(session);
      return Right(session);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, PomodoroSession>> completeSession(
      String sessionId) async {
    try {
      final sessions = await localDataSource.getSessions();
      final index = sessions.indexWhere((s) => s.id == sessionId);
      if (index == -1) {
        return const Left(CacheFailure('Session not found'));
      }
      final updated = sessions[index].copyWith(
        isCompleted: true,
        completedAt: DateTime.now(),
      );
      sessions[index] = updated;
      // Re-save all sessions
      for (final s in sessions) {
        await localDataSource.saveSession(s);
      }
      return Right(updated);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<PomodoroSession>>> getSessionHistory({
    DateTime? from,
    DateTime? to,
  }) async {
    try {
      var sessions = await localDataSource.getSessions();
      if (from != null) {
        sessions =
            sessions.where((s) => s.startedAt.isAfter(from)).toList();
      }
      if (to != null) {
        sessions = sessions.where((s) => s.startedAt.isBefore(to)).toList();
      }
      return Right(sessions);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, PomodoroSettings>> getSettings() async {
    try {
      final settings = await localDataSource.getSettings();
      return Right(settings);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updateSettings(
      PomodoroSettings settings) async {
    try {
      await localDataSource.saveSettings(settings);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, int>> getCompletedSessionsToday() async {
    try {
      final sessions = await localDataSource.getSessions();
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final count = sessions
          .where((s) =>
              s.isCompleted &&
              s.startedAt.isAfter(today) &&
              s.type == PomodoroType.work)
          .length;
      return Right(count);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
