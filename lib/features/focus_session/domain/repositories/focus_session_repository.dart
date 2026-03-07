import 'package:flashcard/core/utils/typedefs.dart';
import 'package:flashcard/features/focus_session/domain/entities/focus_session.dart';

abstract class FocusSessionRepository {
  ResultFuture<FocusSession> startSession({
    String? taskId,
    String? taskTitle,
  });

  ResultFuture<FocusSession> endSession({
    required String sessionId,
    String? notes,
  });

  ResultFuture<List<FocusSession>> getSessions({
    DateTime? from,
    DateTime? to,
  });

  ResultFuture<FocusSession?> getActiveSession();

  ResultFuture<FocusSession> recordDistraction(String sessionId);

  ResultFuture<FocusSession> incrementPomodoro(String sessionId);
}
