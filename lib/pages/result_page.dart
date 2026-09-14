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
      return 'Hebat sekali! Kamu luar biasa!';
    }

    if (percentage >= 60) {
      return 'Bagus! Terus tingkatkan lagi!';
    }

    return 'Tidak apa-apa, ayo coba lagi!';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SchoolBackground(
        child: SafeArea(
          child: Scrollbar(
            thumbVisibility:
                MediaQuery.sizeOf(context)
                    .width >=
                    900,
            trackVisibility:
                MediaQuery.sizeOf(context)
                    .width >=
                    900,
            interactive: true,
            thickness: 8,
            radius:
                const Radius.circular(20),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                22,
                25,
                22,
                60,
              ),
              children: [
                Center(
                  child: ConstrainedBox(
                    constraints:
                        const BoxConstraints(
                      maxWidth: 760,
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 155,
                          child: Image.asset(
                            'assets/Gambar anak sd .jpeg',
                            fit: BoxFit.contain,
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          'Kuis Selesai!',
                          textAlign:
                              TextAlign.center,
                          style: TextStyle(
                            color:
                                Color(0xFF243B5A),
                            fontSize: 32,
                            fontWeight:
                                FontWeight.w900,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          '$studentName • Kelas $grade SD',
                          textAlign:
                              TextAlign.center,
                          style:
                              const TextStyle(
                            color:
                                Color(0xFF71859A),
                            fontWeight:
                                FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 22),

                        Container(
                          width: double.infinity,
                          padding:
                              const EdgeInsets.fromLTRB(
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
                                    0xFF4F8FF7),
                                Color(
                                    0xFF6C69E8),
                              ],
                            ),
                            borderRadius:
                                BorderRadius
                                    .circular(
                              32,
                            ),
                            boxShadow:
                                const [
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
                          child: Column(
                            children: [
                              const Text(
                                'Nilai Kamu',
                                style:
                                    TextStyle(
                                  color: Colors
                                      .white70,
                                  fontWeight:
                                      FontWeight
                                          .w700,
                                ),
                              ),

                              const SizedBox(
                                height: 3,
                              ),

                              Text(
                                '$percentage%',
                                style:
                                    const TextStyle(
                                  color:
                                      Colors.white,
                                  fontSize: 76,
                                  fontWeight:
                                      FontWeight
                                          .w900,
                                ),
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
                                ),
                              ),

                              const SizedBox(
                                height: 12,
                              ),

                              Row(
                                mainAxisSize:
                                    MainAxisSize.min,
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
                                      size: 35,
                                    );
                                  },
                                ),
                              ),

                              const SizedBox(
                                height: 10,
                              ),

                              Text(
                                message,
                                textAlign:
                                    TextAlign.center,
                                style:
                                    const TextStyle(
                                  color:
                                      Colors.white,
                                  fontSize: 18,
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
                                title: 'Poin',
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
                                    '$percentage%',
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
                          width: double.infinity,
                          child:
                              FilledButton.icon(
                            onPressed: () {
                              Navigator.pop(
                                context,
                              );
                            },
                            icon: const Icon(
                              Icons.home_rounded,
                            ),
                            label: const Text(
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
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
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color:
                  const Color(0xFFEAF2FF),
              borderRadius:
                  BorderRadius.circular(15),
            ),
            child: Icon(
              icon,
              color:
                  const Color(0xFF4F8FF7),
            ),
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
                    fontSize: 12,
                    color:
                        Color(0xFF71869A),
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight:
                        FontWeight.w900,
                    color:
                        Color(0xFF263E5D),
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