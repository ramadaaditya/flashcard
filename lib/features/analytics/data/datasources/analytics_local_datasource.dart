import 'dart:convert';

import 'package:flashcard/core/constants/app_constants.dart';
import 'package:flashcard/core/error/exceptions.dart';
import 'package:flashcard/features/analytics/data/models/analytics_data_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AnalyticsLocalDataSource {
  Future<List<AnalyticsDataModel>> getAnalytics();
  Future<void> saveAnalyticsEntry(AnalyticsDataModel entry);
  Future<void> saveAllAnalytics(List<AnalyticsDataModel> entries);
}

class AnalyticsLocalDataSourceImpl implements AnalyticsLocalDataSource {
  final SharedPreferences sharedPreferences;

  AnalyticsLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<List<AnalyticsDataModel>> getAnalytics() async {
    final jsonString = sharedPreferences.getString(AppConstants.analyticsBox);
    if (jsonString == null) return [];
    try {
      final List<dynamic> decoded = json.decode(jsonString);
      return decoded
          .map((e) => AnalyticsDataModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      throw const CacheException('Failed to parse analytics data');
    }
  }

  @override
  Future<void> saveAnalyticsEntry(AnalyticsDataModel entry) async {
    final entries = await getAnalytics();
    final dateKey =
        '${entry.date.year}-${entry.date.month}-${entry.date.day}';
    final index = entries.indexWhere((e) {
      final eKey = '${e.date.year}-${e.date.month}-${e.date.day}';
      return eKey == dateKey;
    });
    if (index >= 0) {
      entries[index] = entry;
    } else {
      entries.add(entry);
    }
    await saveAllAnalytics(entries);
  }

  @override
  Future<void> saveAllAnalytics(List<AnalyticsDataModel> entries) async {
    final encoded = json.encode(entries.map((e) => e.toMap()).toList());
    await sharedPreferences.setString(AppConstants.analyticsBox, encoded);
  }
}
