import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../data/question_bank.dart';
import '../models/question.dart';
import '../services/animated_question_api.dart';
import 'result_page.dart';

class QuizPage extends StatefulWidget {
  final int grade;
  final String? subject;
  final Future<void> Function(int score, int total) onFinished;
  final String studentName;
  final List<Question>? questions;

  const QuizPage({
    super.key,
    required this.grade,
    required this.onFinished,
    required this.studentName,
    this.questions,
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
  bool timedOut = false;
  int secondsRemaining = 15;
  Timer? _timer;
  Map<String, String> _remoteVisuals = {};

  @override
  void initState() {
    super.initState();

    final allQuestions = widget.questions ?? questionsByGrade[widget.grade] ?? [];

    if (widget.questions != null) {
      questions = _shuffleQuestions(widget.questions!);
    } else if (widget.subject == null) {
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
    _startTimer();
    _loadRemoteVisuals();
  }

  Future<void> _loadRemoteVisuals() async {
    final visuals = await AnimatedQuestionApi().loadVisuals(
      questions.where((question) => question.isAnimated).map((q) => q.id).toList(),
    );
    if (mounted && visuals.isNotEmpty) setState(() => _remoteVisuals = visuals);
  }

  void _startTimer() {
    _timer?.cancel();
    secondsRemaining = 15;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted || answered) return;
      if (secondsRemaining <= 1) {
        timer.cancel();
        setState(() {
          secondsRemaining = 0;
          answered = true;
          timedOut = true;
        });
      } else {
        setState(() => secondsRemaining--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  List<Question> _shuffleQuestions(List<Question> source) {
    final random = Random();
    final shuffled = source.map((question) {
      final options = [...question.options]..shuffle(random);
      return question.withOptions(options);
    }).toList();
    shuffled.shuffle(random);
    return shuffled;
  }

  void chooseAnswer(int index) {
    if (answered) return;
    _timer?.cancel();

    setState(() {
      selectedAnswer = index;
      answered = true;
      timedOut = false;

      if (index == questions[currentQuestion].answer) {
        score += 10;
      }
    });
  }

  Future<void> nextQuestion() async {
    if (!answered) return;

    if (currentQuestion ==
        questions.length - 1) {
      await widget.onFinished(score, questions.length * 10);
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultPage(
            grade: widget.grade,
            score: score,
            total: questions.length * 10,
            studentName: widget.studentName,
          ),
        ),
      );
    } else {
      setState(() {
        currentQuestion++;
        selectedAnswer = null;
        answered = false;
        timedOut = false;
      });
      _startTimer();
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

              const SizedBox(height: 14),

              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                decoration: BoxDecoration(
                  color: secondsRemaining <= 5
                      ? const Color(0xFFFFE4E4)
                      : const Color(0xFFEAF0FF),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      color: secondsRemaining <= 5 ? Colors.red : const Color(0xFF4F7DF3),
                    ),
                    const SizedBox(width: 7),
                    Text(
                      '$secondsRemaining detik',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
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
                    if (question.visual != null)
                      _QuestionVisual(
                        visual: question.visual!,
                        isAnimated: question.isAnimated,
                        remoteImageUrl: _remoteVisuals[question.id],
                      ),
                    if (question.visual != null) const SizedBox(height: 10),
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
                      color: selectedAnswer == question.answer
                          ? const Color(0xFFE0F7E8)
                          : const Color(0xFFFFE3E3),
                      borderRadius:
                          BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        _AnswerStatusIcon(
                          isCorrect: selectedAnswer == question.answer,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            selectedAnswer == question.answer
                                ? 'Jawaban benar! ${question.explanation}'
                                : timedOut
                                    ? 'Waktu habis. Jawaban yang benar adalah “${question.options[question.answer]}”. ${question.explanation}'
                                    : 'Belum tepat. Jawaban yang benar adalah “${question.options[question.answer]}”. ${question.explanation}',
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

class _QuestionVisual extends StatelessWidget {
  const _QuestionVisual({
    required this.visual,
    required this.isAnimated,
    this.remoteImageUrl,
  });

  final String visual;
  final bool isAnimated;
  final String? remoteImageUrl;

  @override
  Widget build(BuildContext context) {
    if (remoteImageUrl != null) {
      return Image.network(
        remoteImageUrl!,
        height: 76,
        errorBuilder: (_, __, ___) => Text(
          visual,
          style: const TextStyle(fontSize: 42),
        ),
      );
    }
    if (!isAnimated) return Text(visual, style: const TextStyle(fontSize: 42));
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: .8, end: 1),
      duration: const Duration(milliseconds: 650),
      curve: Curves.elasticOut,
      builder: (context, value, child) => Transform.scale(scale: value, child: child),
      child: Text(visual, style: const TextStyle(fontSize: 48)),
    );
  }
}

class _AnswerStatusIcon extends StatelessWidget {
  const _AnswerStatusIcon({required this.isCorrect});

  final bool isCorrect;

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
        tween: Tween(begin: .3, end: 1),
        duration: const Duration(milliseconds: 420),
        curve: Curves.elasticOut,
        builder: (context, value, child) => Transform.scale(
          scale: value,
          child: child,
        ),
        child: Icon(
          isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
          color: isCorrect ? Colors.green : Colors.red,
          size: 42,
        ),
      );

// =====================================================
// RESULT PAGE
// =====================================================
}