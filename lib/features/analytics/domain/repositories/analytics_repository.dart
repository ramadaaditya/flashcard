import 'package:flashcard/core/utils/typedefs.dart';
import 'package:flashcard/features/analytics/domain/entities/analytics_data.dart';

abstract class AnalyticsRepository {
  ResultFuture<AnalyticsData> getDailyStats(DateTime date);

  ResultFuture<WeeklyAnalytics> getWeeklyStats(DateTime weekStart);

  ResultFuture<List<AnalyticsData>> getStatsRange({
    required DateTime from,
    required DateTime to,
  });

  ResultVoid recordAnalyticsEntry(AnalyticsData data);
}
