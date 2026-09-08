import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

import '../data/question_bank.dart';
import '../models/question.dart';

class QuestionSelectionService {
  static const _questionsPerGame = 10;

  Future<List<Question>> selectQuestions({
    required int grade,
    required String studentName,
  }) async {
    final questions = questionsByGrade[grade] ?? [];
    final preferences = await SharedPreferences.getInstance();
    final key = 'used_questions_${grade}_${_dayKey(DateTime.now())}';
    var usedIds = preferences.getStringList(key) ?? [];
    var available = questions.where((question) => !usedIds.contains(question.id)).toList();

    // Setelah 50 soal digunakan, satu putaran baru dimulai untuk kelas itu.
    if (available.length < _questionsPerGame) {
      usedIds = [];
      available = [...questions];
    }

    final random = Random(DateTime.now().microsecondsSinceEpoch ^ studentName.hashCode);
    available.shuffle(random);
    final selected = available.take(_questionsPerGame).toList();
    await preferences.setStringList(key, [...usedIds, ...selected.map((q) => q.id)]);
    return selected;
  }

  String _dayKey(DateTime date) => '${date.year}-${date.month}-${date.day}';
}
