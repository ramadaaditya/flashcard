class AppConstants {
  AppConstants._();

  static const String appName = 'Flashcard';

  // Pomodoro defaults
  static const int defaultWorkDuration = 25; // minutes
  static const int defaultShortBreakDuration = 5; // minutes
  static const int defaultLongBreakDuration = 15; // minutes
  static const int defaultSessionsBeforeLongBreak = 4;

  // Storage keys
  static const String onboardingCompleteKey = 'onboarding_complete';
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String pomodoroSettingsKey = 'pomodoro_settings';
  static const String lastSyncKey = 'last_sync';

  // Hive boxes
  static const String tasksBox = 'tasks_box';
  static const String focusSessionsBox = 'focus_sessions_box';
  static const String analyticsBox = 'analytics_box';
  static const String pomodoroBox = 'pomodoro_box';
}
