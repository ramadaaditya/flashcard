import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flashcard/features/analytics/domain/usecases/get_daily_stats.dart';
import 'package:flashcard/features/analytics/domain/usecases/get_weekly_stats.dart';
import 'package:flashcard/features/analytics/presentation/bloc/analytics_event.dart';
import 'package:flashcard/features/analytics/presentation/bloc/analytics_state.dart';

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final GetDailyStats _getDailyStats;
  final GetWeeklyStats _getWeeklyStats;

  AnalyticsBloc({
    required GetDailyStats getDailyStats,
    required GetWeeklyStats getWeeklyStats,
  })  : _getDailyStats = getDailyStats,
        _getWeeklyStats = getWeeklyStats,
        super(const AnalyticsInitial()) {
    on<LoadDailyAnalytics>(_onLoadDaily);
    on<LoadWeeklyAnalytics>(_onLoadWeekly);
  }

  Future<void> _onLoadDaily(
    LoadDailyAnalytics event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(const AnalyticsLoading());
    final result = await _getDailyStats(event.date);
    result.fold(
      (failure) => emit(AnalyticsError(failure.message)),
      (data) => emit(DailyAnalyticsLoaded(data)),
    );
  }

  Future<void> _onLoadWeekly(
    LoadWeeklyAnalytics event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(const AnalyticsLoading());
    final result = await _getWeeklyStats(event.weekStart);
    result.fold(
      (failure) => emit(AnalyticsError(failure.message)),
      (data) => emit(WeeklyAnalyticsLoaded(data)),
    );
  }
}
