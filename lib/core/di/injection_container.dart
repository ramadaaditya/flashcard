import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'package:flashcard/core/network/network_info.dart';

// Auth
import 'package:flashcard/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:flashcard/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:flashcard/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flashcard/features/auth/domain/repositories/auth_repository.dart';
import 'package:flashcard/features/auth/domain/usecases/get_current_user.dart';
import 'package:flashcard/features/auth/domain/usecases/sign_in.dart';
import 'package:flashcard/features/auth/domain/usecases/sign_out.dart';
import 'package:flashcard/features/auth/domain/usecases/sign_up.dart';
import 'package:flashcard/features/auth/presentation/bloc/auth_bloc.dart';

// Pomodoro
import 'package:flashcard/features/pomodoro/data/datasources/pomodoro_local_datasource.dart';
import 'package:flashcard/features/pomodoro/data/repositories/pomodoro_repository_impl.dart';
import 'package:flashcard/features/pomodoro/domain/repositories/pomodoro_repository.dart';
import 'package:flashcard/features/pomodoro/domain/usecases/complete_pomodoro.dart';
import 'package:flashcard/features/pomodoro/domain/usecases/get_pomodoro_settings.dart';
import 'package:flashcard/features/pomodoro/domain/usecases/start_pomodoro.dart';
import 'package:flashcard/features/pomodoro/presentation/bloc/pomodoro_bloc.dart';

// Tasks
import 'package:flashcard/features/task_management/data/datasources/task_local_datasource.dart';
import 'package:flashcard/features/task_management/data/repositories/task_repository_impl.dart';
import 'package:flashcard/features/task_management/domain/repositories/task_repository.dart';
import 'package:flashcard/features/task_management/domain/usecases/create_task.dart';
import 'package:flashcard/features/task_management/domain/usecases/delete_task.dart';
import 'package:flashcard/features/task_management/domain/usecases/get_tasks.dart';
import 'package:flashcard/features/task_management/domain/usecases/update_task.dart';
import 'package:flashcard/features/task_management/presentation/bloc/task_bloc.dart';

// Focus Session
import 'package:flashcard/features/focus_session/data/datasources/focus_session_local_datasource.dart';
import 'package:flashcard/features/focus_session/data/repositories/focus_session_repository_impl.dart';
import 'package:flashcard/features/focus_session/domain/repositories/focus_session_repository.dart';
import 'package:flashcard/features/focus_session/domain/usecases/end_focus_session.dart';
import 'package:flashcard/features/focus_session/domain/usecases/get_focus_sessions.dart';
import 'package:flashcard/features/focus_session/domain/usecases/start_focus_session.dart';
import 'package:flashcard/features/focus_session/presentation/bloc/focus_session_bloc.dart';

// Analytics
import 'package:flashcard/features/analytics/data/datasources/analytics_local_datasource.dart';
import 'package:flashcard/features/analytics/data/repositories/analytics_repository_impl.dart';
import 'package:flashcard/features/analytics/domain/repositories/analytics_repository.dart';
import 'package:flashcard/features/analytics/domain/usecases/get_daily_stats.dart';
import 'package:flashcard/features/analytics/domain/usecases/get_weekly_stats.dart';
import 'package:flashcard/features/analytics/presentation/bloc/analytics_bloc.dart';

// Cloud Sync
import 'package:flashcard/features/cloud_sync/data/datasources/sync_local_datasource.dart';
import 'package:flashcard/features/cloud_sync/data/repositories/sync_repository_impl.dart';
import 'package:flashcard/features/cloud_sync/domain/repositories/sync_repository.dart';
import 'package:flashcard/features/cloud_sync/domain/usecases/get_sync_status.dart';
import 'package:flashcard/features/cloud_sync/domain/usecases/sync_data.dart';
import 'package:flashcard/features/cloud_sync/presentation/bloc/sync_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ─── External ──────────────────────────────────────────
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton(() => const Uuid());

  // ─── Core ──────────────────────────────────────────────
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl()),
  );

  // ─── Auth ──────────────────────────────────────────────
  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      signIn: sl(),
      signUp: sl(),
      signOut: sl(),
      getCurrentUser: sl(),
    ),
  );
  // Use cases
  sl.registerLazySingleton(() => SignIn(sl()));
  sl.registerLazySingleton(() => SignUp(sl()));
  sl.registerLazySingleton(() => SignOut(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));
  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sl()),
  );

  // ─── Pomodoro ──────────────────────────────────────────
  // Bloc
  sl.registerFactory(
    () => PomodoroBloc(
      startPomodoro: sl(),
      completePomodoro: sl(),
      getSettings: sl(),
    ),
  );
  // Use cases
  sl.registerLazySingleton(() => StartPomodoro(sl()));
  sl.registerLazySingleton(() => CompletePomodoro(sl()));
  sl.registerLazySingleton(() => GetPomodoroSettings(sl()));
  // Repository
  sl.registerLazySingleton<PomodoroRepository>(
    () => PomodoroRepositoryImpl(localDataSource: sl(), uuid: sl()),
  );
  // Data sources
  sl.registerLazySingleton<PomodoroLocalDataSource>(
    () => PomodoroLocalDataSourceImpl(sl()),
  );

  // ─── Task Management ──────────────────────────────────
  // Bloc
  sl.registerFactory(
    () => TaskBloc(
      createTask: sl(),
      getTasks: sl(),
      updateTask: sl(),
      deleteTask: sl(),
    ),
  );
  // Use cases
  sl.registerLazySingleton(() => CreateTask(sl()));
  sl.registerLazySingleton(() => GetTasks(sl()));
  sl.registerLazySingleton(() => UpdateTask(sl()));
  sl.registerLazySingleton(() => DeleteTask(sl()));
  // Repository
  sl.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(localDataSource: sl()),
  );
  // Data sources
  sl.registerLazySingleton<TaskLocalDataSource>(
    () => TaskLocalDataSourceImpl(sl()),
  );

  // ─── Focus Session ────────────────────────────────────
  // Bloc
  sl.registerFactory(
    () => FocusSessionBloc(
      startFocusSession: sl(),
      endFocusSession: sl(),
      getFocusSessions: sl(),
    ),
  );
  // Use cases
  sl.registerLazySingleton(() => StartFocusSession(sl()));
  sl.registerLazySingleton(() => EndFocusSession(sl()));
  sl.registerLazySingleton(() => GetFocusSessions(sl()));
  // Repository
  sl.registerLazySingleton<FocusSessionRepository>(
    () => FocusSessionRepositoryImpl(localDataSource: sl(), uuid: sl()),
  );
  // Data sources
  sl.registerLazySingleton<FocusSessionLocalDataSource>(
    () => FocusSessionLocalDataSourceImpl(sl()),
  );

  // ─── Analytics ─────────────────────────────────────────
  // Bloc
  sl.registerFactory(
    () => AnalyticsBloc(
      getDailyStats: sl(),
      getWeeklyStats: sl(),
    ),
  );
  // Use cases
  sl.registerLazySingleton(() => GetDailyStats(sl()));
  sl.registerLazySingleton(() => GetWeeklyStats(sl()));
  // Repository
  sl.registerLazySingleton<AnalyticsRepository>(
    () => AnalyticsRepositoryImpl(localDataSource: sl()),
  );
  // Data sources
  sl.registerLazySingleton<AnalyticsLocalDataSource>(
    () => AnalyticsLocalDataSourceImpl(sl()),
  );

  // ─── Cloud Sync ────────────────────────────────────────
  // Bloc
  sl.registerFactory(
    () => SyncBloc(
      syncData: sl(),
      getSyncStatus: sl(),
    ),
  );
  // Use cases
  sl.registerLazySingleton(() => SyncData(sl()));
  sl.registerLazySingleton(() => GetSyncStatus(sl()));
  // Repository
  sl.registerLazySingleton<SyncRepository>(
    () => SyncRepositoryImpl(localDataSource: sl(), networkInfo: sl()),
  );
  // Data sources
  sl.registerLazySingleton<SyncLocalDataSource>(
    () => SyncLocalDataSourceImpl(sl()),
  );
}
