import 'package:dartz/dartz.dart';
import 'package:flashcard/core/error/failures.dart';
import 'package:flashcard/core/usecases/usecase.dart';
import 'package:flashcard/features/analytics/domain/entities/analytics_data.dart';
import 'package:flashcard/features/analytics/domain/repositories/analytics_repository.dart';

class GetDailyStats extends UseCase<AnalyticsData, DateTime> {
  final AnalyticsRepository repository;

  GetDailyStats(this.repository);

  @override
  Future<Either<Failure, AnalyticsData>> call(DateTime date) {
    return repository.getDailyStats(date);
  }
}
