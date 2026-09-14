import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

import '../data/question_bank.dart';
import '../models/question.dart';

class QuestionSelectionService {
  static const int _questionsPerGame = 10;

  Future<List<Question>> selectQuestions({
    required int grade,
    required String studentName,
    String? topic,
  }) async {
    final allQuestions =
        List<Question>.from(
      questionsByGrade[grade] ??
          const <Question>[],
    );

    if (allQuestions.isEmpty) {
      return [];
    }

    final preferences =
        await SharedPreferences.getInstance();

    final normalizedTopic =
        topic == null ||
                topic.trim().isEmpty
            ? 'umum'
            : topic
                .trim()
                .toLowerCase()
                .replaceAll(
                  ' ',
                  '_',
                );

    final now = DateTime.now();

    final storageKey =
        'used_questions_'
        '${grade}_'
        '${normalizedTopic}_'
        '${now.year}_'
        '${now.month}_'
        '${now.day}';

    var usedIds =
        preferences.getStringList(
              storageKey,
            ) ??
            <String>[];

    var available =
        allQuestions.where(
      (question) {
        return !usedIds.contains(
          question.id,
        );
      },
    ).toList();

    // Jika jumlah soal yang tersisa kurang
    // dari jumlah soal yang dibutuhkan,
    // mulai kembali dari seluruh bank soal.
    if (available.length <
        _questionsPerGame) {
      usedIds = [];
      available =
          List<Question>.from(
        allQuestions,
      );
    }

    final random = Random(
      DateTime.now()
              .microsecondsSinceEpoch ^
          studentName.hashCode ^
          grade ^
          normalizedTopic.hashCode,
    );

    available.shuffle(random);

    final selected =
        available.take(
      min(
        _questionsPerGame,
        available.length,
      ),
    ).toList();

    await preferences.setStringList(
      storageKey,
      [
        ...usedIds,
        ...selected.map(
          (question) => question.id,
        ),
      ],
    );

    return selected;
  }
}