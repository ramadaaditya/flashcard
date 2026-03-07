import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flashcard/core/di/injection_container.dart' as di;
import 'package:flashcard/core/router/app_router.dart';
import 'package:flashcard/core/theme/app_theme.dart';

import 'package:flashcard/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flashcard/features/pomodoro/presentation/bloc/pomodoro_bloc.dart';
import 'package:flashcard/features/pomodoro/presentation/bloc/pomodoro_event.dart';
import 'package:flashcard/features/task_management/presentation/bloc/task_bloc.dart';
import 'package:flashcard/features/task_management/presentation/bloc/task_event.dart';
import 'package:flashcard/features/focus_session/presentation/bloc/focus_session_bloc.dart';
import 'package:flashcard/features/focus_session/presentation/bloc/focus_session_event.dart';
import 'package:flashcard/features/analytics/presentation/bloc/analytics_bloc.dart';
import 'package:flashcard/features/cloud_sync/presentation/bloc/sync_bloc.dart';
import 'package:flashcard/features/cloud_sync/presentation/bloc/sync_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const FlashcardApp());
}

class FlashcardApp extends StatelessWidget {
  const FlashcardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<AuthBloc>()),
        BlocProvider(
          create: (_) =>
              di.sl<PomodoroBloc>()..add(const LoadPomodoroSettings()),
        ),
        BlocProvider(
          create: (_) => di.sl<TaskBloc>()..add(const LoadTasks()),
        ),
        BlocProvider(
          create: (_) =>
              di.sl<FocusSessionBloc>()..add(const LoadFocusSessions()),
        ),
        BlocProvider(create: (_) => di.sl<AnalyticsBloc>()),
        BlocProvider(
          create: (_) => di.sl<SyncBloc>()..add(const CheckSyncStatus()),
        ),
      ],
      child: MaterialApp.router(
        title: 'Flashcard',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
