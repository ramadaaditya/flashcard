import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flashcard/features/analytics/presentation/bloc/analytics_bloc.dart';
import 'package:flashcard/features/analytics/presentation/bloc/analytics_event.dart';
import 'package:flashcard/features/analytics/presentation/bloc/analytics_state.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  @override
  void initState() {
    super.initState();
    _loadAnalytics();
  }

  void _loadAnalytics() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    context.read<AnalyticsBloc>().add(LoadWeeklyAnalytics(weekStart));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: BlocBuilder<AnalyticsBloc, AnalyticsState>(
        builder: (context, state) {
          if (state is AnalyticsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is WeeklyAnalyticsLoaded) {
            return _WeeklyStatsView(data: state.data);
          }
          if (state is DailyAnalyticsLoaded) {
            return _DailyStatsView(data: state.data);
          }
          if (state is AnalyticsError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('No analytics data yet'));
        },
      ),
    );
  }
}

class _WeeklyStatsView extends StatelessWidget {
  final dynamic data;

  const _WeeklyStatsView({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('This Week', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.timer,
                  label: 'Focus Time',
                  value: '${data.totalFocusMinutes} min',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  icon: Icons.local_fire_department,
                  label: 'Pomodoros',
                  value: '${data.totalPomodoros}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.task_alt,
                  label: 'Tasks Done',
                  value: '${data.totalTasksCompleted}',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  icon: Icons.trending_up,
                  label: 'Avg Score',
                  value: data.averageProductivityScore.toStringAsFixed(1),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DailyStatsView extends StatelessWidget {
  final dynamic data;

  const _DailyStatsView({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Today', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 24),
          _StatCard(
            icon: Icons.timer,
            label: 'Focus Time',
            value: '${data.totalFocusMinutes} min',
          ),
          const SizedBox(height: 12),
          _StatCard(
            icon: Icons.local_fire_department,
            label: 'Pomodoros',
            value: '${data.pomodorosCompleted}',
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 8),
            Text(value, style: Theme.of(context).textTheme.headlineSmall),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
