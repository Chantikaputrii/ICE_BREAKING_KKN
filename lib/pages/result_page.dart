import 'package:flutter/material.dart';

import '../widgets/school_background.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({
    super.key,
    required this.grade,
    required this.score,
    required this.total,
    required this.studentName,
  });

  final int grade;
  final int score;
  final int total;
  final String studentName;

  int get percentage {
    if (total <= 0) {
      return 0;
    }

    return (((score / total) * 100)
            .round())
        .clamp(0, 100);
  }

  int get stars {
    if (percentage >= 80) {
      return 3;
    }

    if (percentage >= 60) {
      return 2;
    }

    return 1;
  }

  String get message {
    if (percentage >= 80) {
      return 'Hebat sekali! Kamu luar biasa! 🎉';
    }

    if (percentage >= 60) {
      return 'Bagus! Terus tingkatkan lagi! 🌟';
    }

    return 'Tidak apa-apa, ayo coba lagi! 💪';
  }

  Color get scoreColor {
    if (percentage >= 80) {
      return const Color(
        0xFF36B96D,
      );
    }

    if (percentage >= 60) {
      return const Color(
        0xFFFFA83D,
      );
    }

    return const Color(
      0xFFEF6262,
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      body: SchoolBackground(
        child: SafeArea(
          child: Scrollbar(
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
                20,
                22,
                20,
                60,
              ),
              children: [
                Center(
                  child:
                      ConstrainedBox(
                    constraints:
                        const BoxConstraints(
                      maxWidth: 760,
                    ),
                    child: Column(
                      children: [
                        // ==================================================
                        // TOP DECORATION
                        // ==================================================

                        Container(
                          width: double
                              .infinity,
                          padding:
                              const EdgeInsets
                                  .fromLTRB(
                            20,
                            17,
                            20,
                            15,
                          ),
                          decoration:
                              BoxDecoration(
                            color: Colors
                                .white
                                .withOpacity(
                              .94,
                            ),
                            borderRadius:
                                BorderRadius
                                    .circular(
                              24,
                            ),
                            boxShadow:
                                const [
                              BoxShadow(
                                color:
                                    Color(
                                  0x14000000,
                                ),
                                blurRadius:
                                    15,
                                offset:
                                    Offset(
                                  0,
                                  7,
                                ),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration:
                                    const BoxDecoration(
                                  gradient:
                                      LinearGradient(
                                    colors: [
                                      Color(
                                        0xFFFFD66B,
                                      ),
                                      Color(
                                        0xFFFFA94D,
                                      ),
                                    ],
                                  ),
                                  borderRadius:
                                      BorderRadius
                                          .all(
                                    Radius
                                        .circular(
                                      15,
                                    ),
                                  ),
                                ),
                                child:
                                    const Icon(
                                  Icons
                                      .emoji_events_rounded,
                                  color:
                                      Colors.white,
                                  size: 27,
                                ),
                              ),

                              const SizedBox(
                                width: 11,
                              ),

                              const Expanded(
                                child:
                                    Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                  children: [
                                    Text(
                                      'Hasil Belajar',
                                      style:
                                          TextStyle(
                                        fontSize:
                                            17,
                                        fontWeight:
                                            FontWeight
                                                .w900,
                                        color:
                                            Color(
                                          0xFF283B63,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height:
                                          3,
                                    ),
                                    Text(
                                      'Lihat hasil kuismu di sini ✨',
                                      style:
                                          TextStyle(
                                        fontSize:
                                            11,
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
                            ],
                          ),
                        ),

                        const SizedBox(
                          height: 18,
                        ),

                        // ==================================================
                        // IMAGE
                        // ==================================================

                        Container(
                          width: 185,
                          height: 155,
                          padding:
                              const EdgeInsets
                                  .all(10),
                          decoration:
                              BoxDecoration(
                            color:
                                Colors.white
                                    .withOpacity(
                              .82,
                            ),
                            borderRadius:
                                BorderRadius
                                    .circular(
                              30,
                            ),
                            boxShadow:
                                const [
                              BoxShadow(
                                color:
                                    Color(
                                  0x18000000,
                                ),
                                blurRadius:
                                    18,
                                offset:
                                    Offset(
                                  0,
                                  8,
                                ),
                              ),
                            ],
                          ),
                          child:
                              ClipRRect(
                            borderRadius:
                                BorderRadius
                                    .circular(
                              23,
                            ),
                            child:
                                Image.asset(
                              'assets/Anak Sd Cewek.png',
                              fit: BoxFit
                                  .contain,
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 15,
                        ),

                        const Text(
                          'Kuis Selesai! 🎉',
                          textAlign:
                              TextAlign.center,
                          style:
                              TextStyle(
                            color:
                                Color(
                              0xFF243B5A,
                            ),
                            fontSize: 31,
                            fontWeight:
                                FontWeight
                                    .w900,
                          ),
                        ),

                        const SizedBox(
                          height: 6,
                        ),

                        Text(
                          '$studentName • Kelas $grade SD',
                          textAlign:
                              TextAlign.center,
                          style:
                              const TextStyle(
                            color:
                                Color(
                              0xFF71859A,
                            ),
                            fontWeight:
                                FontWeight
                                    .w700,
                            fontSize: 13,
                          ),
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        // ==================================================
                        // SCORE CARD
                        // ==================================================

                        Container(
                          width:
                              double.infinity,
                          padding:
                              const EdgeInsets
                                  .fromLTRB(
                            24,
                            25,
                            24,
                            28,
                          ),
                          decoration:
                              BoxDecoration(
                            gradient:
                                const LinearGradient(
                              begin:
                                  Alignment
                                      .topLeft,
                              end:
                                  Alignment
                                      .bottomRight,
                              colors: [
                                Color(
                                  0xFF4B7BEC,
                                ),
                                Color(
                                  0xFF6D68E8,
                                ),
                                Color(
                                  0xFF8A65DE,
                                ),
                              ],
                            ),
                            borderRadius:
                                BorderRadius
                                    .circular(
                              32,
                            ),
                            border:
                                Border.all(
                              color:
                                  Colors.white,
                              width: 2,
                            ),
                            boxShadow:
                                const [
                              BoxShadow(
                                color:
                                    Color(
                                  0x354B7BEC,
                                ),
                                blurRadius:
                                    30,
                                offset:
                                    Offset(
                                  0,
                                  12,
                                ),
                              ),
                            ],
                          ),
                          child:
                              Column(
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets
                                        .symmetric(
                                  horizontal:
                                      15,
                                  vertical:
                                      7,
                                ),
                                decoration:
                                    BoxDecoration(
                                  color: Colors
                                      .white
                                      .withOpacity(
                                    .16,
                                  ),
                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                    30,
                                  ),
                                ),
                                child:
                                    const Text(
                                  '🏆 HASIL KUIS',
                                  style:
                                      TextStyle(
                                    color:
                                        Colors.white,
                                    fontSize:
                                        11,
                                    fontWeight:
                                        FontWeight
                                            .w900,
                                  ),
                                ),
                              ),

                              const SizedBox(
                                height: 13,
                              ),

                              const Text(
                                'Nilai Kamu',
                                style:
                                    TextStyle(
                                  color:
                                      Colors.white70,
                                  fontWeight:
                                      FontWeight
                                          .w700,
                                ),
                              ),

                              const SizedBox(
                                height: 2,
                              ),

                              Text(
                                '$percentage%',
                                style:
                                    const TextStyle(
                                  color:
                                      Colors.white,
                                  fontSize:
                                      76,
                                  height:
                                      1,
                                  fontWeight:
                                      FontWeight
                                          .w900,
                                ),
                              ),

                              const SizedBox(
                                height: 6,
                              ),

                              const Text(
                                'dari 100',
                                style:
                                    TextStyle(
                                  color:
                                      Colors.white70,
                                  fontWeight:
                                      FontWeight
                                          .w800,
                                  fontSize:
                                      12,
                                ),
                              ),

                              const SizedBox(
                                height: 13,
                              ),

                              // STARS
                              Container(
                                padding:
                                    const EdgeInsets
                                        .symmetric(
                                  horizontal:
                                      17,
                                  vertical:
                                      8,
                                ),
                                decoration:
                                    BoxDecoration(
                                  color: Colors
                                      .white
                                      .withOpacity(
                                    .13,
                                  ),
                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                    25,
                                  ),
                                ),
                                child:
                                    Row(
                                  mainAxisSize:
                                      MainAxisSize
                                          .min,
                                  children:
                                      List.generate(
                                    3,
                                    (index) {
                                      return Icon(
                                        index <
                                                stars
                                            ? Icons
                                                .star_rounded
                                            : Icons
                                                .star_border_rounded,
                                        color:
                                            const Color(
                                          0xFFFFD66B,
                                        ),
                                        size:
                                            35,
                                      );
                                    },
                                  ),
                                ),
                              ),

                              const SizedBox(
                                height: 13,
                              ),

                              Text(
                                message,
                                textAlign:
                                    TextAlign
                                        .center,
                                style:
                                    const TextStyle(
                                  color:
                                      Colors.white,
                                  fontSize:
                                      17,
                                  fontWeight:
                                      FontWeight
                                          .w900,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(
                          height: 14,
                        ),

                        // ==================================================
                        // STATISTICS
                        // ==================================================

                        Row(
                          children: [
                            Expanded(
                              child:
                                  _ResultCard(
                                title:
                                    'Poin',
                                value:
                                    '$score',
                                icon:
                                    Icons
                                        .bolt_rounded,
                                color:
                                    const Color(
                                  0xFFFFB84D,
                                ),
                              ),
                            ),

                            const SizedBox(
                              width: 11,
                            ),

                            Expanded(
                              child:
                                  _ResultCard(
                                title:
                                    'Persentase',
                                value:
                                    '$percentage%',
                                icon:
                                    Icons
                                        .percent_rounded,
                                color:
                                    const Color(
                                  0xFF4B7BEC,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 14,
                        ),

                        // ==================================================
                        // MESSAGE
                        // ==================================================

                        Container(
                          width:
                              double.infinity,
                          padding:
                              const EdgeInsets
                                  .all(
                            17,
                          ),
                          decoration:
                              BoxDecoration(
                            color: Colors
                                .white
                                .withOpacity(
                              .95,
                            ),
                            borderRadius:
                                BorderRadius
                                    .circular(
                              21,
                            ),
                            border:
                                Border.all(
                              color:
                                  scoreColor
                                      .withOpacity(
                                .20,
                              ),
                            ),
                            boxShadow:
                                const [
                              BoxShadow(
                                color:
                                    Color(
                                  0x10000000,
                                ),
                                blurRadius:
                                    12,
                                offset:
                                    Offset(
                                  0,
                                  5,
                                ),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 43,
                                height: 43,
                                decoration:
                                    BoxDecoration(
                                  color:
                                      scoreColor
                                          .withOpacity(
                                    .12,
                                  ),
                                  shape:
                                      BoxShape
                                          .circle,
                                ),
                                child:
                                    Icon(
                                  percentage >=
                                          80
                                      ? Icons
                                          .celebration_rounded
                                      : percentage >=
                                              60
                                          ? Icons
                                              .thumb_up_alt_rounded
                                          : Icons
                                              .sentiment_satisfied_alt_rounded,
                                  color:
                                      scoreColor,
                                ),
                              ),

                              const SizedBox(
                                width: 11,
                              ),

                              Expanded(
                                child:
                                    Text(
                                  message,
                                  style:
                                      const TextStyle(
                                    color:
                                        Color(
                                      0xFF425A72,
                                    ),
                                    fontWeight:
                                        FontWeight
                                            .w800,
                                    fontSize:
                                        12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(
                          height: 19,
                        ),

                        // ==================================================
                        // BACK HOME
                        // ==================================================

                        SizedBox(
                          width:
                              double.infinity,
                          child:
                              FilledButton.icon(
                            onPressed:
                                () {
                              Navigator.pop(
                                context,
                              );
                            },
                            icon:
                                const Icon(
                              Icons
                                  .home_rounded,
                            ),
                            label:
                                const Text(
                              'Kembali ke Beranda',
                            ),
                            style:
                                FilledButton
                                    .styleFrom(
                              backgroundColor:
                                  const Color(
                                0xFF43C77A,
                              ),
                              foregroundColor:
                                  Colors.white,
                              padding:
                                  const EdgeInsets
                                      .symmetric(
                                vertical:
                                    17,
                              ),
                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                  19,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        const Text(
                          '✨ Tetap semangat belajar dan bermain! ✨',
                          textAlign:
                              TextAlign.center,
                          style:
                              TextStyle(
                            color:
                                Color(
                              0xFF71869A,
                            ),
                            fontSize: 11,
                            fontWeight:
                                FontWeight
                                    .w700,
                          ),
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

// ============================================================
// RESULT SMALL CARD
// ============================================================

class _ResultCard
    extends StatelessWidget {
  const _ResultCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      padding:
          const EdgeInsets.all(
        17,
      ),
      decoration:
          BoxDecoration(
        color: Colors.white
            .withOpacity(.97),
        borderRadius:
            BorderRadius.circular(
          21,
        ),
        border: Border.all(
          color:
              color.withOpacity(
            .14,
          ),
        ),
        boxShadow:
            const [
          BoxShadow(
            color:
                Color(0x10000000),
            blurRadius: 13,
            offset:
                Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration:
                BoxDecoration(
              color:
                  color.withOpacity(
                .12,
              ),
              borderRadius:
                  BorderRadius.circular(
                14,
              ),
            ),
            child: Icon(
              icon,
              color: color,
              size: 23,
            ),
          ),

          const SizedBox(
            width: 10,
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
                    fontSize: 11,
                    color:
                        Color(
                      0xFF71869A,
                    ),
                    fontWeight:
                        FontWeight
                            .w700,
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  value,
                  style:
                      const TextStyle(
                    fontSize: 20,
                    fontWeight:
                        FontWeight
                            .w900,
                    color:
                        Color(
                      0xFF263E5D,
                    ),
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