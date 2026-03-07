import 'package:equatable/equatable.dart';
import 'package:flashcard/features/analytics/domain/entities/analytics_data.dart';

abstract class AnalyticsState extends Equatable {
  const AnalyticsState();

  @override
  List<Object?> get props => [];
}

class AnalyticsInitial extends AnalyticsState {
  const AnalyticsInitial();
}

class AnalyticsLoading extends AnalyticsState {
  const AnalyticsLoading();
}

class DailyAnalyticsLoaded extends AnalyticsState {
  final AnalyticsData data;

  const DailyAnalyticsLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class WeeklyAnalyticsLoaded extends AnalyticsState {
  final WeeklyAnalytics data;

  const WeeklyAnalyticsLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class AnalyticsError extends AnalyticsState {
  final String message;

  const AnalyticsError(this.message);

  @override
  List<Object?> get props => [message];
}
