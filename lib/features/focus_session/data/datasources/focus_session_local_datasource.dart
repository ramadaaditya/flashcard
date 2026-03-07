import 'dart:convert';

import 'package:flashcard/core/constants/app_constants.dart';
import 'package:flashcard/core/error/exceptions.dart';
import 'package:flashcard/features/focus_session/data/models/focus_session_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class FocusSessionLocalDataSource {
  Future<List<FocusSessionModel>> getSessions();
  Future<void> saveSession(FocusSessionModel session);
  Future<void> saveSessions(List<FocusSessionModel> sessions);
}

class FocusSessionLocalDataSourceImpl implements FocusSessionLocalDataSource {
  final SharedPreferences sharedPreferences;

  FocusSessionLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<List<FocusSessionModel>> getSessions() async {
    final jsonString =
        sharedPreferences.getString(AppConstants.focusSessionsBox);
    if (jsonString == null) return [];
    try {
      final List<dynamic> decoded = json.decode(jsonString);
      return decoded
          .map((e) => FocusSessionModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      throw const CacheException('Failed to parse focus sessions');
    }
  }

  @override
  Future<void> saveSession(FocusSessionModel session) async {
    final sessions = await getSessions();
    final index = sessions.indexWhere((s) => s.id == session.id);
    if (index >= 0) {
      sessions[index] = session;
    } else {
      sessions.add(session);
    }
    await saveSessions(sessions);
  }

  @override
  Future<void> saveSessions(List<FocusSessionModel> sessions) async {
    final encoded = json.encode(sessions.map((s) => s.toMap()).toList());
    await sharedPreferences.setString(AppConstants.focusSessionsBox, encoded);
  }
}
