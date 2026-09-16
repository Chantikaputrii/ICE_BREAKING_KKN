import 'package:flutter/material.dart';

import '../data/question_bank.dart';
import '../models/question.dart';
import '../widgets/school_background.dart';

class LearningMaterialPage extends StatefulWidget {
  const LearningMaterialPage({
    super.key,
  });

  @override
  State<LearningMaterialPage> createState() =>
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

  Color _subjectColor(String value) {
    switch (value) {
      case 'Matematika':
        return const Color(0xFF4B7BEC);

      case 'Bahasa Indonesia':
        return const Color(0xFFFF718F);

      case 'IPA':
        return const Color(0xFF45C878);

      case 'Logika':
        return const Color(0xFF9B7BEA);

      default:
        return const Color(0xFFFFB84D);
    }
  }

  IconData _subjectIcon(String value) {
    switch (value) {
      case 'Matematika':
        return Icons.calculate_rounded;

      case 'Bahasa Indonesia':
        return Icons.translate_rounded;

      case 'IPA':
        return Icons.science_rounded;

      case 'Logika':
        return Icons.psychology_rounded;

      default:
        return Icons.auto_awesome_rounded;
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      body: SchoolBackground(
        showSchoolIllustrations: false,
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints(
                maxWidth: 1100,
              ),
              child: Scrollbar(
                thumbVisibility:
                    MediaQuery.sizeOf(context)
                            .width >=
                        900,
                trackVisibility:
                    MediaQuery.sizeOf(context)
                            .width >=
                        900,
                thickness: 7,
                radius:
                    const Radius.circular(20),
                child: ListView(
                  padding:
                      const EdgeInsets.fromLTRB(
                    20,
                    20,
                    20,
                    100,
                  ),
                  children: [
                    // ==================================================
                    // HEADER
                    // ==================================================

                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration:
                              BoxDecoration(
                            gradient:
                                const LinearGradient(
                              begin:
                                  Alignment.topLeft,
                              end: Alignment
                                  .bottomRight,
                              colors: [
                                Color(0xFF63D1FF),
                                Color(0xFF4B7BEC),
                              ],
                            ),
                            borderRadius:
                                BorderRadius.circular(
                              21,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color:
                                    Color(0x334B7BEC),
                                blurRadius: 17,
                                offset:
                                    Offset(0, 7),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons
                                .menu_book_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),

                        const SizedBox(
                          width: 14,
                        ),

                        const Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              Text(
                                'Materi Belajar 📚',
                                style:
                                    TextStyle(
                                  fontSize: 25,
                                  fontWeight:
                                      FontWeight
                                          .w900,
                                  color:
                                      Color(
                                    0xFF283B63,
                                  ),
                                  letterSpacing:
                                      -.3,
                                ),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                'Yuk pelajari pembahasan soal sesuai kelasmu!',
                                style:
                                    TextStyle(
                                  fontSize: 12,
                                  color:
                                      Color(
                                    0xFF71869A,
                                  ),
                                  fontWeight:
                                      FontWeight
                                          .w700,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          width: 45,
                          height: 45,
                          decoration:
                              BoxDecoration(
                            color: Colors.white
                                .withOpacity(.92),
                            shape:
                                BoxShape.circle,
                            boxShadow:
                                const [
                              BoxShadow(
                                color:
                                    Color(0x14000000),
                                blurRadius: 12,
                                offset:
                                    Offset(0, 5),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons
                                .auto_stories_rounded,
                            color:
                                Color(0xFFFFB84D),
                            size: 23,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 22,
                    ),

                    // ==================================================
                    // HERO / INFO CARD
                    // ==================================================

                    Container(
                      width: double.infinity,
                      padding:
                          const EdgeInsets.all(
                        22,
                      ),
                      decoration:
                          BoxDecoration(
                        gradient:
                            const LinearGradient(
                          begin:
                              Alignment.topLeft,
                          end: Alignment
                              .bottomRight,
                          colors: [
                            Color(0xFFFFFFFF),
                            Color(0xFFF2FAFF),
                          ],
                        ),
                        borderRadius:
                            BorderRadius.circular(
                          28,
                        ),
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                        boxShadow:
                            const [
                          BoxShadow(
                            color:
                                Color(0x18000000),
                            blurRadius: 23,
                            offset:
                                Offset(0, 10),
                          ),
                        ],
                      ),
                      child: LayoutBuilder(
                        builder:
                            (
                          context,
                          constraints,
                        ) {
                          final compact =
                              constraints
                                      .maxWidth <
                                  600;

                          final information =
                              Column(
                            crossAxisAlignment:
                                compact
                                    ? CrossAxisAlignment
                                        .center
                                    : CrossAxisAlignment
                                        .start,
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
                                      const Color(
                                    0xFFE5F4FF,
                                  ),
                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                    20,
                                  ),
                                ),
                                child:
                                    const Text(
                                  '🌟 BELAJAR ITU SERU',
                                  style:
                                      TextStyle(
                                    color:
                                        Color(
                                      0xFF3D72C9,
                                    ),
                                    fontSize: 11,
                                    fontWeight:
                                        FontWeight
                                            .w900,
                                  ),
                                ),
                              ),

                              const SizedBox(
                                height: 12,
                              ),

                              Text(
                                'Temukan Jawaban & Pembahasannya!',
                                textAlign:
                                    compact
                                        ? TextAlign
                                            .center
                                        : TextAlign
                                            .left,
                                style:
                                    const TextStyle(
                                  fontSize: 21,
                                  fontWeight:
                                      FontWeight
                                          .w900,
                                  color:
                                      Color(
                                    0xFF283B63,
                                  ),
                                ),
                              ),

                              const SizedBox(
                                height: 7,
                              ),

                              Text(
                                'Pilih kelas dan mata pelajaran untuk melihat materi belajar.',
                                textAlign:
                                    compact
                                        ? TextAlign
                                            .center
                                        : TextAlign
                                            .left,
                                style:
                                    const TextStyle(
                                  fontSize: 12,
                                  color:
                                      Color(
                                    0xFF71869A,
                                  ),
                                  fontWeight:
                                      FontWeight
                                          .w600,
                                  height: 1.45,
                                ),
                              ),
                            ],
                          );

                          if (compact) {
                            return information;
                          }

                          return Row(
                            children: [
                              Expanded(
                                child:
                                    information,
                              ),

                              const SizedBox(
                                width: 25,
                              ),

                              Container(
                                width: 115,
                                height: 95,
                                decoration:
                                    BoxDecoration(
                                  gradient:
                                      const LinearGradient(
                                    colors: [
                                      Color(
                                        0xFFE2F5FF,
                                      ),
                                      Color(
                                        0xFFDCE8FF,
                                      ),
                                    ],
                                  ),
                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                    25,
                                  ),
                                ),
                                child:
                                    const Stack(
                                  alignment:
                                      Alignment
                                          .center,
                                  children: [
                                    Positioned(
                                      top: 7,
                                      right: 12,
                                      child: Text(
                                        '⭐',
                                        style:
                                            TextStyle(
                                          fontSize:
                                              19,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 8,
                                      left: 12,
                                      child: Text(
                                        '✨',
                                        style:
                                            TextStyle(
                                          fontSize:
                                              17,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons
                                          .auto_stories_rounded,
                                      color:
                                          Color(
                                        0xFF4B7BEC,
                                      ),
                                      size: 51,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),

                    const SizedBox(
                      height: 18,
                    ),

                    // ==================================================
                    // GRADE PICKER
                    // ==================================================

                    _GradePicker(
                      grade: grade,
                      onChanged: (value) {
                        setState(() {
                          grade = value;
                        });
                      },
                    ),

                    const SizedBox(
                      height: 14,
                    ),

                    // ==================================================
                    // SUBJECT FILTER
                    // ==================================================

                    Container(
                      padding:
                          const EdgeInsets.fromLTRB(
                        14,
                        14,
                        14,
                        12,
                      ),
                      decoration:
                          BoxDecoration(
                        color: Colors.white
                            .withOpacity(.96),
                        borderRadius:
                            BorderRadius.circular(
                          22,
                        ),
                        border: Border.all(
                          color:
                              Colors.white,
                          width: 2,
                        ),
                        boxShadow:
                            const [
                          BoxShadow(
                            color:
                                Color(0x12000000),
                            blurRadius: 15,
                            offset:
                                Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          const Padding(
                            padding:
                                EdgeInsets
                                    .symmetric(
                              horizontal: 3,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons
                                      .filter_alt_rounded,
                                  size: 19,
                                  color:
                                      Color(
                                    0xFF4B7BEC,
                                  ),
                                ),
                                SizedBox(
                                  width: 7,
                                ),
                                Text(
                                  'Pilih Mata Pelajaran',
                                  style:
                                      TextStyle(
                                    fontSize: 13,
                                    fontWeight:
                                        FontWeight
                                            .w900,
                                    color:
                                        Color(
                                      0xFF334C67,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(
                            height: 11,
                          ),

                          SizedBox(
                            height: 43,
                            child: ListView
                                .separated(
                              scrollDirection:
                                  Axis.horizontal,
                              itemCount:
                                  subjects.length,
                              separatorBuilder:
                                  (
                                _,
                                __,
                              ) =>
                                      const SizedBox(
                                width: 8,
                              ),
                              itemBuilder:
                                  (
                                _,
                                i,
                              ) {
                                final s =
                                    subjects[i];

                                final selected =
                                    s == subject;

                                final color =
                                    _subjectColor(
                                  s,
                                );

                                return AnimatedContainer(
                                  duration:
                                      const Duration(
                                    milliseconds:
                                        220,
                                  ),
                                  curve:
                                      Curves
                                          .easeOut,
                                  decoration:
                                      BoxDecoration(
                                    gradient:
                                        selected
                                            ? LinearGradient(
                                                colors: [
                                                  color,
                                                  color.withOpacity(
                                                    .78,
                                                  ),
                                                ],
                                              )
                                            : null,
                                    color:
                                        selected
                                            ? null
                                            : const Color(
                                                0xFFF4F8FC,
                                              ),
                                    borderRadius:
                                        BorderRadius
                                            .circular(
                                      16,
                                    ),
                                    border:
                                        Border.all(
                                      color: selected
                                          ? color
                                          : const Color(
                                              0xFFE0E9F2,
                                            ),
                                      width:
                                          selected
                                              ? 1.5
                                              : 1,
                                    ),
                                    boxShadow:
                                        selected
                                            ? [
                                                BoxShadow(
                                                  color: color
                                                      .withOpacity(
                                                    .22,
                                                  ),
                                                  blurRadius:
                                                      10,
                                                  offset:
                                                      const Offset(
                                                    0,
                                                    4,
                                                  ),
                                                ),
                                              ]
                                            : null,
                                  ),
                                  child:
                                      Material(
                                    color: Colors
                                        .transparent,
                                    child:
                                        InkWell(
                                      borderRadius:
                                          BorderRadius
                                              .circular(
                                        16,
                                      ),
                                      onTap: () {
                                        setState(
                                          () {
                                            subject =
                                                s;
                                          },
                                        );
                                      },
                                      child:
                                          Padding(
                                        padding:
                                            const EdgeInsets
                                                .symmetric(
                                          horizontal:
                                              13,
                                        ),
                                        child: Row(
                                          mainAxisSize:
                                              MainAxisSize
                                                  .min,
                                          children: [
                                            Icon(
                                              _subjectIcon(
                                                s,
                                              ),
                                              size:
                                                  17,
                                              color:
                                                  selected
                                                      ? Colors
                                                          .white
                                                      : color,
                                            ),
                                            const SizedBox(
                                              width:
                                                  6,
                                            ),
                                            Text(
                                              s,
                                              style:
                                                  TextStyle(
                                                fontSize:
                                                    11,
                                                fontWeight:
                                                    FontWeight
                                                        .w900,
                                                color:
                                                    selected
                                                        ? Colors.white
                                                        : const Color(
                                                            0xFF61758A,
                                                          ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 14,
                    ),

                    // ==================================================
                    // INFORMATION RESULT
                    // ==================================================

                    Container(
                      padding:
                          const EdgeInsets.all(
                        15,
                      ),
                      decoration:
                          BoxDecoration(
                        gradient:
                            const LinearGradient(
                          begin:
                              Alignment.topLeft,
                          end: Alignment
                              .bottomRight,
                          colors: [
                            Color(0xFFFFF8D9),
                            Color(0xFFFFF2BE),
                          ],
                        ),
                        borderRadius:
                            BorderRadius.circular(
                          19,
                        ),
                        border: Border.all(
                          color:
                              const Color(
                            0xFFFFD76A,
                          ).withOpacity(.45),
                        ),
                        boxShadow:
                            const [
                          BoxShadow(
                            color:
                                Color(0x10000000),
                            blurRadius: 10,
                            offset:
                                Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 43,
                            height: 43,
                            decoration:
                                const BoxDecoration(
                              color:
                                  Color(
                                0xFFFFC94F,
                              ),
                              shape:
                                  BoxShape.circle,
                            ),
                            child:
                                const Icon(
                              Icons
                                  .lightbulb_rounded,
                              color:
                                  Colors.white,
                              size: 23,
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
                                  'Kelas $grade',
                                  style:
                                      const TextStyle(
                                    color:
                                        Color(
                                      0xFF725817,
                                    ),
                                    fontWeight:
                                        FontWeight
                                            .w900,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  '${subject == 'Semua' ? 'Semua mata pelajaran' : subject} • ${questions.length} soal tersedia',
                                  style:
                                      const TextStyle(
                                    color:
                                        Color(
                                      0xFF806B3A,
                                    ),
                                    fontWeight:
                                        FontWeight
                                            .w700,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            padding:
                                const EdgeInsets
                                    .symmetric(
                              horizontal: 10,
                              vertical: 7,
                            ),
                            decoration:
                                BoxDecoration(
                              color: Colors.white
                                  .withOpacity(
                                .75,
                              ),
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                12,
                              ),
                            ),
                            child: Text(
                              '${questions.length}',
                              style:
                                  const TextStyle(
                                color:
                                    Color(
                                  0xFF725817,
                                ),
                                fontWeight:
                                    FontWeight
                                        .w900,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 17,
                    ),

                    // ==================================================
                    // SECTION TITLE
                    // ==================================================

                    Row(
                      children: [
                        Container(
                          width: 5,
                          height: 25,
                          decoration:
                              BoxDecoration(
                            color:
                                const Color(
                              0xFF4B7BEC,
                            ),
                            borderRadius:
                                BorderRadius
                                    .circular(
                              10,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Expanded(
                          child: Text(
                            'Daftar Materi & Pembahasan',
                            style:
                                TextStyle(
                              fontSize: 18,
                              fontWeight:
                                  FontWeight
                                      .w900,
                              color:
                                  Color(
                                0xFF283B63,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding:
                              const EdgeInsets
                                  .symmetric(
                            horizontal: 9,
                            vertical: 6,
                          ),
                          decoration:
                              BoxDecoration(
                            color:
                                const Color(
                              0xFFE8F1FF,
                            ),
                            borderRadius:
                                BorderRadius
                                    .circular(
                              10,
                            ),
                          ),
                          child: const Icon(
                            Icons
                                .menu_book_rounded,
                            size: 16,
                            color:
                                Color(
                              0xFF4B7BEC,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 12,
                    ),

                    // ==================================================
                    // QUESTIONS
                    // ==================================================

                    if (questions.isEmpty)
                      _EmptyMaterialState()
                    else
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

// ============================================================
// EMPTY STATE
// ============================================================

class _EmptyMaterialState
    extends StatelessWidget {
  const _EmptyMaterialState();

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 38,
      ),
      decoration:
          BoxDecoration(
        color: Colors.white
            .withOpacity(.95),
        borderRadius:
            BorderRadius.circular(
          24,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 15,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: const Column(
        children: [
          Icon(
            Icons.menu_book_outlined,
            size: 55,
            color: Color(0xFFB7C7D8),
          ),
          SizedBox(height: 12),
          Text(
            'Materi belum tersedia',
            style: TextStyle(
              fontSize: 17,
              fontWeight:
                  FontWeight.w900,
              color: Color(0xFF536A80),
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Coba pilih kelas atau mata pelajaran lainnya.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF8294A6),
              fontWeight:
                  FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// BOOK ICON
// ============================================================

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
        gradient:
            const LinearGradient(
          begin:
              Alignment.topLeft,
          end:
              Alignment.bottomRight,
          colors: [
            Color(0xFF63D1FF),
            Color(0xFF4B7BEC),
          ],
        ),
        borderRadius:
            BorderRadius.circular(
          17,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x304B7BEC),
            blurRadius: 15,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: const Icon(
        Icons.menu_book_rounded,
        color: Colors.white,
        size: 29,
      ),
    );
  }
}

// ============================================================
// GRADE PICKER
// ============================================================

class _GradePicker
    extends StatelessWidget {
  const _GradePicker({
    required this.grade,
    required this.onChanged,
  });

  final int grade;
  final ValueChanged<int> onChanged;

  Color _gradeColor(int value) {
    const colors = [
      Color(0xFF4B7BEC),
      Color(0xFF45C878),
      Color(0xFFFFB84D),
      Color(0xFF9B7BEA),
      Color(0xFFFF718F),
      Color(0xFF36B8C9),
    ];

    return colors[(value - 1) % colors.length];
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      padding:
          const EdgeInsets.all(
        15,
      ),
      decoration:
          BoxDecoration(
        color: Colors.white
            .withOpacity(.96),
        borderRadius:
            BorderRadius.circular(
          22,
        ),
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 15,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment
                .start,
        children: [
          Container(
            width: 43,
            height: 43,
            decoration:
                BoxDecoration(
              gradient:
                  const LinearGradient(
                colors: [
                  Color(0xFFFFE47A),
                  Color(0xFFFFB84D),
                ],
              ),
              borderRadius:
                  BorderRadius.circular(
                14,
              ),
            ),
            child: const Icon(
              Icons.school_rounded,
              color: Colors.white,
              size: 23,
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
                const Text(
                  'Pilih Kelas',
                  style: TextStyle(
                    fontWeight:
                        FontWeight.w900,
                    color:
                        Color(0xFF334C67),
                    fontSize: 13,
                  ),
                ),

                const SizedBox(
                  height: 9,
                ),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      List.generate(
                    6,
                    (i) {
                      final g = i + 1;
                      final selected =
                          grade == g;
                      final color =
                          _gradeColor(g);

                      return AnimatedContainer(
                        duration:
                            const Duration(
                          milliseconds:
                              180,
                        ),
                        decoration:
                            BoxDecoration(
                          gradient:
                              selected
                                  ? LinearGradient(
                                      colors: [
                                        color,
                                        color.withOpacity(
                                          .76,
                                        ),
                                      ],
                                    )
                                  : null,
                          color: selected
                              ? null
                              : const Color(
                                  0xFFF3F7FB,
                                ),
                          borderRadius:
                              BorderRadius
                                  .circular(
                            13,
                          ),
                          border:
                              Border.all(
                            color: selected
                                ? color
                                : const Color(
                                    0xFFE0E8F0,
                                  ),
                            width:
                                selected
                                    ? 1.5
                                    : 1,
                          ),
                          boxShadow:
                              selected
                                  ? [
                                      BoxShadow(
                                        color: color
                                            .withOpacity(
                                          .22,
                                        ),
                                        blurRadius:
                                            9,
                                        offset:
                                            const Offset(
                                          0,
                                          4,
                                        ),
                                      ),
                                    ]
                                  : null,
                        ),
                        child:
                            Material(
                          color: Colors
                              .transparent,
                          child:
                              InkWell(
                            borderRadius:
                                BorderRadius
                                    .circular(
                              13,
                            ),
                            onTap: () {
                              onChanged(
                                g,
                              );
                            },
                            child:
                                SizedBox(
                              width: 42,
                              height: 40,
                              child:
                                  Center(
                                child: Text(
                                  '$g',
                                  style:
                                      TextStyle(
                                    fontWeight:
                                        FontWeight
                                            .w900,
                                    fontSize:
                                        13,
                                    color: selected
                                        ? Colors.white
                                        : color,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
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
// EXPLANATION CARD
// ============================================================

class _ExplanationCard
    extends StatelessWidget {
  const _ExplanationCard({
    required this.number,
    required this.question,
  });

  final int number;
  final Question question;

  Color _subjectColor(
    String subject,
  ) {
    switch (subject) {
      case 'Matematika':
        return const Color(0xFF4B7BEC);

      case 'Bahasa Indonesia':
        return const Color(0xFFFF718F);

      case 'IPA':
        return const Color(0xFF45C878);

      case 'Logika':
        return const Color(0xFF9B7BEA);

      default:
        return const Color(0xFFFFB84D);
    }
  }

  IconData _subjectIcon(
    String subject,
  ) {
    switch (subject) {
      case 'Matematika':
        return Icons.calculate_rounded;

      case 'Bahasa Indonesia':
        return Icons.translate_rounded;

      case 'IPA':
        return Icons.science_rounded;

      case 'Logika':
        return Icons.psychology_rounded;

      default:
        return Icons.auto_awesome_rounded;
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
      margin:
          const EdgeInsets.only(
        bottom: 12,
      ),
      decoration:
          BoxDecoration(
        color: Colors.white
            .withOpacity(.97),
        borderRadius:
            BorderRadius.circular(
          22,
        ),
        border: Border.all(
          color: color.withOpacity(.12),
          width: 1.3,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(.07),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
          const BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor:
              Colors.transparent,
          splashColor:
              color.withOpacity(.06),
          highlightColor:
              color.withOpacity(.04),
        ),
        child: ExpansionTile(
          tilePadding:
              const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 5,
          ),
          childrenPadding:
              EdgeInsets.zero,
          shape: const RoundedRectangleBorder(
            side: BorderSide(
              color: Colors.transparent,
            ),
          ),
          collapsedShape:
              const RoundedRectangleBorder(
            side: BorderSide(
              color: Colors.transparent,
            ),
          ),

          leading: Container(
            width: 48,
            height: 48,
            alignment:
                Alignment.center,
            decoration:
                BoxDecoration(
              gradient:
                  LinearGradient(
                begin:
                    Alignment.topLeft,
                end:
                    Alignment.bottomRight,
                colors: [
                  color.withOpacity(.17),
                  color.withOpacity(.08),
                ],
              ),
              borderRadius:
                  BorderRadius.circular(
                15,
              ),
            ),
            child: Text(
              '$number',
              style:
                  TextStyle(
                color: color,
                fontWeight:
                    FontWeight.w900,
                fontSize: 15,
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
                  FontWeight.w900,
              color:
                  Color(0xFF2A425E),
              fontSize: 13,
              height: 1.3,
            ),
          ),

          subtitle: Padding(
            padding:
                const EdgeInsets.only(
              top: 6,
            ),
            child: Row(
              children: [
                Icon(
                  _subjectIcon(
                    question.subject,
                  ),
                  size: 13,
                  color: color,
                ),
                const SizedBox(
                  width: 5,
                ),
                Flexible(
                  child: Text(
                    question.subject,
                    overflow:
                        TextOverflow.ellipsis,
                    style:
                        TextStyle(
                      fontSize: 10,
                      color: color,
                      fontWeight:
                          FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),

          iconColor: color,
          collapsedIconColor:
              const Color(0xFF8294A6),

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
                16,
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
                    Color(0xFFF0FFF6),
                    Color(0xFFE7FAF0),
                  ],
                ),
                borderRadius:
                    BorderRadius.circular(
                  18,
                ),
                border: Border.all(
                  color:
                      const Color(
                    0xFF9BE0B8,
                  ).withOpacity(.55),
                ),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  // ==========================================
                  // JAWABAN BENAR
                  // ==========================================

                  Row(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration:
                            const BoxDecoration(
                          color:
                              Color(
                            0xFF45C878,
                          ),
                          shape:
                              BoxShape.circle,
                        ),
                        child:
                            const Icon(
                          Icons
                              .check_rounded,
                          color:
                              Colors.white,
                          size: 19,
                        ),
                      ),

                      const SizedBox(
                        width: 10,
                      ),

                      const Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            Text(
                              'Jawaban benar',
                              style:
                                  TextStyle(
                                color:
                                    Color(
                                  0xFF278F58,
                                ),
                                fontWeight:
                                    FontWeight
                                        .w900,
                                fontSize: 11,
                              ),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 5,
                  ),

                  Container(
                    width:
                        double.infinity,
                    padding:
                        const EdgeInsets
                            .symmetric(
                      horizontal: 13,
                      vertical: 11,
                    ),
                    decoration:
                        BoxDecoration(
                      color:
                          Colors.white
                              .withOpacity(
                        .72,
                      ),
                      borderRadius:
                          BorderRadius.circular(
                        13,
                      ),
                    ),
                    child: Text(
                      question.options[
                          question.answer],
                      style:
                          const TextStyle(
                        fontWeight:
                            FontWeight
                                .w900,
                        color:
                            Color(
                          0xFF315D47,
                        ),
                        fontSize: 13,
                        height: 1.35,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 15,
                  ),

                  // ==========================================
                  // PEMBAHASAN
                  // ==========================================

                  Row(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration:
                            BoxDecoration(
                          color:
                              const Color(
                            0xFF4B7BEC,
                          ).withOpacity(
                            .12,
                          ),
                          shape:
                              BoxShape.circle,
                        ),
                        child:
                            const Icon(
                          Icons
                              .lightbulb_rounded,
                          color:
                              Color(
                            0xFF4B7BEC,
                          ),
                          size: 18,
                        ),
                      ),

                      const SizedBox(
                        width: 10,
                      ),

                      const Padding(
                        padding:
                            EdgeInsets.only(
                          top: 7,
                        ),
                        child: Text(
                          'Pembahasan',
                          style:
                              TextStyle(
                            color:
                                Color(
                              0xFF3868C4,
                            ),
                            fontWeight:
                                FontWeight
                                    .w900,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  Text(
                    question.explanation,
                    style:
                        const TextStyle(
                      color:
                          Color(
                        0xFF587465,
                      ),
                      height: 1.55,
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
      ),
    );
  }
}