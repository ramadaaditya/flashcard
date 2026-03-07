import 'dart:convert';

import 'package:flashcard/core/constants/app_constants.dart';
import 'package:flashcard/core/error/exceptions.dart';
import 'package:flashcard/features/pomodoro/data/models/pomodoro_session_model.dart';
import 'package:flashcard/features/pomodoro/domain/entities/pomodoro_session.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PomodoroLocalDataSource {
  Future<void> saveSession(PomodoroSessionModel session);
  Future<List<PomodoroSessionModel>> getSessions();
  Future<PomodoroSettings> getSettings();
  Future<void> saveSettings(PomodoroSettings settings);
}

class PomodoroLocalDataSourceImpl implements PomodoroLocalDataSource {
  final SharedPreferences sharedPreferences;

  PomodoroLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> saveSession(PomodoroSessionModel session) async {
    final sessions = await getSessions();
    sessions.add(session);
    final encoded = json.encode(sessions.map((s) => s.toMap()).toList());
    await sharedPreferences.setString(AppConstants.pomodoroBox, encoded);
  }

  @override
  Future<List<PomodoroSessionModel>> getSessions() async {
    final jsonString = sharedPreferences.getString(AppConstants.pomodoroBox);
    if (jsonString == null) return [];
    try {
      final List<dynamic> decoded = json.decode(jsonString);
      return decoded
          .map((e) => PomodoroSessionModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      throw const CacheException('Failed to parse pomodoro sessions');
    }
  }

  @override
  Future<PomodoroSettings> getSettings() async {
    final jsonString =
        sharedPreferences.getString(AppConstants.pomodoroSettingsKey);
    if (jsonString == null) return const PomodoroSettings();
    try {
      final map = json.decode(jsonString) as Map<String, dynamic>;
      return PomodoroSettings(
        workDuration: map['workDuration'] as int? ?? 25,
        shortBreakDuration: map['shortBreakDuration'] as int? ?? 5,
        longBreakDuration: map['longBreakDuration'] as int? ?? 15,
        sessionsBeforeLongBreak: map['sessionsBeforeLongBreak'] as int? ?? 4,
      );
    } catch (_) {
      return const PomodoroSettings();
    }
  }

  @override
  Future<void> saveSettings(PomodoroSettings settings) async {
    final map = {
      'workDuration': settings.workDuration,
      'shortBreakDuration': settings.shortBreakDuration,
      'longBreakDuration': settings.longBreakDuration,
      'sessionsBeforeLongBreak': settings.sessionsBeforeLongBreak,
    };
    await sharedPreferences.setString(
      AppConstants.pomodoroSettingsKey,
      json.encode(map),
    );
  }
}
