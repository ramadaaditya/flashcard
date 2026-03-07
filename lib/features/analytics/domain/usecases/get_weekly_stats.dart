import 'package:dartz/dartz.dart';
import 'package:flashcard/core/error/failures.dart';
import 'package:flashcard/core/usecases/usecase.dart';
import 'package:flashcard/features/analytics/domain/entities/analytics_data.dart';
import 'package:flashcard/features/analytics/domain/repositories/analytics_repository.dart';

class GetWeeklyStats extends UseCase<WeeklyAnalytics, DateTime> {
  final AnalyticsRepository repository;

  GetWeeklyStats(this.repository);

  @override
  Future<Either<Failure, WeeklyAnalytics>> call(DateTime weekStart) {
    return repository.getWeeklyStats(weekStart);
  }
}
