import 'package:flutter/material.dart';

import 'school_ui.dart';

class ResultPage extends StatelessWidget {
  final int grade;
  final int score;
  final int total;
  final String studentName;

  const ResultPage({
    super.key,
    required this.grade,
    required this.score,
    required this.total,
    required this.studentName,
  });

  @override
  Widget build(BuildContext context) {
    final percent = total == 0
        ? 0
        : ((score / total) * 100).round();

    final stars = percent >= 80
        ? 3
        : percent >= 60
            ? 2
            : 1;

    String message;
    String subMessage;

    if (percent >= 80) {
      message = 'Hebat Sekali!';
      subMessage =
          'Kamu benar-benar bintang sekolah! 🌟';
    } else if (percent >= 60) {
      message = 'Bagus!';
      subMessage =
          'Sedikit lagi menuju nilai sempurna!';
    } else {
      message = 'Tetap Semangat!';
      subMessage =
          'Yuk belajar lagi dan coba kembali!';
    }

    return Scaffold(
      body: SchoolBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 15),

                  const Text(
                    'HASIL PETUALANGAN',
                    style: TextStyle(
                      color: SchoolColors.darkBlue,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    message,
                    style: const TextStyle(
                      color: SchoolColors.darkBlue,
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    subMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF718399),
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 20),

                  AnimatedAssetCharacter(
                    asset:
                        'assets/anak sd angkat tangan.jpeg',
                    width: 190,
                    height: 160,
                  ),

                  const SizedBox(height: 10),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 28,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          SchoolColors.blue,
                          Color(0xFF76B8FF),
                        ],
                      ),
                      borderRadius:
                          BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color:
                              SchoolColors.blue
                                  .withOpacity(.22),
                          blurRadius: 25,
                          offset:
                              const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Nilai Kamu',
                          style: TextStyle(
                            color: Colors.white70,
                            fontWeight:
                                FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          '$percent',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 78,
                            height: 1,
                            fontWeight:
                                FontWeight.w900,
                          ),
                        ),

                        const Text(
                          'dari 100',
                          style: TextStyle(
                            color: Colors.white70,
                            fontWeight:
                                FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 14),

                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: List.generate(
                            3,
                            (index) {
                              return AnimatedScale(
                                scale:
                                    index < stars
                                        ? 1
                                        : .65,
                                duration:
                                    Duration(
                                  milliseconds:
                                      400 +
                                          index *
                                              150,
                                ),
                                child: Icon(
                                  Icons.star_rounded,
                                  color:
                                      index < stars
                                          ? SchoolColors
                                              .yellow
                                          : Colors
                                              .white24,
                                  size: 40,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),

                  Text(
                    '$studentName • Kelas $grade SD',
                    style: const TextStyle(
                      color: SchoolColors.darkBlue,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 18),

                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          icon:
                              Icons.bolt_rounded,
                          title: 'Poin',
                          value: '$score',
                          color:
                              SchoolColors.orange,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          icon:
                              Icons.percent_rounded,
                          title: 'Persentase',
                          value: '$percent%',
                          color:
                              SchoolColors.green,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () =>
                          Navigator.pop(context),
                      icon: const Icon(
                        Icons.home_rounded,
                      ),
                      label: const Text(
                        'Kembali ke Sekolah',
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String value;
  final Color color;

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
            color: color.withOpacity(.08),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 27,
          ),
          const SizedBox(height: 7),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF718399),
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: const TextStyle(
              color: SchoolColors.darkBlue,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
