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
  final Future<void> Function(
    int score,
    int total,
  ) onFinished;
  final List<Question>? questions;
  final String? subject;
  final String? topic;

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

  late final AnimationController
      feedbackController;

  late final Animation<double>
      scaleAnimation;

  late final Animation<double>
      opacityAnimation;

  final AudioPlayer audio =
      AudioPlayer();

  @override
  void initState() {
    super.initState();

    feedbackController =
        AnimationController(
      vsync: this,
      duration:
          const Duration(milliseconds: 850),
    );

    scaleAnimation =
        CurvedAnimation(
      parent: feedbackController,
      curve: Curves.easeOutBack,
    );

    opacityAnimation =
        CurvedAnimation(
      parent: feedbackController,
      curve: Curves.easeOut,
    );

    unawaited(
      audio.setReleaseMode(
        ReleaseMode.stop,
      ),
    );

    final allQuestions =
        List<Question>.from(
      widget.questions ??
          questionsByGrade[
              widget.grade] ??
          <Question>[],
    );

    final filteredQuestions =
        widget.subject == null
            ? allQuestions
            : allQuestions
                .where(
                  (question) =>
                      question.subject ==
                      widget.subject,
                )
                .toList();

    questions =
        _shuffleQuestions(
      filteredQuestions,
    );

    if (questions.isNotEmpty) {
      startTimer();
    }
  }

  List<Question> _shuffleQuestions(
    List<Question> source,
  ) {
    final random = Random();

    final result =
        source.map(
      (question) {
        final options =
            List<String>.from(
          question.options,
        );

        options.shuffle(random);

        return question.withOptions(
          options,
        );
      },
    ).toList();

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

  void chooseAnswer(
    int index,
  ) {
    if (answered || showFeedback) {
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

    unawaited(
      showAnswerFeedback(correct),
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
      // Audio gagal tidak menghentikan kuis.
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

    if (current >=
        questions.length - 1) {
      timer?.cancel();

      final total =
          questions.length * 10;

      await widget.onFinished(
        score,
        total,
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ResultPage(
            grade: widget.grade,
            score: score,
            total: total,
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
  Widget build(
    BuildContext context,
  ) {
    if (questions.isEmpty) {
      return Scaffold(
        body: SchoolBackground(
          child: Center(
            child: Container(
              margin:
                  const EdgeInsets.all(24),
              padding:
                  const EdgeInsets.all(28),
              decoration:
                  BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(
                  28,
                ),
                boxShadow: const [
                  BoxShadow(
                    color:
                        Color(0x18000000),
                    blurRadius: 22,
                    offset:
                        Offset(0, 10),
                  ),
                ],
              ),
              child: const Column(
                mainAxisSize:
                    MainAxisSize.min,
                children: [
                  Icon(
                    Icons
                        .menu_book_rounded,
                    size: 62,
                    color:
                        Color(0xFF4B7BEC),
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  Text(
                    'Soal belum tersedia.',
                    textAlign:
                        TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight:
                          FontWeight.w900,
                      color:
                          Color(
                        0xFF263E5D,
                      ),
                    ),
                  ),
                ],
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
        showSchoolIllustrations: false,
        child: SafeArea(
          child: Stack(
            children: [
              Scrollbar(
                thumbVisibility:
                    MediaQuery.sizeOf(
                              context,
                            ).width >=
                        900,
                trackVisibility:
                    MediaQuery.sizeOf(
                              context,
                            ).width >=
                        900,
                interactive: true,
                thickness: 8,
                radius:
                    const Radius.circular(
                  20,
                ),
                child: ListView(
                  padding:
                      const EdgeInsets
                          .fromLTRB(
                    18,
                    15,
                    18,
                    90,
                  ),
                  children: [
                    Center(
                      child:
                          ConstrainedBox(
                        constraints:
                            const BoxConstraints(
                          maxWidth: 1050,
                        ),
                        child:
                            Column(
                          children: [
                            _QuizHeader(
                              grade:
                                  widget.grade,
                              name:
                                  widget.studentName,
                              current:
                                  current + 1,
                              total:
                                  questions.length,
                              progress:
                                  progress,
                              topic:
                                  widget.topic,
                            ),

                            const SizedBox(
                              height: 13,
                            ),

                            _Timer(
                              seconds,
                            ),

                            const SizedBox(
                              height: 15,
                            ),

                            _QuestionCard(
                              question:
                                  question,
                              topic:
                                  widget.topic,
                            ),

                            const SizedBox(
                              height: 15,
                            ),

                            ...List.generate(
                              question
                                  .options
                                  .length,
                              (index) {
                                return _AnswerOption(
                                  question:
                                      question,
                                  index:
                                      index,
                                  selected:
                                      selected,
                                  answered:
                                      answered,
                                  onTap:
                                      chooseAnswer,
                                );
                              },
                            ),

                            if (answered)
                              _ExplanationCard(
                                question:
                                    question,
                                selected:
                                    selected,
                                timedOut:
                                    timedOut,
                              ),

                            if (answered)
                              const Padding(
                                padding:
                                    EdgeInsets
                                        .only(
                                  top: 13,
                                ),
                                child:
                                    Text(
                                  '✨ Soal berikutnya akan terbuka otomatis...',
                                  textAlign:
                                      TextAlign
                                          .center,
                                  style:
                                      TextStyle(
                                    color:
                                        Color(
                                      0xFF667D92,
                                    ),
                                    fontSize:
                                        12,
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
                  ],
                ),
              ),

              if (showFeedback)
                Positioned.fill(
                  child:
                      IgnorePointer(
                    child:
                        Container(
                      color:
                          const Color(
                        0x5524445D,
                      ),
                      alignment:
                          Alignment
                              .center,
                      child:
                          AnimatedBuilder(
                        animation:
                            feedbackController,
                        builder:
                            (
                          context,
                          child,
                        ) {
                          return Opacity(
                            opacity:
                                opacityAnimation
                                    .value,
                            child:
                                Transform
                                    .scale(
                              scale:
                                  scaleAnimation
                                      .value,
                              child:
                                  child,
                            ),
                          );
                        },
                        child:
                            _FeedbackCard(
                          correct:
                              feedbackCorrect,
                          question:
                              question,
                          timedOut:
                              timedOut,
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

// ============================================================
// HEADER
// ============================================================

class _QuizHeader
    extends StatelessWidget {
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
  Widget build(
    BuildContext context,
  ) {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(16),
      decoration:
          BoxDecoration(
        color: Colors.white
            .withOpacity(.97),
        borderRadius:
            BorderRadius.circular(
          25,
        ),
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x16000000),
            blurRadius: 18,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 53,
            height: 53,
            decoration:
                const BoxDecoration(
              gradient:
                  LinearGradient(
                colors: [
                  Color(0xFFFFD66B),
                  Color(0xFFFFA94D),
                ],
              ),
              borderRadius:
                  BorderRadius.all(
                Radius.circular(17),
              ),
            ),
            child: const Icon(
              Icons
                  .school_rounded,
              color: Colors.white,
              size: 29,
            ),
          ),

          const SizedBox(
            width: 12,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              children: [
                Text(
                  'Kelas $grade • $name',
                  maxLines: 1,
                  overflow:
                      TextOverflow
                          .ellipsis,
                  style:
                      const TextStyle(
                    fontSize: 15,
                    fontWeight:
                        FontWeight.w900,
                    color:
                        Color(
                      0xFF243B5A,
                    ),
                  ),
                ),

                if (topic != null)
                  Padding(
                    padding:
                        const EdgeInsets
                            .only(
                      top: 3,
                    ),
                    child: Text(
                      topic!,
                      maxLines: 1,
                      overflow:
                          TextOverflow
                              .ellipsis,
                      style:
                          const TextStyle(
                        fontSize: 11,
                        fontWeight:
                            FontWeight.w800,
                        color:
                            Color(
                          0xFF4F8FF7,
                        ),
                      ),
                    ),
                  ),

                const SizedBox(
                  height: 7,
                ),

                ClipRRect(
                  borderRadius:
                      BorderRadius
                          .circular(
                    20,
                  ),
                  child:
                      LinearProgressIndicator(
                    value: progress
                        .clamp(
                      0.0,
                      1.0,
                    ),
                    minHeight: 9,
                    backgroundColor:
                        const Color(
                      0xFFE7EEF5,
                    ),
                    valueColor:
                        const AlwaysStoppedAnimation(
                      Color(
                        0xFF45C77A,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(
            width: 12,
          ),

          Container(
            padding:
                const EdgeInsets
                    .symmetric(
              horizontal: 11,
              vertical: 8,
            ),
            decoration:
                BoxDecoration(
              color:
                  const Color(
                0xFFEAF3FF,
              ),
              borderRadius:
                  BorderRadius.circular(
                13,
              ),
            ),
            child: Text(
              '$current/$total',
              style:
                  const TextStyle(
                fontWeight:
                    FontWeight.w900,
                color:
                    Color(
                  0xFF4F8FF7,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// TIMER
// ============================================================

class _Timer
    extends StatelessWidget {
  const _Timer(this.seconds);

  final int seconds;

  @override
  Widget build(
    BuildContext context,
  ) {
    final danger =
        seconds <= 5;

    return Center(
      child:
          AnimatedContainer(
        duration:
            const Duration(
          milliseconds: 250,
        ),
        padding:
            const EdgeInsets
                .symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        decoration:
            BoxDecoration(
          gradient: LinearGradient(
            colors: danger
                ? const [
                    Color(0xFFFFEBEB),
                    Color(0xFFFFDADA),
                  ]
                : const [
                    Color(0xFFFFFFFF),
                    Color(0xFFF0F7FF),
                  ],
          ),
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
                    0xFFBFD8F4,
                  ),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: danger
                  ? const Color(
                      0x25EF6262,
                    )
                  : const Color(
                      0x124B7BEC,
                    ),
              blurRadius: 12,
              offset:
                  const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            Icon(
              danger
                  ? Icons
                      .timer_off_rounded
                  : Icons
                      .timer_rounded,
              color: danger
                  ? const Color(
                      0xFFE65353,
                    )
                  : const Color(
                      0xFF4F8FF7,
                    ),
              size: 22,
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              '$seconds detik',
              style:
                  TextStyle(
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

// ============================================================
// QUESTION CARD
// ============================================================

class _QuestionCard
    extends StatelessWidget {
  const _QuestionCard({
    required this.question,
    this.topic,
  });

  final Question question;
  final String? topic;

  Color _subjectColor(
    String subject,
  ) {
    switch (subject) {
      case 'Matematika':
        return const Color(
          0xFF4B7BEC,
        );
      case 'Bahasa Indonesia':
        return const Color(
          0xFFFF718F,
        );
      case 'IPA':
        return const Color(
          0xFF45C878,
        );
      case 'Logika':
        return const Color(
          0xFF9B7BEA,
        );
      default:
        return const Color(
          0xFFFFB84D,
        );
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final color =
        _subjectColor(
      question.subject,
    );

    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.fromLTRB(
        17,
        17,
        17,
        18,
      ),
      decoration:
          BoxDecoration(
        gradient:
            const LinearGradient(
          begin:
              Alignment.topLeft,
          end:
              Alignment.bottomRight,
          colors: [
            Color(0xFF65CFFF),
            Color(0xFF4B7BEC),
            Color(0xFF726BEA),
          ],
        ),
        borderRadius:
            BorderRadius.circular(
          30,
        ),
        border: Border.all(
          color: Colors.white,
          width: 3,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x304B7BEC),
            blurRadius: 25,
            offset:
                Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets
                        .symmetric(
                  horizontal: 13,
                  vertical: 7,
                ),
                decoration:
                    BoxDecoration(
                  color:
                      Colors.white,
                  borderRadius:
                      BorderRadius
                          .circular(
                    30,
                  ),
                ),
                child: Row(
                  mainAxisSize:
                      MainAxisSize.min,
                  children: [
                    Icon(
                      Icons
                          .auto_awesome_rounded,
                      size: 15,
                      color: color,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      question.subject,
                      style:
                          TextStyle(
                        fontSize: 11,
                        fontWeight:
                            FontWeight.w900,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),

              if (topic != null) ...[
                const SizedBox(
                  width: 8,
                ),
                Flexible(
                  child:
                      Container(
                    padding:
                        const EdgeInsets
                            .symmetric(
                      horizontal: 11,
                      vertical: 7,
                    ),
                    decoration:
                        BoxDecoration(
                      color: Colors
                          .white
                          .withOpacity(
                        .78,
                      ),
                      borderRadius:
                          BorderRadius
                              .circular(
                        30,
                      ),
                    ),
                    child:
                        Text(
                      topic!,
                      overflow:
                          TextOverflow
                              .ellipsis,
                      style:
                          const TextStyle(
                        fontSize: 10,
                        fontWeight:
                            FontWeight
                                .w800,
                        color:
                            Color(
                          0xFF425675,
                        ),
                      ),
                    ),
                  ),
                ),
              ],

              const Spacer(),

              const Text(
                '✨',
                style:
                    TextStyle(
                  fontSize: 23,
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 13,
          ),

          Container(
            width: double.infinity,
            padding:
                const EdgeInsets
                    .symmetric(
              horizontal: 19,
              vertical: 24,
            ),
            decoration:
                BoxDecoration(
              color: Colors.white
                  .withOpacity(.97),
              borderRadius:
                  BorderRadius.circular(
                23,
              ),
            ),
            child: Text(
              question.question,
              textAlign:
                  TextAlign.center,
              style:
                  const TextStyle(
                fontSize: 21,
                fontWeight:
                    FontWeight.w900,
                color:
                    Color(
                  0xFF263B54,
                ),
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// ANSWER OPTION
// ============================================================

class _AnswerOption
    extends StatelessWidget {
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
  Widget build(
    BuildContext context,
  ) {
    final isCorrect =
        index == question.answer;

    final isWrong =
        answered &&
        selected == index &&
        !isCorrect;

    final isGood =
        answered &&
        isCorrect;

    final borderColor =
        isGood
            ? const Color(
                0xFF43C77A,
              )
            : isWrong
                ? const Color(
                    0xFFEF6262,
                  )
                : const Color(
                    0xFFD7E5F1,
                  );

    final backgroundColor =
        isGood
            ? const Color(
                0xFFE9FFF2,
              )
            : isWrong
                ? const Color(
                    0xFFFFEEEE,
                  )
                : Colors.white
                    .withOpacity(.97);

    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 10,
      ),
      child: PressableCard(
        onTap: answered
            ? () {}
            : () => onTap(index),
        child:
            AnimatedContainer(
          duration:
              const Duration(
            milliseconds: 220,
          ),
          padding:
              const EdgeInsets
                  .symmetric(
            horizontal: 14,
            vertical: 12,
          ),
          decoration:
              BoxDecoration(
            color:
                backgroundColor,
            borderRadius:
                BorderRadius.circular(
              20,
            ),
            border: Border.all(
              color: borderColor,
              width:
                  isGood ||
                          isWrong
                      ? 2
                      : 1.5,
            ),
            boxShadow:
                isGood ||
                        isWrong
                    ? [
                        BoxShadow(
                          color:
                              borderColor
                                  .withOpacity(
                            .18,
                          ),
                          blurRadius:
                              12,
                          offset:
                              const Offset(
                            0,
                            5,
                          ),
                        ),
                      ]
                    : const [
                        BoxShadow(
                          color:
                              Color(
                            0x0D000000,
                          ),
                          blurRadius:
                              7,
                          offset:
                              Offset(
                            0,
                            3,
                          ),
                        ),
                      ],
          ),
          child: Row(
            children: [
              Container(
                width: 45,
                height: 45,
                alignment:
                    Alignment.center,
                decoration:
                    BoxDecoration(
                  gradient:
                      isGood
                          ? const LinearGradient(
                              colors: [
                                Color(
                                  0xFF55D887,
                                ),
                                Color(
                                  0xFF36B96D,
                                ),
                              ],
                            )
                          : isWrong
                              ? const LinearGradient(
                                  colors: [
                                    Color(
                                      0xFFFF8181,
                                    ),
                                    Color(
                                      0xFFEF6262,
                                    ),
                                  ],
                                )
                              : const LinearGradient(
                                  colors: [
                                    Color(
                                      0xFFEAF3FF,
                                    ),
                                    Color(
                                      0xFFDCEAFF,
                                    ),
                                  ],
                                ),
                  borderRadius:
                      BorderRadius
                          .circular(
                    14,
                  ),
                ),
                child: Text(
                  String.fromCharCode(
                    65 + index,
                  ),
                  style:
                      TextStyle(
                    color: isGood ||
                            isWrong
                        ? Colors.white
                        : const Color(
                            0xFF4F8FF7,
                          ),
                    fontWeight:
                        FontWeight.w900,
                    fontSize: 15,
                  ),
                ),
              ),

              const SizedBox(
                width: 12,
              ),

              Expanded(
                child: Text(
                  question
                      .options[index],
                  style:
                      const TextStyle(
                    fontSize: 15,
                    fontWeight:
                        FontWeight.w700,
                    color:
                        Color(
                      0xFF2D455F,
                    ),
                    height: 1.35,
                  ),
                ),
              ),

              if (isGood)
                const Icon(
                  Icons
                      .check_circle_rounded,
                  color:
                      Color(
                    0xFF43C77A,
                  ),
                  size: 25,
                ),

              if (isWrong)
                const Icon(
                  Icons
                      .cancel_rounded,
                  color:
                      Color(
                    0xFFEF6262,
                  ),
                  size: 25,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// EXPLANATION
// ============================================================

class _ExplanationCard
    extends StatelessWidget {
  const _ExplanationCard({
    required this.question,
    required this.selected,
    required this.timedOut,
  });

  final Question question;
  final int? selected;
  final bool timedOut;

  @override
  Widget build(
    BuildContext context,
  ) {
    final correct =
        selected != null &&
        selected ==
            question.answer;

    final title = correct
        ? '🎉 Jawaban benar!'
        : timedOut
            ? '⏰ Waktu habis'
            : '💡 Belum tepat, yuk belajar lagi';

    final explanation =
        correct
            ? question.explanation
            : 'Jawaban yang benar adalah '
                '"${question.options[question.answer]}". '
                '${question.explanation}';

    final color = correct
        ? const Color(
            0xFF43C77A,
          )
        : const Color(
            0xFFF0A35A,
          );

    return Container(
      width: double.infinity,
      margin:
          const EdgeInsets.only(
        top: 5,
      ),
      padding:
          const EdgeInsets.all(
        17,
      ),
      decoration:
          BoxDecoration(
        gradient:
            LinearGradient(
          colors: correct
              ? const [
                  Color(0xFFE9FFF2),
                  Color(0xFFF5FFFA),
                ]
              : const [
                  Color(0xFFFFF1E9),
                  Color(0xFFFFF9F3),
                ],
        ),
        borderRadius:
            BorderRadius.circular(
          22,
        ),
        border: Border.all(
          color: color.withOpacity(
            .25,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment
                .start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration:
                BoxDecoration(
              color:
                  color.withOpacity(
                .15,
              ),
              shape:
                  BoxShape.circle,
            ),
            child: Icon(
              correct
                  ? Icons
                      .check_rounded
                  : Icons
                      .lightbulb_rounded,
              color: color,
              size: 24,
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
                  title,
                  style:
                      const TextStyle(
                    fontWeight:
                        FontWeight.w900,
                    color:
                        Color(
                      0xFF29435F,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 7,
                ),

                Text(
                  explanation,
                  style:
                      const TextStyle(
                    color:
                        Color(
                      0xFF5E7183,
                    ),
                    height: 1.45,
                    fontWeight:
                        FontWeight.w600,
                    fontSize: 12,
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

// ============================================================
// FEEDBACK POPUP
// ============================================================

class _FeedbackCard
    extends StatelessWidget {
  const _FeedbackCard({
    required this.correct,
    required this.question,
    required this.timedOut,
  });

  final bool correct;
  final Question question;
  final bool timedOut;

  @override
  Widget build(
    BuildContext context,
  ) {
    final title = correct
        ? 'Jawaban Benar! 🎉'
        : timedOut
            ? 'Waktu Habis ⏰'
            : 'Belum Tepat 💪';

    final subtitle = correct
        ? question.explanation
        : 'Jawaban yang benar adalah '
            '"${question.options[question.answer]}". '
            '${question.explanation}';

    final mainColor = correct
        ? const Color(
            0xFF36B96D,
          )
        : const Color(
            0xFFEF6262,
          );

    return Container(
      width: 430,
      constraints:
          const BoxConstraints(
        maxWidth: 430,
      ),
      margin:
          const EdgeInsets.all(22),
      padding:
          const EdgeInsets.fromLTRB(
        23,
        24,
        23,
        26,
      ),
      decoration:
          BoxDecoration(
        gradient:
            const LinearGradient(
          begin:
              Alignment.topCenter,
          end:
              Alignment.bottomCenter,
          colors: [
            Colors.white,
            Color(0xFFF7FBFF),
          ],
        ),
        borderRadius:
            BorderRadius.circular(
          32,
        ),
        border: Border.all(
          color: Colors.white,
          width: 3,
        ),
        boxShadow:
            const [
          BoxShadow(
            color:
                Color(0x45000000),
            blurRadius: 32,
            offset:
                Offset(0, 13),
          ),
        ],
      ),
      child: Column(
        mainAxisSize:
            MainAxisSize.min,
        children: [
          Container(
            width: 84,
            height: 84,
            decoration:
                BoxDecoration(
              gradient:
                  LinearGradient(
                colors: correct
                    ? const [
                        Color(
                          0xFF55D887,
                        ),
                        Color(
                          0xFF36B96D,
                        ),
                      ]
                    : const [
                        Color(
                          0xFFFF8181,
                        ),
                        Color(
                          0xFFEF6262,
                        ),
                      ],
              ),
              shape:
                  BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: mainColor
                      .withOpacity(
                    .25,
                  ),
                  blurRadius: 17,
                  offset:
                      const Offset(
                    0,
                    7,
                  ),
                ),
              ],
            ),
            child: Icon(
              correct
                  ? Icons
                      .check_rounded
                  : timedOut
                      ? Icons
                          .timer_off_rounded
                      : Icons
                          .close_rounded,
              color:
                  Colors.white,
              size: 50,
            ),
          ),

          const SizedBox(
            height: 14,
          ),

          Text(
            title,
            textAlign:
                TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              fontWeight:
                  FontWeight.w900,
              color: mainColor,
            ),
          ),

          const SizedBox(
            height: 11,
          ),

          Container(
            width:
                double.infinity,
            padding:
                const EdgeInsets
                    .all(16),
            decoration:
                BoxDecoration(
              color: correct
                  ? const Color(
                      0xFFE9FFF2,
                    )
                  : const Color(
                      0xFFFFF1F1,
                    ),
              borderRadius:
                  BorderRadius.circular(
                19,
              ),
            ),
            child: Text(
              subtitle,
              textAlign:
                  TextAlign.center,
              style:
                  const TextStyle(
                fontSize: 13,
                height: 1.5,
                fontWeight:
                    FontWeight.w600,
                color:
                    Color(
                  0xFF4E6478,
                ),
              ),
            ),
          ),

          const SizedBox(
            height: 14,
          ),

          const Row(
            mainAxisSize:
                MainAxisSize.min,
            children: [
              Text(
                '✨',
                style:
                    TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(
                width: 7,
              ),
              Text(
                'Sebentar lagi lanjut...',
                textAlign:
                    TextAlign.center,
                style:
                    TextStyle(
                  fontSize: 11,
                  fontWeight:
                      FontWeight.w700,
                  color:
                      Color(
                    0xFF8798A7,
                  ),
                ),
              ),
              SizedBox(
                width: 7,
              ),
              Text(
                '✨',
                style:
                    TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}