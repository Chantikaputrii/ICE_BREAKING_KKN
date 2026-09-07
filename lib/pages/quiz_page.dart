import 'package:flutter/material.dart';

import '../data/question_bank.dart';
import '../models/question.dart';
import 'result_page.dart';

class QuizPage extends StatefulWidget {
  final int grade;
  final String? subject;
  final ValueChanged<int> onFinished;

  const QuizPage({
    super.key,
    required this.grade,
    required this.onFinished,
    this.subject,
  });

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late List<Question> questions;

  int currentQuestion = 0;
  int score = 0;
  int? selectedAnswer;
  bool answered = false;

  @override
  void initState() {
    super.initState();

    final allQuestions =
        questionsByGrade[widget.grade] ?? [];

    if (widget.subject == null) {
      questions = [...allQuestions];
      questions.shuffle();
    } else {
      questions = allQuestions
          .where(
            (question) =>
                question.subject == widget.subject,
          )
          .toList();
    }
  }

  void chooseAnswer(int index) {
    if (answered) return;

    setState(() {
      selectedAnswer = index;
      answered = true;

      if (index == questions[currentQuestion].answer) {
        score += 10;
      }
    });
  }

  void nextQuestion() {
    if (!answered) return;

    if (currentQuestion ==
        questions.length - 1) {
      widget.onFinished(score);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultPage(
            grade: widget.grade,
            score: score,
            total: questions.length * 10,
          ),
        ),
      );
    } else {
      setState(() {
        currentQuestion++;
        selectedAnswer = null;
        answered = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Kuis'),
        ),
        body: const Center(
          child: Text(
            'Soal untuk mata pelajaran ini belum tersedia.',
          ),
        ),
      );
    }

    final question =
        questions[currentQuestion];

    final progress =
        (currentQuestion + 1) / questions.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kuis Kelas ${widget.grade} SD',
        ),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              // PROGRESS
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(20),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${currentQuestion + 1}/${questions.length}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // PERTANYAAN
              AnimatedContainer(
                duration:
                    const Duration(milliseconds: 300),
                width: double.infinity,
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFFFD85C),
                      Color(0xFFFFB65C),
                    ],
                  ),
                  borderRadius:
                      BorderRadius.circular(28),
                ),
                child: Column(
                  children: [
                    Text(
                      question.subject,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF745300),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      question.question,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // JAWABAN
              ...List.generate(
                question.options.length,
                (index) {
                  final correct =
                      index == question.answer;

                  final selected =
                      index == selectedAnswer;

                  final showCorrect =
                      answered && correct;

                  final showWrong =
                      answered &&
                          selected &&
                          !correct;

                  return GestureDetector(
                    onTap: () => chooseAnswer(index),
                    child: AnimatedContainer(
                      duration:
                          const Duration(milliseconds: 250),
                      width: double.infinity,
                      margin:
                          const EdgeInsets.only(bottom: 13),
                      padding:
                          const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: showCorrect
                            ? const Color(0xFFE0F7E8)
                            : showWrong
                                ? const Color(0xFFFFE3E3)
                                : Colors.white,
                        borderRadius:
                            BorderRadius.circular(18),
                        border: Border.all(
                          color: showCorrect
                              ? Colors.green
                              : showWrong
                                  ? Colors.red
                                  : const Color(
                                      0xFFE0E6F2,
                                    ),
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor:
                                showCorrect
                                    ? Colors.green
                                    : showWrong
                                        ? Colors.red
                                        : const Color(
                                            0xFFEAF0FF,
                                          ),
                            child: Text(
                              String.fromCharCode(
                                65 + index,
                              ),
                              style: TextStyle(
                                color:
                                    showCorrect ||
                                            showWrong
                                        ? Colors.white
                                        : const Color(
                                            0xFF4F7DF3,
                                          ),
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Text(
                              question.options[index],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),
                          ),
                          if (showCorrect)
                            const Text('🎉'),

                          if (showWrong)
                            const Text('😅'),
                        ],
                      ),
                    ),
                  );
                },
              ),

              // FEEDBACK
              if (answered)
                AnimatedSwitcher(
                  duration:
                      const Duration(milliseconds: 300),
                  child: Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Text(
                          selectedAnswer ==
                                  question.answer
                              ? '🎉'
                              : '💡',
                          style:
                              const TextStyle(fontSize: 30),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            selectedAnswer ==
                                    question.answer
                                ? 'Jawaban benar! ${question.explanation}'
                                : 'Belum tepat. ${question.explanation}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 20),

              // NEXT
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      answered ? nextQuestion : null,
                  style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(
                      vertical: 17,
                    ),
                    backgroundColor:
                        const Color(0xFF4F7DF3),
                    foregroundColor: Colors.white,
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(18),
                    ),
                  ),
                  child: Text(
                    currentQuestion ==
                            questions.length - 1
                        ? 'Lihat Nilai 🏆'
                        : 'Soal Berikutnya ➜',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =====================================================
// RESULT PAGE
// =====================================================
