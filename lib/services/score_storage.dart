import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/score_record.dart';

class ScoreStorage {
  static const _storageKey = 'score_records';

  Future<List<ScoreRecord>> loadRecords({int? grade}) async {
    final preferences = await SharedPreferences.getInstance();
    final rawRecords = preferences.getStringList(_storageKey) ?? [];
    final records = rawRecords
        .map((raw) => ScoreRecord.fromJson(jsonDecode(raw) as Map<String, dynamic>))
        .where((record) => grade == null || record.grade == grade)
        .toList();
    records.sort((a, b) {
      final scoreComparison = b.percentage.compareTo(a.percentage);
      return scoreComparison != 0
          ? scoreComparison
          : a.completedAt.compareTo(b.completedAt);
    });
    return records;
  }

  Future<void> saveRecord(ScoreRecord record) async {
    final preferences = await SharedPreferences.getInstance();
    final records = preferences.getStringList(_storageKey) ?? [];
    await preferences.setStringList(_storageKey, [
      ...records,
      jsonEncode(record.toJson()),
    ]);
  }

  Future<void> resetTodayForGrade(int grade) async {
    final preferences = await SharedPreferences.getInstance();
    final records = await loadRecords();
    final now = DateTime.now();
    final remaining = records.where((record) {
      final isToday = record.completedAt.year == now.year &&
          record.completedAt.month == now.month &&
          record.completedAt.day == now.day;
      return record.grade != grade || !isToday;
    });
    await preferences.setStringList(
      _storageKey,
      remaining.map((record) => jsonEncode(record.toJson())).toList(),
    );
  }
}
