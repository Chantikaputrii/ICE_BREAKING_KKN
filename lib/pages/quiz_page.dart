import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../data/question_bank.dart';
import '../models/question.dart';
import '../widgets/school_background.dart';
import 'result_page.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({
    super.key,
    required this.grade,
    required this.onFinished,
    required this.studentName,
    this.questions,
    this.subject,
    this.topic,
  });

  final int grade;
  final String studentName;
  final Future<void> Function(int score, int total) onFinished;
  final List<Question>? questions;
  final String? subject;
  final String? topic;

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage>
    with SingleTickerProviderStateMixin {
  late List<Question> questions;

  int current = 0;
  int score = 0;
  int seconds = 15;

  int? selected;

  bool answered = false;
  bool timedOut = false;
  bool showFeedback = false;
  bool feedbackCorrect = false;

  Timer? timer;

  late final AnimationController feedbackController;
  late final Animation<double> scaleAnimation;
  late final Animation<double> opacityAnimation;

  final AudioPlayer audio = AudioPlayer();

  @override
  void initState() {
    super.initState();

    feedbackController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    );

    scaleAnimation = CurvedAnimation(
      parent: feedbackController,
      curve: Curves.easeOutBack,
    );

    opacityAnimation = CurvedAnimation(
      parent: feedbackController,
      curve: Curves.easeOut,
    );

    unawaited(
      audio.setReleaseMode(ReleaseMode.stop),
    );

    final allQuestions = List<Question>.from(
      widget.questions ??
          questionsByGrade[widget.grade] ??
          <Question>[],
    );

    final filteredQuestions = widget.subject == null
        ? allQuestions
        : allQuestions
            .where(
              (question) =>
                  question.subject == widget.subject,
            )
            .toList();

    questions = _shuffleQuestions(filteredQuestions);

    if (questions.isNotEmpty) {
      startTimer();
    }
  }

  List<Question> _shuffleQuestions(
    List<Question> source,
  ) {
    final random = Random();

    final result = source.map((question) {
      final options = List<String>.from(
        question.options,
      );

      options.shuffle(random);

      return question.withOptions(options);
    }).toList();

    result.shuffle(random);

    return result;
  }

  void startTimer() {
    timer?.cancel();

    if (!mounted) return;

    setState(() {
      seconds = 15;
    });

    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (!mounted || answered) {
          timer.cancel();
          return;
        }

        if (seconds <= 1) {
          timer.cancel();

          setState(() {
            seconds = 0;
            answered = true;
            timedOut = true;
            selected = null;
            feedbackCorrect = false;
          });

          unawaited(
            showAnswerFeedback(false),
          );
        } else {
          setState(() {
            seconds--;
          });
        }
      },
    );
  }

  void chooseAnswer(int index) {
    if (answered || showFeedback) {
      return;
    }

    timer?.cancel();

    final question = questions[current];

    final correct = index == question.answer;

    setState(() {
      selected = index;
      answered = true;
      timedOut = false;
      feedbackCorrect = correct;

      if (correct) {
        score += 10;
      }
    });

    unawaited(
      playSound(correct),
    );

    unawaited(
      showAnswerFeedback(correct),
    );
  }

  Future<void> playSound(bool correct) async {
    try {
      await audio.play(
        AssetSource(
          correct ? 'BENAR.mp3' : 'wrong.wav',
        ),
      );
    } catch (_) {
      // Jika audio gagal, kuis tetap berjalan.
    }
  }

  Future<void> showAnswerFeedback(
    bool correct,
  ) async {
    if (!mounted) return;

    setState(() {
      showFeedback = true;
      feedbackCorrect = correct;
    });

    feedbackController.reset();

    await feedbackController.forward();

    if (!mounted) return;

    // Dibuat 5 detik supaya pembahasan bisa dibaca.
    await Future.delayed(
      const Duration(seconds: 5),
    );

    if (!mounted) return;

    await feedbackController.reverse();

    if (!mounted) return;

    setState(() {
      showFeedback = false;
    });

    await nextQuestion();
  }

  Future<void> nextQuestion() async {
    if (!answered || showFeedback) {
      return;
    }

    if (current >= questions.length - 1) {
      timer?.cancel();

      final total = questions.length * 10;

      await widget.onFinished(
        score,
        total,
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultPage(
            grade: widget.grade,
            score: score,
            total: total,
            studentName: widget.studentName,
          ),
        ),
      );

      return;
    }

    setState(() {
      current++;
      selected = null;
      answered = false;
      timedOut = false;
      feedbackCorrect = false;
    });

    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    feedbackController.dispose();
    audio.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return Scaffold(
        body: SchoolBackground(
          child: Center(
            child: Container(
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Text(
                'Soal belum tersedia.',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF263E5D),
                ),
              ),
            ),
          ),
        ),
      );
    }

    final question = questions[current];

    final progress =
        (current + 1) / questions.length;

    return Scaffold(
      body: SchoolBackground(
        compact: true,
        showSchoolIllustrations: false,
        child: SafeArea(
          child: Stack(
            children: [
              // Scrollbar dibuat selebar layar,
              // sehingga berada di pinggir kanan desktop.
              Scrollbar(
                thumbVisibility:
                    MediaQuery.sizeOf(context).width >= 900,
                trackVisibility:
                    MediaQuery.sizeOf(context).width >= 900,
                interactive: true,
                thickness: 8,
                radius: const Radius.circular(20),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    14,
                    20,
                    80,
                  ),
                  children: [
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 1180,
                        ),
                        child: Column(
                          children: [
                            _QuizHeader(
                              grade: widget.grade,
                              name: widget.studentName,
                              current: current + 1,
                              total: questions.length,
                              progress: progress,
                              topic: widget.topic,
                            ),

                            const SizedBox(height: 15),

                            _Timer(seconds),

                            const SizedBox(height: 18),

                            // Kotak soal TANPA gambar.
                            _QuestionCard(
                              question: question,
                              topic: widget.topic,
                            ),

                            const SizedBox(height: 16),

                            ...List.generate(
                              question.options.length,
                              (index) {
                                return _AnswerOption(
                                  question: question,
                                  index: index,
                                  selected: selected,
                                  answered: answered,
                                  onTap: chooseAnswer,
                                );
                              },
                            ),

                            if (answered)
                              _ExplanationCard(
                                question: question,
                                selected: selected,
                                timedOut: timedOut,
                              ),

                            if (answered)
                              const Padding(
                                padding: EdgeInsets.only(
                                  top: 14,
                                ),
                                child: Text(
                                  'Soal berikutnya akan terbuka otomatis...',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF667D92),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              if (showFeedback)
                Positioned.fill(
                  child: IgnorePointer(
                    child: Container(
                      color: const Color(0x3324445D),
                      alignment: Alignment.center,
                      child: AnimatedBuilder(
                        animation: feedbackController,
                        builder: (
                          context,
                          child,
                        ) {
                          return Opacity(
                            opacity:
                                opacityAnimation.value,
                            child: Transform.scale(
                              scale:
                                  scaleAnimation.value,
                              child: child,
                            ),
                          );
                        },
                        child: _FeedbackCard(
                          correct: feedbackCorrect,
                          question: question,
                          timedOut: timedOut,
                        ),
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

class _QuizHeader extends StatelessWidget {
  const _QuizHeader({
    required this.grade,
    required this.name,
    required this.current,
    required this.total,
    required this.progress,
    this.topic,
  });

  final int grade;
  final String name;
  final int current;
  final int total;
  final double progress;
  final String? topic;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.95),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 16,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFFFD66B),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.school_rounded,
              color: Colors.white,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Kelas $grade • $name',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF243B5A),
                  ),
                ),

                if (topic != null) ...[
                  const SizedBox(height: 3),
                  Text(
                    topic!,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF4F8FF7),
                    ),
                  ),
                ],

                const SizedBox(height: 7),

                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    minHeight: 9,
                    backgroundColor:
                        const Color(0xFFE5EDF4),
                    valueColor:
                        const AlwaysStoppedAnimation(
                      Color(0xFF45C77A),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          Text(
            '$current/$total',
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              color: Color(0xFF4F8FF7),
            ),
          ),
        ],
      ),
    );
  }
}

class _Timer extends StatelessWidget {
  const _Timer(this.seconds);

  final int seconds;

  @override
  Widget build(BuildContext context) {
    final danger = seconds <= 5;

    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 9,
        ),
        decoration: BoxDecoration(
          color: danger
              ? const Color(0xFFFFE6E6)
              : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: danger
                ? const Color(0xFFFF7373)
                : const Color(0xFFD8E8F4),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.timer_rounded,
              color: danger
                  ? const Color(0xFFE65353)
                  : const Color(0xFF4F8FF7),
            ),
            const SizedBox(width: 7),
            Text(
              '$seconds detik',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: danger
                    ? const Color(0xFFE65353)
                    : const Color(0xFF3B5974),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({
    required this.question,
    this.topic,
  });

  final Question question;
  final String? topic;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        20,
        18,
        20,
        22,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFFD969),
            Color(0xFFFFA85E),
          ],
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.white,
          width: 3,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26B57B36),
            blurRadius: 22,
            offset: Offset(0, 9),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(30),
                ),
                child: Text(
                  question.subject,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF72531A),
                  ),
                ),
              ),

              if (topic != null) ...[
                const SizedBox(width: 8),
                Flexible(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white
                          .withOpacity(.75),
                      borderRadius:
                          BorderRadius.circular(30),
                    ),
                    child: Text(
                      topic!,
                      overflow:
                          TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF72531A),
                      ),
                    ),
                  ),
                ),
              ],

              const Spacer(),

              const Icon(
                Icons.auto_awesome_rounded,
                color: Colors.white,
              ),
            ],
          ),

          const SizedBox(height: 14),

          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 26,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.94),
              borderRadius:
                  BorderRadius.circular(22),
            ),
            child: Text(
              question.question,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: Color(0xFF263B54),
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnswerOption extends StatelessWidget {
  const _AnswerOption({
    required this.question,
    required this.index,
    required this.selected,
    required this.answered,
    required this.onTap,
  });

  final Question question;
  final int index;
  final int? selected;
  final bool answered;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final isCorrect =
        index == question.answer;

    final isWrong =
        answered &&
        selected == index &&
        !isCorrect;

    final isGood =
        answered && isCorrect;

    final borderColor = isGood
        ? const Color(0xFF43C77A)
        : isWrong
            ? const Color(0xFFEF6262)
            : const Color(0xFFDCE8F2);

    final backgroundColor = isGood
        ? const Color(0xFFE9FFF2)
        : isWrong
            ? const Color(0xFFFFEEEE)
            : Colors.white.withOpacity(.95);

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 11,
      ),
      child: PressableCard(
        onTap: answered
            ? () {}
            : () => onTap(index),
        child: AnimatedContainer(
          duration:
              const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius:
                BorderRadius.circular(21),
            border: Border.all(
              color: borderColor,
              width: isGood || isWrong
                  ? 2
                  : 1.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isGood
                      ? const Color(0xFF43C77A)
                      : isWrong
                          ? const Color(0xFFEF6262)
                          : const Color(0xFFEAF2FF),
                  borderRadius:
                      BorderRadius.circular(14),
                ),
                child: Text(
                  String.fromCharCode(
                    65 + index,
                  ),
                  style: TextStyle(
                    color: isGood || isWrong
                        ? Colors.white
                        : const Color(0xFF4F8FF7),
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Text(
                  question.options[index],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2D455F),
                  ),
                ),
              ),

              if (isGood)
                const Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF43C77A),
                ),

              if (isWrong)
                const Icon(
                  Icons.cancel_rounded,
                  color: Color(0xFFEF6262),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExplanationCard extends StatelessWidget {
  const _ExplanationCard({
    required this.question,
    required this.selected,
    required this.timedOut,
  });

  final Question question;
  final int? selected;
  final bool timedOut;

  @override
  Widget build(BuildContext context) {
    final correct =
        selected != null &&
        selected == question.answer;

    final title = correct
        ? 'Jawaban benar!'
        : timedOut
            ? 'Waktu habis'
            : 'Belum tepat, yuk pelajari lagi';

    final explanation = correct
        ? question.explanation
        : 'Jawaban yang benar adalah '
            '"${question.options[question.answer]}". '
            '${question.explanation}';

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 5),
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: correct
            ? const Color(0xFFE9FFF2)
            : const Color(0xFFFFF1E9),
        borderRadius: BorderRadius.circular(21),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(
            correct
                ? Icons.check_circle_rounded
                : Icons.lightbulb_rounded,
            color: correct
                ? const Color(0xFF43C77A)
                : const Color(0xFFF0A35A),
            size: 38,
          ),

          const SizedBox(width: 11),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF29435F),
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  explanation,
                  style: const TextStyle(
                    color: Color(0xFF5E7183),
                    height: 1.4,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeedbackCard extends StatelessWidget {
  const _FeedbackCard({
    required this.correct,
    required this.question,
    required this.timedOut,
  });

  final bool correct;
  final Question question;
  final bool timedOut;

  @override
  Widget build(BuildContext context) {
    final title = correct
        ? 'Jawaban Benar!'
        : timedOut
            ? 'Waktu Habis'
            : 'Belum Tepat';

    final subtitle = correct
        ? question.explanation
        : 'Jawaban yang benar adalah '
            '"${question.options[question.answer]}". '
            '${question.explanation}';

    return Container(
      width: 420,
      constraints: const BoxConstraints(
        maxWidth: 430,
      ),
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.fromLTRB(
        25,
        25,
        25,
        28,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 30,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 78,
            height: 78,
            decoration: BoxDecoration(
              color: correct
                  ? const Color(0xFF43C77A)
                  : const Color(0xFFEF6262),
              shape: BoxShape.circle,
            ),
            child: Icon(
              correct
                  ? Icons.check_rounded
                  : timedOut
                      ? Icons.timer_off_rounded
                      : Icons.close_rounded,
              color: Colors.white,
              size: 48,
            ),
          ),

          const SizedBox(height: 14),

          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w900,
              color: correct
                  ? const Color(0xFF2EAE68)
                  : const Color(0xFFE65353),
            ),
          ),

          const SizedBox(height: 12),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: correct
                  ? const Color(0xFFE9FFF2)
                  : const Color(0xFFFFF1E9),
              borderRadius:
                  BorderRadius.circular(18),
            ),
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4E6478),
              ),
            ),
          ),

          const SizedBox(height: 15),

          const Text(
            'Sebentar lagi lanjut ke soal berikutnya...',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF8798A7),
            ),
          ),
        ],
      ),
    );
  }
}