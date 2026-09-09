import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../data/question_bank.dart';
import '../models/question.dart';
import '../services/animated_question_api.dart';
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
  });

  final int grade;
  final String? subject;
  final Future<void> Function(
    int score,
    int total,
  ) onFinished;

  final String studentName;
  final List<Question>? questions;

  @override
  State<QuizPage> createState() =>
      _QuizPageState();
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

  Map<String, String> remote = {};

  late AnimationController
      feedbackController;

  late Animation<double> scale;
  late Animation<double> opacity;

  final AudioPlayer audio =
      AudioPlayer();

  @override
  void initState() {
    super.initState();

    feedbackController =
        AnimationController(
      vsync: this,
      duration:
          const Duration(milliseconds: 500),
    );

    scale = CurvedAnimation(
      parent: feedbackController,
      curve: Curves.elasticOut,
    );

    opacity = CurvedAnimation(
      parent: feedbackController,
      curve: Curves.easeOut,
    );

    unawaited(
      audio.setReleaseMode(
        ReleaseMode.stop,
      ),
    );

    final all =
        widget.questions ??
            questionsByGrade[
                widget.grade] ??
            [];

    final source =
        widget.subject == null
            ? all
            : all
                .where(
                  (q) =>
                      q.subject ==
                      widget.subject,
                )
                .toList();

    questions =
        _shuffle(source);

    startTimer();
    loadRemote();
  }

  List<Question> _shuffle(
    List<Question> source,
  ) {
    final random = Random();

    final result =
        source.map((question) {
      final options =
          List<String>.from(
            question.options,
          )..shuffle(random);

      return question.withOptions(
        options,
      );
    }).toList()
          ..shuffle(random);

    return result;
  }

  Future<void> loadRemote() async {
    if (questions.isEmpty) return;

    final visuals =
        await AnimatedQuestionApi()
            .loadVisuals(
      questions
          .where(
            (q) => q.isAnimated,
          )
          .map(
            (q) => q.id,
          )
          .toList(),
    );

    if (!mounted ||
        visuals.isEmpty) {
      return;
    }

    setState(() {
      remote = visuals;
    });
  }

  void startTimer() {
    timer?.cancel();

    setState(() {
      seconds = 15;
    });

    timer = Timer.periodic(
      const Duration(seconds: 1),
      (t) {
        if (!mounted || answered) {
          t.cancel();
          return;
        }

        if (seconds <= 1) {
          t.cancel();

          setState(() {
            seconds = 0;
            answered = true;
            timedOut = true;
            selected = null;
            feedbackCorrect = false;
          });

          showAnswerFeedback(false);
        } else {
          setState(() {
            seconds--;
          });
        }
      },
    );
  }

  void choose(int index) {
    if (answered ||
        showFeedback) {
      return;
    }

    timer?.cancel();

    final question =
        questions[current];

    final correct =
        index == question.answer;

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

    showAnswerFeedback(
      correct,
    );
  }

  Future<void> playSound(
    bool correct,
  ) async {
    try {
      await audio.play(
        AssetSource(
          correct
              ? 'BENAR.mp3'
              : 'wrong.wav',
        ),
      );
    } catch (_) {
      // Audio gagal tidak
      // menghentikan kuis.
    }
  }

  Future<void>
      showAnswerFeedback(
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

    // Feedback muncul sebentar.
    await Future.delayed(
      const Duration(
        milliseconds: 1100,
      ),
    );

    if (!mounted) return;

    await feedbackController.reverse();

    if (!mounted) return;

    setState(() {
      showFeedback = false;
    });

    // ======================================
    // OTOMATIS PINDAH KE SOAL BERIKUTNYA
    // ======================================
    await nextQuestion();
  }

  Future<void> nextQuestion() async {
    if (!answered ||
        showFeedback) {
      return;
    }

    // ======================================
    // SOAL TERAKHIR
    // ======================================
    if (current ==
        questions.length - 1) {
      timer?.cancel();

      await widget.onFinished(
        score,
        questions.length * 10,
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              ResultPage(
            grade: widget.grade,
            score: score,
            total:
                questions.length * 10,
            studentName:
                widget.studentName,
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
  Widget build(
    BuildContext context,
  ) {
    if (questions.isEmpty) {
      return Scaffold(
        body: SchoolBackground(
          child: Center(
            child: Container(
              padding:
                  const EdgeInsets.all(
                24,
              ),
              decoration:
                  BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(
                  24,
                ),
              ),
              child: const Text(
                'Soal belum tersedia.',
              ),
            ),
          ),
        ),
      );
    }

    final question =
        questions[current];

    final progress =
        (current + 1) /
            questions.length;

    return Scaffold(
      body: SchoolBackground(
        compact: true,
        showSchoolIllustrations:
            false,
        child: SafeArea(
          child: Stack(
            children: [
              Center(
                child: ConstrainedBox(
                  constraints:
                      const BoxConstraints(
                    maxWidth: 1180,
                  ),
                  child: Scrollbar(
                    thumbVisibility:
                        MediaQuery.sizeOf(
                              context,
                            ).width >=
                            900,
                    thickness: 8,
                    radius:
                        const Radius.circular(
                      20,
                    ),
                    child: ListView(
                      padding:
                          const EdgeInsets.fromLTRB(
                        20,
                        12,
                        20,
                        80,
                      ),
                      children: [
                        _Top(
                          grade: widget.grade,
                          name:
                              widget.studentName,
                          current:
                              current + 1,
                          total:
                              questions.length,
                          progress:
                              progress,
                        ),

                        const SizedBox(
                          height: 14,
                        ),

                        _Timer(seconds),

                        const SizedBox(
                          height: 17,
                        ),

                        _Question(
                          q: question,
                          remote:
                              remote[
                                  question.id],
                        ),

                        const SizedBox(
                          height: 16,
                        ),

                        ...List.generate(
                          question
                              .options
                              .length,
                          (i) => _Option(
                            q: question,
                            index: i,
                            selected:
                                selected,
                            answered:
                                answered,
                            onTap: choose,
                          ),
                        ),

                        if (answered)
                          _Explain(
                            q: question,
                            selected:
                                selected,
                            timedOut:
                                timedOut,
                          ),

                        if (answered)
                          const Padding(
                            padding:
                                EdgeInsets.only(
                              top: 12,
                            ),
                            child: Text(
                              'Soal berikutnya akan terbuka otomatis ✨',
                              textAlign:
                                  TextAlign.center,
                              style:
                                  TextStyle(
                                color:
                                    Color(
                                  0xFF667D92,
                                ),
                                fontSize: 12,
                                fontWeight:
                                    FontWeight
                                        .w800,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),

              // =================================
              // FEEDBACK ANIMASI BESAR
              // =================================
              if (showFeedback)
                Positioned.fill(
                  child: IgnorePointer(
                    child: Container(
                      color: const Color(
                        0x3324445D,
                      ),
                      alignment:
                          Alignment.center,
                      child: AnimatedBuilder(
                        animation:
                            feedbackController,
                        builder:
                            (context, child) {
                          return Opacity(
                            opacity:
                                opacity.value,
                            child:
                                Transform.scale(
                              scale:
                                  scale.value,
                              child: child,
                            ),
                          );
                        },
                        child:
                            _Feedback(
                          correct:
                              feedbackCorrect,
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

class _Top extends StatelessWidget {
  const _Top({
    required this.grade,
    required this.name,
    required this.current,
    required this.total,
    required this.progress,
  });

  final int grade;
  final String name;
  final int current;
  final int total;
  final double progress;

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      padding:
          const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color:
            Colors.white.withOpacity(.94),
        borderRadius:
            BorderRadius.circular(23),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(.06),
            blurRadius: 15,
            offset:
                const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 47,
            height: 47,
            decoration:
                BoxDecoration(
              color:
                  const Color(0xFFFFD66B),
              borderRadius:
                  BorderRadius.circular(
                15,
              ),
            ),
            child: const Icon(
              Icons.school_rounded,
              color: Colors.white,
            ),
          ),

          const SizedBox(
            width: 11,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              children: [
                Text(
                  'Kelas $grade • $name',
                  style:
                      const TextStyle(
                    fontWeight:
                        FontWeight.w900,
                    color:
                        Color(0xFF243B5A),
                    fontSize: 15,
                  ),
                ),

                const SizedBox(
                  height: 6,
                ),

                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(
                    20,
                  ),
                  child:
                      LinearProgressIndicator(
                    value: progress,
                    minHeight: 9,
                    backgroundColor:
                        const Color(
                      0xFFE5EDF4,
                    ),
                    valueColor:
                        const AlwaysStoppedAnimation(
                      Color(0xFF45C77A),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(
            width: 12,
          ),

          Text(
            '$current/$total',
            style:
                const TextStyle(
              fontWeight:
                  FontWeight.w900,
              color:
                  Color(0xFF4F8FF7),
            ),
          ),
        ],
      ),
    );
  }
}

class _Timer extends StatelessWidget {
  const _Timer(this.value);

  final int value;

  @override
  Widget build(
    BuildContext context,
  ) {
    final danger = value <= 5;

    return Align(
      alignment:
          Alignment.center,
      child: AnimatedContainer(
        duration:
            const Duration(
          milliseconds: 200,
        ),
        padding:
            const EdgeInsets.symmetric(
          horizontal: 17,
          vertical: 9,
        ),
        decoration:
            BoxDecoration(
          color: danger
              ? const Color(
                  0xFFFFE6E6,
                )
              : Colors.white,
          borderRadius:
              BorderRadius.circular(
            30,
          ),
          border: Border.all(
            color: danger
                ? const Color(
                    0xFFFF7373,
                  )
                : const Color(
                    0xFFD8E8F4,
                  ),
          ),
        ),
        child: Row(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            Icon(
              Icons.timer_rounded,
              color: danger
                  ? const Color(
                      0xFFE65353,
                    )
                  : const Color(
                      0xFF4F8FF7,
                    ),
            ),
            const SizedBox(
              width: 7,
            ),
            Text(
              '$value detik',
              style: TextStyle(
                fontWeight:
                    FontWeight.w900,
                color: danger
                    ? const Color(
                        0xFFE65353,
                      )
                    : const Color(
                        0xFF3B5974,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Question extends StatelessWidget {
  const _Question({
    required this.q,
    this.remote,
  });

  final Question q;
  final String? remote;

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      padding:
          const EdgeInsets.fromLTRB(
        20,
        17,
        20,
        21,
      ),
      decoration: BoxDecoration(
        gradient:
            const LinearGradient(
          colors: [
            Color(0xFFFFD969),
            Color(0xFFFFA85E),
          ],
        ),
        borderRadius:
            BorderRadius.circular(30),
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
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration:
                    BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(
                    30,
                  ),
                ),
                child: Text(
                  q.subject,
                  style:
                      const TextStyle(
                    fontSize: 12,
                    fontWeight:
                        FontWeight.w900,
                    color:
                        Color(0xFF72531A),
                  ),
                ),
              ),

              const Spacer(),

              const Icon(
                Icons
                    .auto_awesome_rounded,
                color: Colors.white,
              ),
            ],
          ),

          const SizedBox(
            height: 10,
          ),

          SizedBox(
            height: 88,
            child: remote != null
                ? Image.network(
                    remote!,
                    fit: BoxFit.contain,
                    errorBuilder:
                        (_, __, ___) =>
                            _Illustration(
                      subject:
                          q.subject,
                    ),
                  )
                : _Illustration(
                    subject:
                        q.subject,
                  ),
          ),

          const SizedBox(
            height: 10,
          ),

          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 17,
            ),
            decoration:
                BoxDecoration(
              color: Colors.white
                  .withOpacity(.90),
              borderRadius:
                  BorderRadius.circular(
                21,
              ),
            ),
            child: Text(
              q.question,
              textAlign:
                  TextAlign.center,
              style:
                  const TextStyle(
                fontSize: 23,
                fontWeight:
                    FontWeight.w900,
                color:
                    Color(0xFF263B54),
                height: 1.25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Illustration
    extends StatelessWidget {
  const _Illustration({
    required this.subject,
  });

  final String subject;

  String get asset {
    final s =
        subject.toLowerCase();

    if (s.contains('bahasa')) {
      return 'assets/Gambar guru p.jpeg';
    }

    if (s.contains('ipa')) {
      return 'assets/Gambar pohon 1.jpeg';
    }

    if (s.contains('logika')) {
      return 'assets/Naik bus.jpeg';
    }

    return 'assets/anak sd angkat tangan.jpeg';
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return TweenAnimationBuilder<
        double>(
      tween: Tween(
        begin: .90,
        end: 1,
      ),
      duration:
          const Duration(
        milliseconds: 600,
      ),
      curve:
          Curves.elasticOut,
      builder:
          (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: Image.asset(
        asset,
        fit: BoxFit.contain,
      ),
    );
  }
}

class _Option extends StatelessWidget {
  const _Option({
    required this.q,
    required this.index,
    required this.selected,
    required this.answered,
    required this.onTap,
  });

  final Question q;
  final int index;
  final int? selected;
  final bool answered;
  final ValueChanged<int> onTap;

  @override
  Widget build(
    BuildContext context,
  ) {
    final correct =
        index == q.answer;

    final wrong =
        answered &&
            selected == index &&
            !correct;

    final good =
        answered && correct;

    final border =
        good
            ? const Color(
                0xFF43C77A,
              )
            : wrong
                ? const Color(
                    0xFFEF6262,
                  )
                : const Color(
                    0xFFDCE8F2,
                  );

    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 11,
      ),
      child: PressableCard(
        onTap: answered
            ? () {}
            : () => onTap(index),
        child: AnimatedContainer(
          duration:
              const Duration(
            milliseconds: 220,
          ),
          padding:
              const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          decoration:
              BoxDecoration(
            color: good
                ? const Color(
                    0xFFE9FFF2,
                  )
                : wrong
                    ? const Color(
                        0xFFFFEEEE,
                      )
                    : Colors.white
                        .withOpacity(.95),
            borderRadius:
                BorderRadius.circular(
              21,
            ),
            border: Border.all(
              color: border,
              width:
                  good || wrong
                      ? 2
                      : 1.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment:
                    Alignment.center,
                decoration:
                    BoxDecoration(
                  color: good
                      ? const Color(
                          0xFF43C77A,
                        )
                      : wrong
                          ? const Color(
                              0xFFEF6262,
                            )
                          : const Color(
                              0xFFEAF2FF,
                            ),
                  borderRadius:
                      BorderRadius.circular(
                    14,
                  ),
                ),
                child: Text(
                  String.fromCharCode(
                    65 + index,
                  ),
                  style: TextStyle(
                    color:
                        good || wrong
                            ? Colors.white
                            : const Color(
                                0xFF4F8FF7,
                              ),
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),
              ),

              const SizedBox(
                width: 13,
              ),

              Expanded(
                child: Text(
                  q.options[index],
                  style:
                      const TextStyle(
                    fontSize: 16,
                    fontWeight:
                        FontWeight.w700,
                    color:
                        Color(0xFF2D455F),
                  ),
                ),
              ),

              if (good)
                const Icon(
                  Icons
                      .check_circle_rounded,
                  color:
                      Color(0xFF43C77A),
                ),

              if (wrong)
                const Icon(
                  Icons.cancel_rounded,
                  color:
                      Color(0xFFEF6262),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Explain
    extends StatelessWidget {
  const _Explain({
    required this.q,
    required this.selected,
    required this.timedOut,
  });

  final Question q;
  final int? selected;
  final bool timedOut;

  @override
  Widget build(
    BuildContext context,
  ) {
    final correct =
        selected == q.answer;

    return Container(
      margin:
          const EdgeInsets.only(
        top: 3,
      ),
      padding:
          const EdgeInsets.all(16),
      decoration:
          BoxDecoration(
        color: correct
            ? const Color(
                0xFFE9FFF2,
              )
            : const Color(
                0xFFFFF1E9,
              ),
        borderRadius:
            BorderRadius.circular(
          21,
        ),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(
            correct
                ? Icons
                    .check_circle_rounded
                : Icons
                    .lightbulb_rounded,
            color: correct
                ? const Color(
                    0xFF43C77A,
                  )
                : const Color(
                    0xFFF0A35A,
                  ),
            size: 38,
          ),

          const SizedBox(
            width: 11,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  correct
                      ? 'Jawaban benar! 🎉'
                      : timedOut
                          ? 'Waktu habis ⏰'
                          : 'Belum tepat, yuk pelajari lagi 💡',
                  style:
                      const TextStyle(
                    fontWeight:
                        FontWeight.w900,
                    color:
                        Color(0xFF29435F),
                  ),
                ),

                const SizedBox(
                  height: 5,
                ),

                Text(
                  correct
                      ? q.explanation
                      : 'Jawaban yang benar adalah '
                          '"${q.options[q.answer]}". '
                          '${q.explanation}',
                  style:
                      const TextStyle(
                    color:
                        Color(0xFF5E7183),
                    height: 1.4,
                    fontWeight:
                        FontWeight.w600,
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

class _Feedback
    extends StatelessWidget {
  const _Feedback({
    required this.correct,
  });

  final bool correct;

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      width: 290,
      padding:
          const EdgeInsets.all(22),
      decoration:
          BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(
          32,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 30,
          ),
        ],
      ),
      child: Column(
        mainAxisSize:
            MainAxisSize.min,
        children: [
          SizedBox(
            height: 130,
            child: Image.asset(
              correct
                  ? 'assets/Gambar anak sd .jpeg'
                  : 'assets/Gambar guru p.jpeg',
              fit: BoxFit.contain,
            ),
          ),

          Container(
            width: 60,
            height: 60,
            decoration:
                BoxDecoration(
              color: correct
                  ? const Color(
                      0xFF43C77A,
                    )
                  : const Color(
                      0xFFEF6262,
                    ),
              shape:
                  BoxShape.circle,
            ),
            child: Icon(
              correct
                  ? Icons.check_rounded
                  : Icons.close_rounded,
              color: Colors.white,
              size: 40,
            ),
          ),

          const SizedBox(
            height: 9,
          ),

          Text(
            correct
                ? 'Jawaban Benar!'
                : 'Belum Tepat',
            style: TextStyle(
              fontSize: 21,
              fontWeight:
                  FontWeight.w900,
              color: correct
                  ? const Color(
                      0xFF2EAE68,
                    )
                  : const Color(
                      0xFFE65353,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}