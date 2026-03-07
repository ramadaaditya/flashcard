import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flashcard/features/pomodoro/domain/entities/pomodoro_session.dart';
import 'package:flashcard/features/pomodoro/presentation/bloc/pomodoro_bloc.dart';
import 'package:flashcard/features/pomodoro/presentation/bloc/pomodoro_event.dart';
import 'package:flashcard/features/pomodoro/presentation/bloc/pomodoro_state.dart';

class PomodoroPage extends StatelessWidget {
  const PomodoroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pomodoro Timer')),
      body: BlocBuilder<PomodoroBloc, PomodoroState>(
        builder: (context, state) {
          final minutes = state.remainingSeconds ~/ 60;
          final seconds = state.remainingSeconds % 60;
          final progress = state.totalSeconds > 0
              ? state.remainingSeconds / state.totalSeconds
              : 1.0;

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Session type selector
                SegmentedButton<PomodoroType>(
                  segments: const [
                    ButtonSegment(
                      value: PomodoroType.work,
                      label: Text('Work'),
                    ),
                    ButtonSegment(
                      value: PomodoroType.shortBreak,
                      label: Text('Short Break'),
                    ),
                    ButtonSegment(
                      value: PomodoroType.longBreak,
                      label: Text('Long Break'),
                    ),
                  ],
                  selected: {state.currentType},
                  onSelectionChanged: state.status == TimerStatus.initial
                      ? (selected) {
                          // Reset with new type
                          context.read<PomodoroBloc>().add(
                                StartPomodoroTimer(type: selected.first),
                              );
                        }
                      : null,
                ),
                const SizedBox(height: 48),

                // Timer display
                SizedBox(
                  width: 250,
                  height: 250,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 8,
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                      ),
                      Center(
                        child: Text(
                          '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),

                // Controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (state.status == TimerStatus.initial ||
                        state.status == TimerStatus.completed)
                      FilledButton.icon(
                        onPressed: () {
                          context.read<PomodoroBloc>().add(
                                StartPomodoroTimer(type: state.currentType),
                              );
                        },
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Start'),
                      ),
                    if (state.status == TimerStatus.running)
                      FilledButton.icon(
                        onPressed: () {
                          context
                              .read<PomodoroBloc>()
                              .add(const PausePomodoroTimer());
                        },
                        icon: const Icon(Icons.pause),
                        label: const Text('Pause'),
                      ),
                    if (state.status == TimerStatus.paused) ...[
                      FilledButton.icon(
                        onPressed: () {
                          context
                              .read<PomodoroBloc>()
                              .add(const ResumePomodoroTimer());
                        },
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Resume'),
                      ),
                      const SizedBox(width: 16),
                      OutlinedButton.icon(
                        onPressed: () {
                          context
                              .read<PomodoroBloc>()
                              .add(const ResetPomodoroTimer());
                        },
                        icon: const Icon(Icons.stop),
                        label: const Text('Reset'),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 24),

                // Session counter
                Text(
                  'Sessions completed today: ${state.completedSessions}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
