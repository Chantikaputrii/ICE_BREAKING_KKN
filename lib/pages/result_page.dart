import 'package:flutter/material.dart';

import '../widgets/school_background.dart';

class ResultPage
    extends StatelessWidget {
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

  @override
  Widget build(
    BuildContext context,
  ) {
    final percent =
        total == 0
            ? 0
            : ((score / total) * 100)
                .round();

    final stars =
        percent >= 80
            ? 3
            : percent >= 60
                ? 2
                : 1;

    final message =
        percent >= 80
            ? 'Hebat sekali! Kamu luar biasa!'
            : percent >= 60
                ? 'Bagus! Terus tingkatkan lagi!'
                : 'Tidak apa-apa, ayo coba lagi!';

    return Scaffold(
      body: SchoolBackground(
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints(
                maxWidth: 760,
              ),
              child: Scrollbar(
                child:
                    SingleChildScrollView(
                  padding:
                      const EdgeInsets.fromLTRB(
                    22,
                    25,
                    22,
                    60,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 165,
                        child: Image.asset(
                          'assets/Gambar anak sd .jpeg',
                          fit:
                              BoxFit.contain,
                        ),
                      ),

                      const SizedBox(
                        height: 5,
                      ),

                      const Text(
                        'Kuis Selesai!',
                        style:
                            TextStyle(
                          color:
                              Color(0xFF243B5A),
                          fontSize: 32,
                          fontWeight:
                              FontWeight.w900,
                        ),
                      ),

                      const SizedBox(
                        height: 6,
                      ),

                      Text(
                        '$studentName • Kelas $grade SD',
                        style:
                            const TextStyle(
                          color:
                              Color(0xFF71859A),
                          fontWeight:
                              FontWeight.w700,
                        ),
                      ),

                      const SizedBox(
                        height: 22,
                      ),

                      Container(
                        width:
                            double.infinity,
                        padding:
                            const EdgeInsets
                                .fromLTRB(
                          28,
                          28,
                          28,
                          30,
                        ),
                        decoration:
                            BoxDecoration(
                          gradient:
                              const LinearGradient(
                            colors: [
                              Color(
                                0xFF4F8FF7,
                              ),
                              Color(
                                0xFF6C69E8,
                              ),
                            ],
                          ),
                          borderRadius:
                              BorderRadius
                                  .circular(
                            32,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color:
                                  Color(
                                0x334F8FF7,
                              ),
                              blurRadius:
                                  28,
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
                              height: 3,
                            ),

                            Text(
                              '$percent',
                              style:
                                  const TextStyle(
                                color:
                                    Colors.white,
                                fontSize:
                                    76,
                                fontWeight:
                                    FontWeight
                                        .w900,
                              ),
                            ),

                            const Text(
                              '/ 100',
                              style:
                                  TextStyle(
                                color:
                                    Colors.white70,
                                fontWeight:
                                    FontWeight
                                        .w800,
                              ),
                            ),

                            const SizedBox(
                              height: 12,
                            ),

                            Row(
                              mainAxisSize:
                                  MainAxisSize
                                      .min,
                              children:
                                  List.generate(
                                3,
                                (index) =>
                                    Icon(
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
                                  size: 35,
                                ),
                              ),
                            ),

                            const SizedBox(
                              height: 10,
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
                                    18,
                                fontWeight:
                                    FontWeight
                                        .w900,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                        height: 15,
                      ),

                      Row(
                        children: [
                          Expanded(
                            child:
                                _ResultCard(
                              title:
                                  'Poin',
                              value:
                                  '$score',
                              icon: Icons
                                  .bolt_rounded,
                            ),
                          ),

                          const SizedBox(
                            width: 12,
                          ),

                          Expanded(
                            child:
                                _ResultCard(
                              title:
                                  'Persentase',
                              value:
                                  '$percent%',
                              icon: Icons
                                  .percent_rounded,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      SizedBox(
                        width:
                            double.infinity,
                        child:
                            FilledButton.icon(
                          onPressed:
                              () =>
                                  Navigator.pop(
                            context,
                          ),
                          icon: const Icon(
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
                                18,
                              ),
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
      ),
    );
  }
}

class _ResultCard
    extends StatelessWidget {
  const _ResultCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      padding:
          const EdgeInsets.all(18),
      decoration:
          BoxDecoration(
        color:
            Colors.white.withOpacity(.94),
        borderRadius:
            BorderRadius.circular(22),
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
            width: 43,
            height: 43,
            decoration:
                BoxDecoration(
              color:
                  const Color(0xFFFFE6A5),
              borderRadius:
                  BorderRadius.circular(
                14,
              ),
            ),
            child: Icon(
              icon,
              color:
                  const Color(0xFFEEA629),
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
                    color:
                        Color(0xFF7A8DA0),
                    fontSize: 11,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  value,
                  style:
                      const TextStyle(
                    color:
                        Color(0xFF263E5D),
                    fontSize: 24,
                    fontWeight:
                        FontWeight.w900,
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