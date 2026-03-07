import 'package:equatable/equatable.dart';

abstract class AnalyticsEvent extends Equatable {
  const AnalyticsEvent();

  @override
  List<Object?> get props => [];
}

class LoadDailyAnalytics extends AnalyticsEvent {
  final DateTime date;

  const LoadDailyAnalytics(this.date);

  @override
  List<Object?> get props => [date];
}

class LoadWeeklyAnalytics extends AnalyticsEvent {
  final DateTime weekStart;

  const LoadWeeklyAnalytics(this.weekStart);

  @override
  List<Object?> get props => [weekStart];
}
