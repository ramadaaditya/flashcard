import 'package:dartz/dartz.dart';
import 'package:flashcard/core/error/exceptions.dart';
import 'package:flashcard/core/error/failures.dart';
import 'package:flashcard/features/focus_session/data/datasources/focus_session_local_datasource.dart';
import 'package:flashcard/features/focus_session/data/models/focus_session_model.dart';
import 'package:flashcard/features/focus_session/domain/entities/focus_session.dart';
import 'package:flashcard/features/focus_session/domain/repositories/focus_session_repository.dart';
import 'package:uuid/uuid.dart';

class FocusSessionRepositoryImpl implements FocusSessionRepository {
  final FocusSessionLocalDataSource localDataSource;
  final Uuid uuid;

  FocusSessionRepositoryImpl({
    required this.localDataSource,
    required this.uuid,
  });

  @override
  Future<Either<Failure, FocusSession>> startSession({
    String? taskId,
    String? taskTitle,
  }) async {
    try {
      final session = FocusSessionModel(
        id: uuid.v4(),
        startTime: DateTime.now(),
        taskId: taskId,
        taskTitle: taskTitle,
      );
      await localDataSource.saveSession(session);
      return Right(session);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, FocusSession>> endSession({
    required String sessionId,
    String? notes,
  }) async {
    try {
      final sessions = await localDataSource.getSessions();
      final index = sessions.indexWhere((s) => s.id == sessionId);
      if (index == -1) {
        return const Left(CacheFailure('Session not found'));
      }
      final now = DateTime.now();
      final updated = sessions[index].copyWith(
        endTime: now,
        durationMinutes: now.difference(sessions[index].startTime).inMinutes,
        notes: notes,
      );
      await localDataSource.saveSession(updated);
      return Right(updated);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<FocusSession>>> getSessions({
    DateTime? from,
    DateTime? to,
  }) async {
    try {
      var sessions = await localDataSource.getSessions();
      if (from != null) {
        sessions =
            sessions.where((s) => s.startTime.isAfter(from)).toList();
      }
      if (to != null) {
        sessions =
            sessions.where((s) => s.startTime.isBefore(to)).toList();
      }
      return Right(sessions);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, FocusSession?>> getActiveSession() async {
    try {
      final sessions = await localDataSource.getSessions();
      final active = sessions.where((s) => s.isActive).toList();
      return Right(active.isEmpty ? null : active.last);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, FocusSession>> recordDistraction(
      String sessionId) async {
    try {
      final sessions = await localDataSource.getSessions();
      final index = sessions.indexWhere((s) => s.id == sessionId);
      if (index == -1) {
        return const Left(CacheFailure('Session not found'));
      }
      final updated = sessions[index].copyWith(
        distractionCount: sessions[index].distractionCount + 1,
      );
      await localDataSource.saveSession(updated);
      return Right(updated);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, FocusSession>> incrementPomodoro(
      String sessionId) async {
    try {
      final sessions = await localDataSource.getSessions();
      final index = sessions.indexWhere((s) => s.id == sessionId);
      if (index == -1) {
        return const Left(CacheFailure('Session not found'));
      }
      final updated = sessions[index].copyWith(
        pomodorosCompleted: sessions[index].pomodorosCompleted + 1,
      );
      await localDataSource.saveSession(updated);
      return Right(updated);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
