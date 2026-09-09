import 'package:flutter/material.dart';

import '../data/question_bank.dart';
import '../models/question.dart';
import '../widgets/school_background.dart';

class LearningMaterialPage
    extends StatefulWidget {
  const LearningMaterialPage({
    super.key,
  });

  @override
  State<LearningMaterialPage>
      createState() =>
          _LearningMaterialPageState();
}

class _LearningMaterialPageState
    extends State<LearningMaterialPage> {
  int grade = 1;

  String subject = 'Semua';

  static const subjects = [
    'Semua',
    'Matematika',
    'Bahasa Indonesia',
    'IPA',
    'Logika',
  ];

  List<Question> get questions {
    final source =
        questionsByGrade[grade] ??
            const <Question>[];

    if (subject == 'Semua') {
      return source;
    }

    return source
        .where(
          (q) => q.subject == subject,
        )
        .toList();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      body: SchoolBackground(
        showSchoolIllustrations:
            false,
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints(
                maxWidth: 1100,
              ),
              child: Scrollbar(
                child: ListView(
                  padding:
                      const EdgeInsets.fromLTRB(
                    20,
                    20,
                    20,
                    100,
                  ),
                  children: [
                    const Row(
                      children: [
                        _BookIcon(),
                        SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              Text(
                                'Materi Belajar',
                                style:
                                    TextStyle(
                                  fontSize: 24,
                                  fontWeight:
                                      FontWeight
                                          .w900,
                                  color:
                                      Color(
                                    0xFF243B5A,
                                  ),
                                ),
                              ),
                              Text(
                                'Pelajari pembahasan soal sesuai kelasmu.',
                                style:
                                    TextStyle(
                                  fontSize: 12,
                                  color:
                                      Color(
                                    0xFF71869A,
                                  ),
                                  fontWeight:
                                      FontWeight
                                          .w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 16,
                    ),

                    _GradePicker(
                      grade: grade,
                      onChanged: (value) {
                        setState(() {
                          grade = value;
                        });
                      },
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    SizedBox(
                      height: 42,
                      child: ListView
                          .separated(
                        scrollDirection:
                            Axis.horizontal,
                        itemCount:
                            subjects.length,
                        separatorBuilder:
                            (_, __) =>
                                const SizedBox(
                          width: 8,
                        ),
                        itemBuilder:
                            (_, i) {
                          final s =
                              subjects[i];

                          final selected =
                              s == subject;

                          return FilterChip(
                            label: Text(s),
                            selected:
                                selected,
                            onSelected: (_) {
                              setState(() {
                                subject = s;
                              });
                            },
                            selectedColor:
                                const Color(
                              0xFFBDEFD0,
                            ),
                            checkmarkColor:
                                const Color(
                              0xFF2EAD69,
                            ),
                            backgroundColor:
                                Colors.white,
                            labelStyle:
                                TextStyle(
                              fontWeight:
                                  FontWeight
                                      .w800,
                              color: selected
                                  ? const Color(
                                      0xFF2E8E5D,
                                    )
                                  : const Color(
                                      0xFF61758A,
                                    ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(
                      height: 12,
                    ),

                    Container(
                      padding:
                          const EdgeInsets.all(
                        13,
                      ),
                      decoration:
                          BoxDecoration(
                        color:
                            const Color(
                          0xFFFFF3CF,
                        ),
                        borderRadius:
                            BorderRadius.circular(
                          17,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons
                                .lightbulb_rounded,
                            color:
                                Color(
                              0xFFFFB629,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Text(
                              'Kelas $grade • '
                              '${subject == 'Semua' ? 'Semua mata pelajaran' : subject} • '
                              '${questions.length} soal',
                              style:
                                  const TextStyle(
                                color:
                                    Color(
                                  0xFF775D25,
                                ),
                                fontWeight:
                                    FontWeight
                                        .w800,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 12,
                    ),

                    ...questions
                        .asMap()
                        .entries
                        .map(
                      (entry) =>
                          _ExplanationCard(
                        number:
                            entry.key + 1,
                        question:
                            entry.value,
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

class _BookIcon
    extends StatelessWidget {
  const _BookIcon();

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      width: 54,
      height: 54,
      decoration:
          BoxDecoration(
        color:
            const Color(0xFF4F8FF7),
        borderRadius:
            BorderRadius.circular(
          17,
        ),
      ),
      child: const Icon(
        Icons.menu_book_rounded,
        color: Colors.white,
        size: 29,
      ),
    );
  }
}

class _GradePicker
    extends StatelessWidget {
  const _GradePicker({
    required this.grade,
    required this.onChanged,
  });

  final int grade;
  final ValueChanged<int> onChanged;

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      padding:
          const EdgeInsets.all(14),
      decoration:
          BoxDecoration(
        color:
            Colors.white.withOpacity(.94),
        borderRadius:
            BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Text(
            'Kelas',
            style: TextStyle(
              fontWeight:
                  FontWeight.w900,
              color:
                  Color(0xFF334C67),
            ),
          ),

          const SizedBox(
            width: 12,
          ),

          Expanded(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  List.generate(
                6,
                (i) {
                  final g = i + 1;

                  return ChoiceChip(
                    label:
                        Text('$g'),
                    selected:
                        grade == g,
                    onSelected:
                        (_) =>
                            onChanged(
                      g,
                    ),
                    selectedColor:
                        const Color(
                      0xFFFFD66B,
                    ),
                    labelStyle:
                        const TextStyle(
                      fontWeight:
                          FontWeight
                              .w900,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExplanationCard
    extends StatelessWidget {
  const _ExplanationCard({
    required this.number,
    required this.question,
  });

  final int number;
  final Question question;

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 10,
      ),
      decoration:
          BoxDecoration(
        color:
            Colors.white.withOpacity(.95),
        borderRadius:
            BorderRadius.circular(20),
      ),
      child: ExpansionTile(
        tilePadding:
            const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),

        leading: Container(
          width: 43,
          height: 43,
          alignment:
              Alignment.center,
          decoration:
              BoxDecoration(
            color:
                const Color(0xFFEAF2FF),
            borderRadius:
                BorderRadius.circular(
              14,
            ),
          ),
          child: Text(
            '$number',
            style:
                const TextStyle(
              color:
                  Color(0xFF4F8FF7),
              fontWeight:
                  FontWeight.w900,
            ),
          ),
        ),

        title: Text(
          question.question,
          maxLines: 2,
          overflow:
              TextOverflow.ellipsis,
          style:
              const TextStyle(
            fontWeight:
                FontWeight.w800,
            color:
                Color(0xFF2A425E),
          ),
        ),

        subtitle: Text(
          question.subject,
          style:
              const TextStyle(
            fontSize: 11,
            color:
                Color(0xFF71869A),
          ),
        ),

        children: [
          Container(
            margin:
                const EdgeInsets.fromLTRB(
              15,
              0,
              15,
              15,
            ),
            padding:
                const EdgeInsets.all(
              15,
            ),
            decoration:
                BoxDecoration(
              color:
                  const Color(0xFFEFFFF4),
              borderRadius:
                  BorderRadius.circular(
                16,
              ),
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  'Jawaban benar',
                  style:
                      TextStyle(
                    color:
                        Color(0xFF2E9E61),
                    fontWeight:
                        FontWeight
                            .w900,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(
                  height: 4,
                ),

                Text(
                  question.options[
                      question.answer],
                  style:
                      const TextStyle(
                    fontWeight:
                        FontWeight
                            .w900,
                    color:
                        Color(0xFF315D47),
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                const Text(
                  'Pembahasan',
                  style:
                      TextStyle(
                    color:
                        Color(0xFF2E9E61),
                    fontWeight:
                        FontWeight
                            .w900,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(
                  height: 4,
                ),

                Text(
                  question.explanation,
                  style:
                      const TextStyle(
                    color:
                        Color(0xFF587465),
                    height: 1.45,
                    fontWeight:
                        FontWeight
                            .w600,
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