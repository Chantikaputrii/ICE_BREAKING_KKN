import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final int grade;
  final int score;
  final int total;

  const ResultPage({
    super.key,
    required this.grade,
    required this.score,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final percent =
        total == 0
            ? 0
            : ((score / total) * 100).round();

    final stars =
        percent >= 80
            ? 3
            : percent >= 60
                ? 2
                : 1;

    String message;

    if (percent >= 80) {
      message = 'Hebat sekali! Kamu luar biasa! 🎉';
    } else if (percent >= 60) {
      message = 'Bagus! Terus tingkatkan lagi! 💪';
    } else {
      message = 'Tidak apa-apa, ayo coba lagi! 🌟';
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                const Text(
                  '🏆',
                  style: TextStyle(fontSize: 90),
                ),

                const Text(
                  'Kuis Selesai!',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  'Kelas $grade SD',
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 25),

                // NILAI
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(35),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF4F7DF3),
                        Color(0xFF6D5CE7),
                      ],
                    ),
                    borderRadius:
                        BorderRadius.circular(30),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Nilai Kamu',
                        style: TextStyle(
                          color: Colors.white70,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        '$percent',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 75,
                          fontWeight: FontWeight.w900,
                        ),
                      ),

                      const Text(
                        '/ 100',
                        style: TextStyle(
                          color: Colors.white70,
                        ),
                      ),

                      const SizedBox(height: 15),

                      Text(
                        '⭐' * stars,
                        style:
                            const TextStyle(fontSize: 32),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: resultCard(
                        'Poin',
                        '$score',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: resultCard(
                        'Persentase',
                        '$percent%',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFF4F7DF3),
                      foregroundColor: Colors.white,
                      padding:
                          const EdgeInsets.symmetric(
                        vertical: 17,
                      ),
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(18),
                      ),
                    ),
                    child: const Text(
                      'Kembali ke Beranda',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
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

  Widget resultCard(
    String title,
    String value,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
