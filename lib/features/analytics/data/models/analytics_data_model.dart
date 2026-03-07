import 'dart:convert';

import 'package:flashcard/core/utils/typedefs.dart';
import 'package:flashcard/features/analytics/domain/entities/analytics_data.dart';

class AnalyticsDataModel extends AnalyticsData {
  const AnalyticsDataModel({
    required super.date,
    super.totalFocusMinutes,
    super.pomodorosCompleted,
    super.tasksCompleted,
    super.distractionCount,
    super.productivityScore,
  });

  factory AnalyticsDataModel.fromMap(DataMap map) {
    return AnalyticsDataModel(
      date: DateTime.parse(map['date'] as String),
      totalFocusMinutes: map['totalFocusMinutes'] as int? ?? 0,
      pomodorosCompleted: map['pomodorosCompleted'] as int? ?? 0,
      tasksCompleted: map['tasksCompleted'] as int? ?? 0,
      distractionCount: map['distractionCount'] as int? ?? 0,
      productivityScore: (map['productivityScore'] as num?)?.toDouble() ?? 0.0,
    );
  }

  factory AnalyticsDataModel.fromJson(String source) =>
      AnalyticsDataModel.fromMap(json.decode(source) as DataMap);

  DataMap toMap() {
    return {
      'date': date.toIso8601String(),
      'totalFocusMinutes': totalFocusMinutes,
      'pomodorosCompleted': pomodorosCompleted,
      'tasksCompleted': tasksCompleted,
      'distractionCount': distractionCount,
      'productivityScore': productivityScore,
    };
  }

  String toJson() => json.encode(toMap());
}
