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
    final gradeQuestions =
        List<Question>.from(
      questionsByGrade[grade] ??
          const <Question>[],
    );

    if (gradeQuestions.isEmpty) {
      return [];
    }

    // Jika siswa memilih tema (mis. "Stop Bullying"),
    // utamakan soal dengan subject yang sama dengan tema
    // tersebut. Kalau belum ada soal untuk tema itu,
    // gunakan seluruh bank soal kelas ini sebagai cadangan
    // supaya siswa tetap bisa mengerjakan kuis.
    final topicMatches = topic == null ||
            topic.trim().isEmpty
        ? const <Question>[]
        : gradeQuestions
            .where(
              (question) =>
                  question.subject
                      .toLowerCase() ==
                  topic.trim().toLowerCase(),
            )
            .toList();

    final allQuestions =
        topicMatches.isNotEmpty
            ? topicMatches
            : gradeQuestions;

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