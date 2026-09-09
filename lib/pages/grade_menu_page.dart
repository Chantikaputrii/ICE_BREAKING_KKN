import 'package:flutter/material.dart';

import '../models/score_record.dart';
import '../services/question_selection_service.dart';
import '../services/score_storage.dart';
import '../widgets/school_background.dart';
import 'quiz_page.dart';
import 'ranking_page.dart';

class GradeMenuPage extends StatelessWidget {
  const GradeMenuPage({
    super.key,
    required this.grade,
  });

  final int grade;

  Future<void> _start(
    BuildContext context,
  ) async {
    final controller =
        TextEditingController();

    final name =
        await showDialog<String>(
      context: context,
      builder: (dialogContext) =>
          AlertDialog(
        shape:
            RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(24),
        ),
        title: const Text(
          'Siapa nama kamu?',
          style: TextStyle(
            fontWeight:
                FontWeight.w900,
          ),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization:
              TextCapitalization.words,
          decoration:
              const InputDecoration(
            hintText:
                'Masukkan nama siswa',
            prefixIcon:
                Icon(Icons.face_rounded),
          ),
          onSubmitted: (value) {
            Navigator.pop(
              dialogContext,
              value.trim(),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(
              dialogContext,
            ),
            child:
                const Text('Batal'),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.pop(
              dialogContext,
              controller.text.trim(),
            ),
            child:
                const Text('Mulai'),
          ),
        ],
      ),
    );

    controller.dispose();

    if (!context.mounted ||
        name == null ||
        name.isEmpty) {
      return;
    }

    final questions =
        await QuestionSelectionService()
            .selectQuestions(
      grade: grade,
      studentName: name,
    );

    if (!context.mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QuizPage(
          grade: grade,
          studentName: name,
          questions: questions,
          onFinished:
              (score, total) =>
                  ScoreStorage()
                      .saveRecord(
            ScoreRecord(
              name: name,
              grade: grade,
              score: score,
              total: total,
              completedAt:
                  DateTime.now(),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      body: SchoolBackground(
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints(
                maxWidth: 900,
              ),
              child: Scrollbar(
                child:
                    ListView(
                  padding:
                      const EdgeInsets.fromLTRB(
                    22,
                    20,
                    22,
                    100,
                  ),
                  children: [
                    Row(
                      children: [
                        Material(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(
                            15,
                          ),
                          child: InkWell(
                            onTap: () =>
                                Navigator.pop(
                              context,
                            ),
                            borderRadius:
                                BorderRadius.circular(
                              15,
                            ),
                            child:
                                const Padding(
                              padding:
                                  EdgeInsets.all(
                                12,
                              ),
                              child: Icon(
                                Icons
                                    .arrow_back_rounded,
                                color:
                                    Color(0xFF29415F),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 13,
                        ),
                        Text(
                          'Kelas $grade',
                          style:
                              const TextStyle(
                            fontSize: 22,
                            fontWeight:
                                FontWeight.w900,
                            color:
                                Color(0xFF243B5A),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 25,
                    ),

                    Container(
                      padding:
                          const EdgeInsets.all(
                        22,
                      ),
                      decoration:
                          BoxDecoration(
                        color: Colors.white
                            .withOpacity(.94),
                        borderRadius:
                            BorderRadius.circular(
                          28,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color:
                                Colors.black12,
                            blurRadius: 20,
                            offset:
                                Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 145,
                            height: 145,
                            child: Image.asset(
                              'assets/anak sd angkat tangan.jpeg',
                              fit:
                                  BoxFit.contain,
                            ),
                          ),
                          const SizedBox(
                            width: 18,
                          ),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              children: [
                                Text(
                                  'Ayo belajar sambil bermain!',
                                  style:
                                      TextStyle(
                                    fontSize:
                                        25,
                                    fontWeight:
                                        FontWeight
                                            .w900,
                                    color:
                                        Color(
                                      0xFF243B5A,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                Text(
                                  'Jawab soal dengan teliti dan kumpulkan poin sebanyak-banyaknya.',
                                  style:
                                      TextStyle(
                                    color:
                                        Color(
                                      0xFF71869A,
                                    ),
                                    fontWeight:
                                        FontWeight
                                            .w600,
                                    height:
                                        1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 16,
                    ),

                    _ActionCard(
                      icon: Icons
                          .play_circle_fill_rounded,
                      color:
                          const Color(0xFF4F8FF7),
                      title: 'Mulai Kuis',
                      subtitle:
                          'Jawab soal dan dapatkan poin.',
                      onTap: () =>
                          _start(context),
                    ),

                    const SizedBox(
                      height: 13,
                    ),

                    _ActionCard(
                      icon: Icons
                          .emoji_events_rounded,
                      color:
                          const Color(0xFFFFB93F),
                      title:
                          'Lihat Peringkat',
                      subtitle:
                          'Cek hasil bersama teman-teman.',
                      onTap: () =>
                          Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              RankingPage(
                            grade: grade,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionCard
    extends StatelessWidget {
  const _ActionCard({
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
  Widget build(
    BuildContext context,
  ) {
    return PressableCard(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.all(18),
        decoration:
            BoxDecoration(
          color: Colors.white
              .withOpacity(.95),
          borderRadius:
              BorderRadius.circular(23),
          boxShadow: [
            BoxShadow(
              color:
                  color.withOpacity(.12),
              blurRadius: 18,
              offset:
                  const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration:
                  BoxDecoration(
                color:
                    color.withOpacity(.12),
                borderRadius:
                    BorderRadius.circular(
                  18,
                ),
              ),
              child: Icon(
                icon,
                color: color,
                size: 32,
              ),
            ),

            const SizedBox(
              width: 15,
            ),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style:
                        const TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight.w900,
                      color:
                          Color(0xFF263E5D),
                    ),
                  ),
                  Text(
                    subtitle,
                    style:
                        const TextStyle(
                      color:
                          Color(0xFF71869A),
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              Icons
                  .arrow_forward_ios_rounded,
              color: color,
              size: 19,
            ),
          ],
        ),
      ),
    );
  }
}