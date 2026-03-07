import 'package:dartz/dartz.dart';
import 'package:flashcard/core/error/exceptions.dart';
import 'package:flashcard/core/error/failures.dart';
import 'package:flashcard/features/analytics/data/datasources/analytics_local_datasource.dart';
import 'package:flashcard/features/analytics/data/models/analytics_data_model.dart';
import 'package:flashcard/features/analytics/domain/entities/analytics_data.dart';
import 'package:flashcard/features/analytics/domain/repositories/analytics_repository.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final AnalyticsLocalDataSource localDataSource;

  AnalyticsRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, AnalyticsData>> getDailyStats(DateTime date) async {
    try {
      final allData = await localDataSource.getAnalytics();
      final dateKey = '${date.year}-${date.month}-${date.day}';
      final entry = allData.where((e) {
        final eKey = '${e.date.year}-${e.date.month}-${e.date.day}';
        return eKey == dateKey;
      }).toList();
      if (entry.isEmpty) {
        return Right(AnalyticsData(date: date));
      }
      return Right(entry.first);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, WeeklyAnalytics>> getWeeklyStats(
      DateTime weekStart) async {
    try {
      final weekEnd = weekStart.add(const Duration(days: 7));
      final allData = await localDataSource.getAnalytics();
      final weekData = allData
          .where((e) =>
              e.date.isAfter(weekStart.subtract(const Duration(days: 1))) &&
              e.date.isBefore(weekEnd))
          .toList();

      final totalFocus =
          weekData.fold<int>(0, (sum, d) => sum + d.totalFocusMinutes);
      final totalPomodoros =
          weekData.fold<int>(0, (sum, d) => sum + d.pomodorosCompleted);
      final totalTasks =
          weekData.fold<int>(0, (sum, d) => sum + d.tasksCompleted);
      final avgScore = weekData.isEmpty
          ? 0.0
          : weekData.fold<double>(0, (sum, d) => sum + d.productivityScore) /
              weekData.length;

      return Right(WeeklyAnalytics(
        dailyData: weekData,
        totalFocusMinutes: totalFocus,
        totalPomodoros: totalPomodoros,
        totalTasksCompleted: totalTasks,
        averageProductivityScore: avgScore,
      ));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<AnalyticsData>>> getStatsRange({
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      final allData = await localDataSource.getAnalytics();
      final filtered = allData
          .where((e) => e.date.isAfter(from) && e.date.isBefore(to))
          .toList();
      return Right(filtered);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> recordAnalyticsEntry(
      AnalyticsData data) async {
    try {
      final model = AnalyticsDataModel(
        date: data.date,
        totalFocusMinutes: data.totalFocusMinutes,
        pomodorosCompleted: data.pomodorosCompleted,
        tasksCompleted: data.tasksCompleted,
        distractionCount: data.distractionCount,
        productivityScore: data.productivityScore,
      );
      await localDataSource.saveAnalyticsEntry(model);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
