import 'package:flashcard/core/utils/typedefs.dart';
import 'package:flashcard/features/pomodoro/domain/entities/pomodoro_session.dart';

abstract class PomodoroRepository {
  ResultFuture<PomodoroSession> startSession({
    required PomodoroType type,
    required int durationMinutes,
    String? taskId,
  });

  ResultFuture<PomodoroSession> completeSession(String sessionId);

  ResultFuture<List<PomodoroSession>> getSessionHistory({
    DateTime? from,
    DateTime? to,
  });

  ResultFuture<PomodoroSettings> getSettings();

  ResultVoid updateSettings(PomodoroSettings settings);

  ResultFuture<int> getCompletedSessionsToday();
}
