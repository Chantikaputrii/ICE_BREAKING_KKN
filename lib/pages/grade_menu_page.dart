import 'package:flutter/material.dart';

import '../models/question.dart';
import '../models/score_record.dart';
import '../services/question_selection_service.dart';
import '../services/score_storage.dart';
import '../widgets/school_background.dart';
import 'quiz_page.dart';

class GradeMenuPage extends StatelessWidget {
  const GradeMenuPage({
    super.key,
    required this.grade,
  });

  final int grade;

  bool get hasTopicSelection => grade == 5 || grade == 6;

  Future<void> _start(
    BuildContext context, {
    String? topic,
  }) async {
    final name = await _showNameDialog(context);

    if (name == null || name.trim().isEmpty) {
      return;
    }

    if (!context.mounted) return;

    final questions =
        await QuestionSelectionService().selectQuestions(
      grade: grade,
      studentName: name.trim(),
      topic: topic,
    );

    if (!context.mounted) return;

    if (questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Soal untuk kelas ini belum tersedia.',
          ),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QuizPage(
          grade: grade,
          studentName: name.trim(),
          topic: topic,
          questions: questions,
          onFinished: (score, total) async {
            await ScoreStorage().saveRecord(
              ScoreRecord(
                name: name.trim(),
                grade: grade,
                score: score,
                total: total,
                completedAt: DateTime.now(),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<String?> _showNameDialog(
    BuildContext context,
  ) async {
    final controller = TextEditingController();

    final result = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            'Siapa nama kamu?',
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              color: Color(0xFF243B5A),
            ),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            textCapitalization:
                TextCapitalization.words,
            decoration: InputDecoration(
              hintText: 'Masukkan nama kamu',
              prefixIcon: const Icon(
                Icons.person_rounded,
              ),
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(16),
              ),
            ),
            onSubmitted: (_) {
              final value =
                  controller.text.trim();

              if (value.isNotEmpty) {
                Navigator.pop(
                  dialogContext,
                  value,
                );
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );
              },
              child: const Text(
                'Batal',
              ),
            ),
            FilledButton(
              onPressed: () {
                final value =
                    controller.text.trim();

                if (value.isEmpty) {
                  return;
                }

                Navigator.pop(
                  dialogContext,
                  value,
                );
              },
              child: const Text(
                'Mulai Kuis',
              ),
            ),
          ],
        );
      },
    );

    controller.dispose();

    return result;
  }

  Future<void> _chooseTopic(
    BuildContext context,
  ) async {
    final topic = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            'Pilih Tema Kuis',
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              color: Color(0xFF243B5A),
            ),
          ),
          content: const Text(
            'Pilih tema yang ingin kamu kerjakan terlebih dahulu.',
            style: TextStyle(
              color: Color(0xFF71869A),
              height: 1.4,
            ),
          ),
          actionsPadding:
              const EdgeInsets.fromLTRB(
            18,
            0,
            18,
            18,
          ),
          actions: [
            _TopicButton(
              icon: Icons.favorite_rounded,
              color: const Color(0xFFFF6F91),
              title: 'Stop Bullying',
              subtitle:
                  'Belajar tentang sikap saling menghargai',
              onTap: () {
                Navigator.pop(
                  dialogContext,
                  'Stop Bullying',
                );
              },
            ),
            const SizedBox(
              height: 10,
            ),
            _TopicButton(
              icon: Icons.eco_rounded,
              color: const Color(0xFF45C878),
              title: 'Adiwiyata',
              subtitle:
                  'Belajar tentang lingkungan sekolah',
              onTap: () {
                Navigator.pop(
                  dialogContext,
                  'Adiwiyata',
                );
              },
            ),
          ],
        );
      },
    );

    if (topic == null || !context.mounted) {
      return;
    }

    // Sesuai instruksi:
    // pilih tema terlebih dahulu,
    // baru muncul pengisian nama.
    await _start(
      context,
      topic: topic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SchoolBackground(
        child: SafeArea(
          child: Scrollbar(
            thumbVisibility:
                MediaQuery.sizeOf(context).width >= 900,
            trackVisibility:
                MediaQuery.sizeOf(context).width >= 900,
            interactive: true,
            thickness: 8,
            radius:
                const Radius.circular(20),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                20,
                20,
                20,
                80,
              ),
              children: [
                Center(
                  child: ConstrainedBox(
                    constraints:
                        const BoxConstraints(
                      maxWidth: 900,
                    ),
                    child: Column(
                      children: [
                        _Header(
                          grade: grade,
                        ),

                        const SizedBox(
                          height: 25,
                        ),

                        Container(
                          width:
                              double.infinity,
                          padding:
                              const EdgeInsets.all(
                            25,
                          ),
                          decoration:
                              BoxDecoration(
                            color: Colors.white
                                .withOpacity(.96),
                            borderRadius:
                                BorderRadius
                                    .circular(
                              28,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withOpacity(
                                  .07,
                                ),
                                blurRadius: 20,
                                offset:
                                    const Offset(
                                  0,
                                  8,
                                ),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Icon(
                                hasTopicSelection
                                    ? Icons
                                        .category_rounded
                                    : Icons
                                        .quiz_rounded,
                                size: 55,
                                color:
                                    const Color(
                                  0xFF4F8FF7,
                                ),
                              ),

                              const SizedBox(
                                height: 12,
                              ),

                              Text(
                                hasTopicSelection
                                    ? 'Pilih Tema Kuis'
                                    : 'Siap untuk Kuis?',
                                style:
                                    const TextStyle(
                                  fontSize: 24,
                                  fontWeight:
                                      FontWeight.w900,
                                  color:
                                      Color(
                                    0xFF243B5A,
                                  ),
                                ),
                              ),

                              const SizedBox(
                                height: 8,
                              ),

                              Text(
                                hasTopicSelection
                                    ? 'Untuk kelas 5 dan 6, pilih tema soal terlebih dahulu.'
                                    : 'Masukkan nama dan mulai menjawab soal sesuai tingkat kelasmu.',
                                textAlign:
                                    TextAlign.center,
                                style:
                                    const TextStyle(
                                  color:
                                      Color(
                                    0xFF71869A,
                                  ),
                                  height: 1.45,
                                ),
                              ),

                              const SizedBox(
                                height: 22,
                              ),

                              if (hasTopicSelection)
                                Row(
                                  children: [
                                    Expanded(
                                      child:
                                          _TopicCard(
                                        icon: Icons
                                            .favorite_rounded,
                                        color:
                                            const Color(
                                          0xFFFF6F91,
                                        ),
                                        title:
                                            'Stop Bullying',
                                        subtitle:
                                            'Sikap saling menghargai',
                                        onTap: () {
                                          _start(
                                            context,
                                            topic:
                                                'Stop Bullying',
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Expanded(
                                      child:
                                          _TopicCard(
                                        icon: Icons
                                            .eco_rounded,
                                        color:
                                            const Color(
                                          0xFF45C878,
                                        ),
                                        title:
                                            'Adiwiyata',
                                        subtitle:
                                            'Peduli lingkungan',
                                        onTap: () {
                                          _start(
                                            context,
                                            topic:
                                                'Adiwiyata',
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                )
                              else
                                SizedBox(
                                  width:
                                      double.infinity,
                                  child:
                                      FilledButton.icon(
                                    onPressed: () {
                                      _start(
                                        context,
                                      );
                                    },
                                    icon:
                                        const Icon(
                                      Icons
                                          .play_arrow_rounded,
                                    ),
                                    label:
                                        const Text(
                                      'Mulai Kuis',
                                    ),
                                    style:
                                        FilledButton
                                            .styleFrom(
                                      backgroundColor:
                                          const Color(
                                        0xFF4F8FF7,
                                      ),
                                      foregroundColor:
                                          Colors.white,
                                      padding:
                                          const EdgeInsets
                                              .symmetric(
                                        vertical: 17,
                                      ),
                                      shape:
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius
                                                .circular(
                                          18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        _InfoCard(
                          grade: grade,
                        ),
                      ],
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
}

class _Header extends StatelessWidget {
  const _Header({
    required this.grade,
  });

  final int grade;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Color(0xFF243B5A),
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            color: const Color(0xFFFFC94A),
            borderRadius:
                BorderRadius.circular(18),
          ),
          child: const Icon(
            Icons.school_rounded,
            color: Colors.white,
            size: 32,
          ),
        ),
        const SizedBox(
          width: 13,
        ),
        Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              'Kelas $grade SD',
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: Color(0xFF243B5A),
              ),
            ),
            const Text(
              'Petualangan belajar dimulai!',
              style: TextStyle(
                color: Color(0xFF71869A),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TopicCard extends StatelessWidget {
  const _TopicCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius:
            BorderRadius.circular(22),
        child: Container(
          padding:
              const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: color.withOpacity(.08),
            borderRadius:
                BorderRadius.circular(22),
            border: Border.all(
              color: color.withOpacity(.25),
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 65,
                height: 65,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight:
                      FontWeight.w900,
                  color: color,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF71869A),
                  fontWeight:
                      FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Icon(
                Icons.arrow_forward_rounded,
                color: color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopicButton extends StatelessWidget {
  const _TopicButton({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          padding:
              const EdgeInsets.all(15),
          alignment: Alignment.centerLeft,
          side: BorderSide(
            color: color.withOpacity(.35),
          ),
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(18),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight:
                          FontWeight.w900,
                      color: color,
                    ),
                  ),
                  Text(
                    subtitle,
                    style:
                        const TextStyle(
                      fontSize: 11,
                      color:
                          Color(0xFF71869A),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 15,
              color: color,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.grade,
  });

  final int grade;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white
            .withOpacity(.90),
        borderRadius:
            BorderRadius.circular(22),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.lightbulb_rounded,
            color: Color(0xFFFFB93F),
            size: 28,
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(
            child: Text(
              grade == 5 || grade == 6
                  ? 'Untuk kelas $grade, kamu dapat memilih tema Stop Bullying atau Adiwiyata sebelum memasukkan nama dan mengerjakan kuis.'
                  : 'Kamu akan mendapatkan 10 soal secara acak dari kumpulan soal kelas $grade.',
              style: const TextStyle(
                color: Color(0xFF5F7085),
                height: 1.45,
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}