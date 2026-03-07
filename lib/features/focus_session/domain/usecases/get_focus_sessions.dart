import 'package:dartz/dartz.dart';
import 'package:flashcard/core/error/failures.dart';
import 'package:flashcard/core/usecases/usecase.dart';
import 'package:flashcard/features/focus_session/domain/entities/focus_session.dart';
import 'package:flashcard/features/focus_session/domain/repositories/focus_session_repository.dart';

class GetFocusSessions
    extends UseCase<List<FocusSession>, GetFocusSessionsParams> {
  final FocusSessionRepository repository;

  GetFocusSessions(this.repository);

  @override
  Future<Either<Failure, List<FocusSession>>> call(
      GetFocusSessionsParams params) {
    return repository.getSessions(from: params.from, to: params.to);
  }
}

class GetFocusSessionsParams {
  final DateTime? from;
  final DateTime? to;

  const GetFocusSessionsParams({this.from, this.to});
}
