import 'package:equatable/equatable.dart';

class AnalyticsData extends Equatable {
  final DateTime date;
  final int totalFocusMinutes;
  final int pomodorosCompleted;
  final int tasksCompleted;
  final int distractionCount;
  final double productivityScore;

  const AnalyticsData({
    required this.date,
    this.totalFocusMinutes = 0,
    this.pomodorosCompleted = 0,
    this.tasksCompleted = 0,
    this.distractionCount = 0,
    this.productivityScore = 0.0,
  });

  @override
  List<Object> get props => [
        date,
        totalFocusMinutes,
        pomodorosCompleted,
        tasksCompleted,
        distractionCount,
        productivityScore,
      ];
}

class WeeklyAnalytics extends Equatable {
  final List<AnalyticsData> dailyData;
  final int totalFocusMinutes;
  final int totalPomodoros;
  final int totalTasksCompleted;
  final double averageProductivityScore;

  const WeeklyAnalytics({
    required this.dailyData,
    this.totalFocusMinutes = 0,
    this.totalPomodoros = 0,
    this.totalTasksCompleted = 0,
    this.averageProductivityScore = 0.0,
  });

  @override
  List<Object> get props => [
        dailyData,
        totalFocusMinutes,
        totalPomodoros,
        totalTasksCompleted,
        averageProductivityScore,
      ];
}
