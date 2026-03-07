import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flashcard/features/focus_session/presentation/bloc/focus_session_bloc.dart';
import 'package:flashcard/features/focus_session/presentation/bloc/focus_session_event.dart';
import 'package:flashcard/features/focus_session/presentation/bloc/focus_session_state.dart';

class FocusSessionPage extends StatelessWidget {
  const FocusSessionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Focus Sessions')),
      body: BlocBuilder<FocusSessionBloc, FocusSessionState>(
        builder: (context, state) {
          if (state is FocusSessionLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is FocusSessionActive) {
            return _ActiveSessionView(
              sessionId: state.session.id,
              taskTitle: state.session.taskTitle,
              startTime: state.session.startTime,
            );
          }
          if (state is FocusSessionsLoaded) {
            if (state.sessions.isEmpty) {
              return _NoSessionsView();
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.sessions.length,
              itemBuilder: (context, index) {
                final session = state.sessions[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Icon(
                      session.isActive ? Icons.play_circle : Icons.check_circle,
                      color: session.isActive ? Colors.green : Colors.grey,
                    ),
                    title: Text(session.taskTitle ?? 'Free Focus'),
                    subtitle: Text(
                      '${session.actualDurationMinutes} min • '
                      '${session.pomodorosCompleted} pomodoros • '
                      '${session.distractionCount} distractions',
                    ),
                    trailing: Text(
                      _formatDate(session.startTime),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                );
              },
            );
          }
          return _NoSessionsView();
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}

class _ActiveSessionView extends StatelessWidget {
  final String sessionId;
  final String? taskTitle;
  final DateTime startTime;

  const _ActiveSessionView({
    required this.sessionId,
    this.taskTitle,
    required this.startTime,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.visibility,
            size: 64,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 24),
          Text(
            'Focusing on:',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            taskTitle ?? 'Free Focus',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 48),
          FilledButton.icon(
            onPressed: () {
              context.read<FocusSessionBloc>().add(
                    EndFocusSessionEvent(sessionId: sessionId),
                  );
            },
            icon: const Icon(Icons.stop),
            label: const Text('End Session'),
          ),
        ],
      ),
    );
  }
}

class _NoSessionsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.self_improvement, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('No focus sessions yet'),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () {
              context.read<FocusSessionBloc>().add(
                    const StartFocusSessionEvent(),
                  );
            },
            icon: const Icon(Icons.play_arrow),
            label: const Text('Start Focus Session'),
          ),
        ],
      ),
    );
  }
}
