import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

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

class _QuizPageState extends State<QuizPage>
    with SingleTickerProviderStateMixin {
  late List<Question> questions;

  int currentQuestion = 0;
  int score = 0;
  int? selectedAnswer;

  bool answered = false;
  bool timedOut = false;

  int secondsRemaining = 15;

  Timer? _timer;

  Map<String, String> _remoteVisuals = {};

  // ============================================================
  // ANIMASI JAWABAN
  // ============================================================

  bool _showAnswerAnimation = false;
  bool _lastAnswerCorrect = false;

  late AnimationController _feedbackController;
  late Animation<double> _feedbackScale;
  late Animation<double> _feedbackOpacity;

  final AudioPlayer _audioPlayer = AudioPlayer();

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    _feedbackController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _feedbackScale = CurvedAnimation(
      parent: _feedbackController,
      curve: Curves.elasticOut,
    );

    _feedbackOpacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _feedbackController,
        curve: Curves.easeOut,
      ),
    );

    unawaited(_audioPlayer.setReleaseMode(ReleaseMode.stop));

    final allQuestions =
        widget.questions ?? questionsByGrade[widget.grade] ?? [];

    if (widget.questions != null) {
      questions = _shuffleQuestions(widget.questions!);
    } else if (widget.subject == null) {
      questions = _shuffleQuestions(allQuestions);
    } else {
      final subjectQuestions = allQuestions
          .where((question) => question.subject == widget.subject)
          .toList();

      questions = _shuffleQuestions(subjectQuestions);
    }

    _startTimer();
    _loadRemoteVisuals();
  }

  // ============================================================
  // LOAD VISUAL API
  // ============================================================

  Future<void> _loadRemoteVisuals() async {
    if (questions.isEmpty) return;

    final visuals = await AnimatedQuestionApi().loadVisuals(
      questions
          .where((question) => question.isAnimated)
          .map((question) => question.id)
          .toList(),
    );

    if (!mounted) return;

    if (visuals.isNotEmpty) {
      setState(() {
        _remoteVisuals = visuals;
      });
    }
  }

  // ============================================================
  // TIMER
  // ============================================================

  void _startTimer() {
    _timer?.cancel();

    setState(() {
      secondsRemaining = 15;
    });

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (!mounted || answered) {
          timer.cancel();
          return;
        }

        if (secondsRemaining <= 1) {
          timer.cancel();

          setState(() {
            secondsRemaining = 0;
            answered = true;
            timedOut = true;
            selectedAnswer = null;
          });

          _showFeedback(false);
        } else {
          setState(() {
            secondsRemaining--;
          });
        }
      },
    );
  }

  // ============================================================
  // ACAK SOAL DAN PILIHAN JAWABAN
  // ============================================================

  List<Question> _shuffleQuestions(List<Question> source) {
    final random = Random();

    final shuffled = source.map((question) {
      final options = List<String>.from(question.options);

      options.shuffle(random);

      // Question.withOptions() sudah menghitung
      // ulang posisi jawaban yang benar.
      return question.withOptions(options);
    }).toList();

    shuffled.shuffle(random);

    return shuffled;
  }

  // ============================================================
  // PILIH JAWABAN
  // ============================================================

  void chooseAnswer(int index) {
    if (answered || _showAnswerAnimation) return;

    _timer?.cancel();

    final question = questions[currentQuestion];
    final correct = index == question.answer;

    setState(() {
      selectedAnswer = index;
      answered = true;
      timedOut = false;
      _lastAnswerCorrect = correct;

      if (correct) {
        score += 10;
      }
    });

    // Dipanggil langsung dari klik pengguna agar audio diizinkan browser web.
    unawaited(_playAnswerSound(correct));
    _showFeedback(correct);
  }

  // ============================================================
  // TAMPILKAN ANIMASI BENAR / SALAH
  // ============================================================

  Future<void> _showFeedback(bool correct) async {
    if (!mounted) return;

    setState(() {
      _lastAnswerCorrect = correct;
      _showAnswerAnimation = true;
    });

    _feedbackController.reset();

    // Muncul
    await _feedbackController.forward();

    if (!mounted) return;

    // Diam sebentar
    await Future.delayed(
      const Duration(milliseconds: 800),
    );

    if (!mounted) return;

    // Hilang
    await _feedbackController.reverse();

    if (!mounted) return;

    setState(() {
      _showAnswerAnimation = false;
    });
  }

  // ============================================================
  // SUARA BENAR / SALAH
  // ============================================================

  Future<void> _playAnswerSound(bool correct) async {
    try {
      await _audioPlayer.play(
        AssetSource(
          correct
              ? 'BENAR.mp3'
              : 'wrong.wav',
        ),
      );
    } catch (_) {
      // Jika suara gagal, kuis tetap berjalan.
    }
  }

  // ============================================================
  // SOAL BERIKUTNYA
  // ============================================================

  Future<void> nextQuestion() async {
    if (!answered) return;

    if (_showAnswerAnimation) return;

    // Kalau soal terakhir
    if (currentQuestion == questions.length - 1) {
      _timer?.cancel();

      await widget.onFinished(
        score,
        questions.length * 10,
      );

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

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _timer?.cancel();
    _feedbackController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

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

    final question = questions[currentQuestion];

    final progress =
        (currentQuestion + 1) / questions.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kuis Kelas ${widget.grade} SD',
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(25),
              child: Column(
                children: [
                  // ==================================================
                  // PROGRESS
                  // ==================================================

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

                  // ==================================================
                  // TIMER
                  // ==================================================

                  AnimatedContainer(
                    duration:
                        const Duration(milliseconds: 250),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: secondsRemaining <= 5
                          ? const Color(0xFFFFE4E4)
                          : const Color(0xFFEAF0FF),
                      borderRadius:
                          BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          color: secondsRemaining <= 5
                              ? Colors.red
                              : const Color(0xFF4F7DF3),
                        ),
                        const SizedBox(width: 7),
                        Text(
                          '$secondsRemaining detik',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // ==================================================
                  // PERTANYAAN
                  // ==================================================

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
                            remoteImageUrl:
                                _remoteVisuals[question.id],
                          ),

                        if (question.visual != null)
                          const SizedBox(height: 10),

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

                  // ==================================================
                  // PILIHAN JAWABAN
                  // ==================================================

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
                        onTap: answered ||
                                _showAnswerAnimation
                            ? null
                            : () => chooseAnswer(index),

                        child: AnimatedContainer(
                          duration:
                              const Duration(milliseconds: 250),
                          width: double.infinity,
                          margin:
                              const EdgeInsets.only(bottom: 13),
                          padding: const EdgeInsets.all(18),
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
                                      : const Color(0xFFE0E6F2),
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
                                    color: showCorrect ||
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
                                const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                ),

                              if (showWrong)
                                const Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  // ==================================================
                  // PENJELASAN
                  // ==================================================

                  if (answered)
                    AnimatedSwitcher(
                      duration:
                          const Duration(milliseconds: 300),
                      child: Container(
                        key: ValueKey(
                          '${currentQuestion}_$selectedAnswer',
                        ),
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: selectedAnswer ==
                                  question.answer
                              ? const Color(0xFFE0F7E8)
                              : const Color(0xFFFFE3E3),
                          borderRadius:
                              BorderRadius.circular(20),
                        ),
                        child: Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            _AnswerStatusIcon(
                              isCorrect:
                                  selectedAnswer ==
                                      question.answer,
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: Text(
                                selectedAnswer ==
                                        question.answer
                                    ? 'Jawaban benar! ${question.explanation}'
                                    : timedOut
                                        ? 'Waktu habis. Jawaban yang benar adalah "${question.options[question.answer]}". ${question.explanation}'
                                        : 'Belum tepat. Jawaban yang benar adalah "${question.options[question.answer]}". ${question.explanation}',
                                style: const TextStyle(
                                  fontWeight:
                                      FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  const SizedBox(height: 20),

                  // ==================================================
                  // TOMBOL BERIKUTNYA
                  // ==================================================

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          answered &&
                                  !_showAnswerAnimation
                              ? nextQuestion
                              : null,
                      style:
                          ElevatedButton.styleFrom(
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

          // ========================================================
          // ANIMASI BESAR DI TENGAH
          // ========================================================

          if (_showAnswerAnimation)
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  color: Colors.black.withOpacity(0.20),
                  child: Center(
                    child: AnimatedBuilder(
                      animation: _feedbackController,
                      builder: (context, child) {
                        return Opacity(
                          opacity:
                              _feedbackOpacity.value,
                          child: Transform.scale(
                            scale:
                                _feedbackScale.value,
                            child: child,
                          ),
                        );
                      },
                      child: _BigAnswerFeedback(
                        correct: _lastAnswerCorrect,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ================================================================
// ANIMASI CENTANG / SILANG BESAR
// ================================================================

class _BigAnswerFeedback extends StatelessWidget {
  const _BigAnswerFeedback({
    required this.correct,
  });

  final bool correct;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 190,
      height: 190,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: correct
            ? Colors.green
            : Colors.red,
        boxShadow: [
          BoxShadow(
            color: (correct
                    ? Colors.green
                    : Colors.red)
                .withOpacity(0.45),
            blurRadius: 35,
            spreadRadius: 10,
          ),
        ],
      ),
      child: Icon(
        correct
            ? Icons.check_rounded
            : Icons.close_rounded,
        color: Colors.white,
        size: 130,
      ),
    );
  }
}

// ================================================================
// VISUAL SOAL
// ================================================================

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
    if (remoteImageUrl != null &&
        remoteImageUrl!.isNotEmpty) {
      return Image.network(
        remoteImageUrl!,
        height: 76,
        errorBuilder: (_, __, ___) {
          return Text(
            visual,
            style: const TextStyle(
              fontSize: 42,
            ),
          );
        },
      );
    }

    if (!isAnimated) {
      return Text(
        visual,
        style: const TextStyle(
          fontSize: 42,
        ),
      );
    }

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(
        begin: 0.8,
        end: 1.0,
      ),
      duration:
          const Duration(milliseconds: 650),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: Text(
        visual,
        style: const TextStyle(
          fontSize: 48,
        ),
      ),
    );
  }
}

// ================================================================
// ICON FEEDBACK KECIL
// ================================================================

class _AnswerStatusIcon extends StatelessWidget {
  const _AnswerStatusIcon({
    required this.isCorrect,
  });

  final bool isCorrect;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(
        begin: 0.3,
        end: 1.0,
      ),
      duration:
          const Duration(milliseconds: 420),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: Icon(
        isCorrect
            ? Icons.check_circle_rounded
            : Icons.cancel_rounded,
        color:
            isCorrect ? Colors.green : Colors.red,
        size: 42,
      ),
    );
  }
}
