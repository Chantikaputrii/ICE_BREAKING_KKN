import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../data/question_bank.dart';
import '../models/question.dart';
import '../services/animated_question_api.dart';
import 'result_page.dart';
import 'school_ui.dart';

class QuizPage extends StatefulWidget {
  final int grade;
  final String? subject;
  final Future<void> Function(
    int score,
    int total,
  ) onFinished;
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
  State<QuizPage> createState() =>
      _QuizPageState();
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

  bool _showAnswerAnimation = false;
  bool _lastAnswerCorrect = false;

  late AnimationController _feedbackController;
  late Animation<double> _feedbackScale;
  late Animation<double> _feedbackOpacity;

  final AudioPlayer _audioPlayer =
      AudioPlayer();

  @override
  void initState() {
    super.initState();

    _feedbackController =
        AnimationController(
      vsync: this,
      duration:
          const Duration(milliseconds: 600),
    );

    _feedbackScale = CurvedAnimation(
      parent: _feedbackController,
      curve: Curves.elasticOut,
    );

    _feedbackOpacity =
        Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _feedbackController,
        curve: Curves.easeOut,
      ),
    );

    unawaited(
      _audioPlayer.setReleaseMode(
        ReleaseMode.stop,
      ),
    );

    final allQuestions =
        widget.questions ??
            questionsByGrade[
                widget.grade] ??
            [];

    if (widget.questions != null) {
      questions =
          _shuffleQuestions(
        widget.questions!,
      );
    } else if (widget.subject == null) {
      questions =
          _shuffleQuestions(
        allQuestions,
      );
    } else {
      final subjectQuestions =
          allQuestions
              .where(
                (question) =>
                    question.subject ==
                    widget.subject,
              )
              .toList();

      questions =
          _shuffleQuestions(
        subjectQuestions,
      );
    }

    _startTimer();
    _loadRemoteVisuals();
  }

  Future<void> _loadRemoteVisuals() async {
    if (questions.isEmpty) return;

    final visuals =
        await AnimatedQuestionApi()
            .loadVisuals(
      questions
          .where(
            (question) =>
                question.isAnimated,
          )
          .map(
            (question) => question.id,
          )
          .toList(),
    );

    if (!mounted) return;

    if (visuals.isNotEmpty) {
      setState(() {
        _remoteVisuals = visuals;
      });
    }
  }

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

  List<Question> _shuffleQuestions(
    List<Question> source,
  ) {
    final random = Random();

    final shuffled =
        source.map((question) {
      final options =
          List<String>.from(
        question.options,
      );

      options.shuffle(random);

      return question.withOptions(
        options,
      );
    }).toList();

    shuffled.shuffle(random);

    return shuffled;
  }

  void chooseAnswer(int index) {
    if (answered ||
        _showAnswerAnimation) {
      return;
    }

    _timer?.cancel();

    final question =
        questions[currentQuestion];

    final correct =
        index == question.answer;

    setState(() {
      selectedAnswer = index;
      answered = true;
      timedOut = false;
      _lastAnswerCorrect = correct;

      if (correct) {
        score += 10;
      }
    });

    unawaited(
      _playAnswerSound(correct),
    );

    _showFeedback(correct);
  }

  Future<void> _showFeedback(
    bool correct,
  ) async {
    if (!mounted) return;

    setState(() {
      _lastAnswerCorrect = correct;
      _showAnswerAnimation = true;
    });

    _feedbackController.reset();

    await _feedbackController.forward();

    if (!mounted) return;

    await Future.delayed(
      const Duration(
        milliseconds: 800,
      ),
    );

    if (!mounted) return;

    await _feedbackController.reverse();

    if (!mounted) return;

    setState(() {
      _showAnswerAnimation = false;
    });
  }

  Future<void> _playAnswerSound(
    bool correct,
  ) async {
    try {
      await _audioPlayer.play(
        AssetSource(
          correct
              ? 'BENAR.mp3'
              : 'wrong.wav',
        ),
      );
    } catch (_) {}
  }

  Future<void> nextQuestion() async {
    if (!answered) return;

    if (_showAnswerAnimation) return;

    if (currentQuestion ==
        questions.length - 1) {
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
            total:
                questions.length * 10,
            studentName:
                widget.studentName,
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
  void dispose() {
    _timer?.cancel();
    _feedbackController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return Scaffold(
        body: SchoolBackground(
          child: Center(
            child: Container(
              margin:
                  const EdgeInsets.all(25),
              padding:
                  const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(25),
              ),
              child: const Text(
                'Soal untuk mata pelajaran ini belum tersedia.',
                textAlign:
                    TextAlign.center,
              ),
            ),
          ),
        ),
      );
    }

    final question =
        questions[currentQuestion];

    final progress =
        (currentQuestion + 1) /
            questions.length;

    return Scaffold(
      body: Stack(
        children: [
          SchoolBackground(
            child: SafeArea(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.fromLTRB(
                  18,
                  15,
                  18,
                  35,
                ),
                child: Column(
                  children: [
                    _buildHeader(),

                    const SizedBox(height: 15),

                    _buildProgress(progress),

                    const SizedBox(height: 15),

                    _buildTimer(),

                    const SizedBox(height: 18),

                    _buildQuestion(question),

                    const SizedBox(height: 18),

                    _buildAnswers(question),

                    if (answered) ...[
                      const SizedBox(height: 8),
                      _buildExplanation(
                        question,
                      ),
                    ],

                    const SizedBox(height: 18),

                    _buildNextButton(),
                  ],
                ),
              ),
            ),
          ),

          if (_showAnswerAnimation)
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  color:
                      Colors.black.withOpacity(
                    .12,
                  ),
                  child: Center(
                    child: AnimatedBuilder(
                      animation:
                          _feedbackController,
                      builder:
                          (context, child) {
                        return Opacity(
                          opacity:
                              _feedbackOpacity
                                  .value,
                          child:
                              Transform.scale(
                            scale:
                                _feedbackScale
                                    .value,
                            child: child,
                          ),
                        );
                      },
                      child:
                          _BigAnswerFeedback(
                        correct:
                            _lastAnswerCorrect,
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

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(15),
          ),
          child: IconButton(
            onPressed: () =>
                Navigator.pop(context),
            icon: const Icon(
              Icons.close_rounded,
              color:
                  SchoolColors.darkBlue,
            ),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                'Kelas ${widget.grade} SD',
                style: const TextStyle(
                  color:
                      SchoolColors.darkBlue,
                  fontSize: 18,
                  fontWeight:
                      FontWeight.w900,
                ),
              ),
              Text(
                'Ayo jawab dengan benar!',
                style: const TextStyle(
                  color:
                      Color(0xFF718399),
                  fontSize: 11,
                  fontWeight:
                      FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        AnimatedAssetCharacter(
          asset:
              'assets/Gambar guru p.jpeg',
          width: 52,
          height: 52,
        ),
      ],
    );
  }

  Widget _buildProgress(
    double progress,
  ) {
    return Container(
      padding:
          const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius:
                  BorderRadius.circular(20),
              child:
                  LinearProgressIndicator(
                value: progress,
                minHeight: 12,
                backgroundColor:
                    const Color(
                  0xFFE7EEF6,
                ),
                valueColor:
                    const AlwaysStoppedAnimation(
                  SchoolColors.green,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${currentQuestion + 1}/${questions.length}',
            style: const TextStyle(
              color:
                  SchoolColors.darkBlue,
              fontWeight:
                  FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimer() {
    final danger =
        secondsRemaining <= 5;

    return AnimatedContainer(
      duration:
          const Duration(milliseconds: 250),
      padding:
          const EdgeInsets.symmetric(
        horizontal: 17,
        vertical: 11,
      ),
      decoration: BoxDecoration(
        color: danger
            ? const Color(0xFFFFE5E5)
            : Colors.white,
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color: danger
              ? Colors.redAccent
              : const Color(
                  0xFFE3EDF7,
                ),
        ),
      ),
      child: Row(
        mainAxisSize:
            MainAxisSize.min,
        children: [
          AnimatedSwitcher(
            duration:
                const Duration(
              milliseconds: 200,
            ),
            child: Icon(
              Icons.timer_rounded,
              key: ValueKey(
                danger,
              ),
              color: danger
                  ? Colors.red
                  : SchoolColors.blue,
            ),
          ),
          const SizedBox(width: 7),
          Text(
            '$secondsRemaining detik',
            style: TextStyle(
              color: danger
                  ? Colors.red
                  : SchoolColors.darkBlue,
              fontWeight:
                  FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestion(
    Question question,
  ) {
    return AnimatedSwitcher(
      duration:
          const Duration(milliseconds: 450),
      transitionBuilder:
          (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position:
                Tween<Offset>(
              begin:
                  const Offset(.15, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: Container(
        key: ValueKey(
          currentQuestion,
        ),
        width: double.infinity,
        padding:
            const EdgeInsets.fromLTRB(
          20,
          20,
          20,
          24,
        ),
        decoration: BoxDecoration(
          gradient:
              const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFD968),
              Color(0xFFFFB85C),
            ],
          ),
          borderRadius:
              BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: SchoolColors
                  .orange
                  .withOpacity(.16),
              blurRadius: 20,
              offset:
                  const Offset(0, 9),
            ),
          ],
        ),
        child: Column(
          children: [
            if (question.visual != null)
              _QuestionVisual(
                visual:
                    question.visual!,
                isAnimated:
                    question.isAnimated,
                remoteImageUrl:
                    _remoteVisuals[
                        question.id],
              ),

            if (question.visual != null)
              const SizedBox(
                height: 10,
              ),

            Container(
              padding:
                  const EdgeInsets
                      .symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration:
                  BoxDecoration(
                color: Colors.white
                    .withOpacity(.65),
                borderRadius:
                    BorderRadius.circular(
                  15,
                ),
              ),
              child: Text(
                question.subject,
                style:
                    const TextStyle(
                  color:
                      Color(0xFF745300),
                  fontSize: 11,
                  fontWeight:
                      FontWeight.w900,
                ),
              ),
            ),

            const SizedBox(height: 14),

            Text(
              question.question,
              textAlign:
                  TextAlign.center,
              style:
                  const TextStyle(
                color:
                    SchoolColors.darkBlue,
                fontSize: 24,
                height: 1.25,
                fontWeight:
                    FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswers(
    Question question,
  ) {
    return Column(
      children: List.generate(
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

          final color =
              showCorrect
                  ? SchoolColors.green
                  : showWrong
                      ? Colors.redAccent
                      : SchoolColors.blue;

          return Padding(
            padding:
                const EdgeInsets.only(
              bottom: 12,
            ),
            child: PressableCard(
              onTap:
                  answered ||
                          _showAnswerAnimation
                      ? () {}
                      : () =>
                          chooseAnswer(index),
              child: AnimatedContainer(
                duration:
                    const Duration(
                  milliseconds: 250,
                ),
                padding:
                    const EdgeInsets.all(
                  15,
                ),
                decoration:
                    BoxDecoration(
                  color: showCorrect
                      ? const Color(
                          0xFFE6F9ED,
                        )
                      : showWrong
                          ? const Color(
                              0xFFFFE7E7,
                            )
                          : Colors.white,
                  borderRadius:
                      BorderRadius.circular(
                    20,
                  ),
                  border: Border.all(
                    color: showCorrect ||
                            showWrong
                        ? color
                        : const Color(
                            0xFFE3ECF6,
                          ),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: color
                          .withOpacity(.06),
                      blurRadius: 15,
                      offset:
                          const Offset(
                        0,
                        5,
                      ),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration:
                          BoxDecoration(
                        color: color
                            .withOpacity(
                          .13,
                        ),
                        borderRadius:
                            BorderRadius
                                .circular(
                          14,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          String.fromCharCode(
                            65 + index,
                          ),
                          style:
                              TextStyle(
                            color: color,
                            fontWeight:
                                FontWeight
                                    .w900,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                      width: 13,
                    ),

                    Expanded(
                      child: Text(
                        question
                            .options[index],
                        style:
                            const TextStyle(
                          color:
                              SchoolColors
                                  .darkBlue,
                          fontSize: 15,
                          fontWeight:
                              FontWeight.w700,
                        ),
                      ),
                    ),

                    if (showCorrect)
                      const Icon(
                        Icons
                            .check_circle_rounded,
                        color:
                            SchoolColors.green,
                      ),

                    if (showWrong)
                      const Icon(
                        Icons
                            .cancel_rounded,
                        color:
                            Colors.redAccent,
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildExplanation(
    Question question,
  ) {
    final correct =
        selectedAnswer ==
            question.answer;

    return AnimatedSwitcher(
      duration:
          const Duration(milliseconds: 350),
      child: Container(
        key: ValueKey(
          '${currentQuestion}_$selectedAnswer',
        ),
        width: double.infinity,
        padding:
            const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: correct
              ? const Color(0xFFE7F9EE)
              : const Color(0xFFFFE8E8),
          borderRadius:
              BorderRadius.circular(20),
        ),
        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            _AnswerStatusIcon(
              isCorrect: correct,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                correct
                    ? 'Jawaban benar! ${question.explanation}'
                    : timedOut
                        ? 'Waktu habis. Jawaban yang benar adalah "${question.options[question.answer]}". ${question.explanation}'
                        : 'Belum tepat. Jawaban yang benar adalah "${question.options[question.answer]}". ${question.explanation}',
                style: const TextStyle(
                  color:
                      SchoolColors.darkBlue,
                  fontWeight:
                      FontWeight.w700,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed:
            answered &&
                    !_showAnswerAnimation
                ? nextQuestion
                : null,
        icon: Icon(
          currentQuestion ==
                  questions.length - 1
              ? Icons
                  .emoji_events_rounded
              : Icons
                  .arrow_forward_rounded,
        ),
        label: Text(
          currentQuestion ==
                  questions.length - 1
              ? 'Lihat Nilai'
              : 'Soal Berikutnya',
        ),
      ),
    );
  }
}

class _BigAnswerFeedback
    extends StatelessWidget {
  const _BigAnswerFeedback({
    required this.correct,
  });

  final bool correct;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 180,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: correct
            ? SchoolColors.green
            : Colors.redAccent,
        boxShadow: [
          BoxShadow(
            color: (correct
                    ? SchoolColors.green
                    : Colors.redAccent)
                .withOpacity(.35),
            blurRadius: 35,
            spreadRadius: 8,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          Icon(
            correct
                ? Icons.check_rounded
                : Icons.close_rounded,
            color: Colors.white,
            size: 80,
          ),
          Text(
            correct
                ? 'HEBAT!'
                : 'COBA LAGI!',
            style: const TextStyle(
              color: Colors.white,
              fontWeight:
                  FontWeight.w900,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestionVisual
    extends StatelessWidget {
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
        height: 95,
        errorBuilder: (_, __, ___) {
          return Text(
            visual,
            style: const TextStyle(
              fontSize: 44,
            ),
          );
        },
      );
    }

    if (!isAnimated) {
      return Text(
        visual,
        style: const TextStyle(
          fontSize: 44,
        ),
      );
    }

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(
        begin: .75,
        end: 1,
      ),
      duration:
          const Duration(milliseconds: 650),
      curve: Curves.elasticOut,
      builder:
          (context, value, child) {
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

class _AnswerStatusIcon
    extends StatelessWidget {
  const _AnswerStatusIcon({
    required this.isCorrect,
  });

  final bool isCorrect;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(
        begin: .3,
        end: 1,
      ),
      duration:
          const Duration(milliseconds: 420),
      curve: Curves.elasticOut,
      builder:
          (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: Icon(
        isCorrect
            ? Icons.check_circle_rounded
            : Icons.cancel_rounded,
        color: isCorrect
            ? SchoolColors.green
            : Colors.redAccent,
        size: 38,
      ),
    );
  }
}
