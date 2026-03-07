import 'package:flashcard/core/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SyncLocalDataSource {
  Future<DateTime?> getLastSyncTime();
  Future<void> saveLastSyncTime(DateTime time);
}

class SyncLocalDataSourceImpl implements SyncLocalDataSource {
  final SharedPreferences sharedPreferences;

  SyncLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<DateTime?> getLastSyncTime() async {
    final timestamp = sharedPreferences.getString(AppConstants.lastSyncKey);
    if (timestamp == null) return null;
    return DateTime.parse(timestamp);
  }

  @override
  Future<void> saveLastSyncTime(DateTime time) async {
    await sharedPreferences.setString(
      AppConstants.lastSyncKey,
      time.toIso8601String(),
    );
  }
}
