import 'package:flutter/material.dart';

import '../models/score_record.dart';
import '../services/question_selection_service.dart';
import '../services/score_storage.dart';
import 'quiz_page.dart';
import 'ranking_page.dart';
import 'school_ui.dart';

class GradeMenuPage extends StatelessWidget {
  const GradeMenuPage({
    super.key,
    required this.grade,
  });

  final int grade;

  Future<void> _askStudentName(
    BuildContext context,
  ) async {
    final controller = TextEditingController();

    final name = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.face_rounded,
                color: SchoolColors.blue,
              ),
              SizedBox(width: 10),
              Text(
                'Siapa namamu?',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: SchoolColors.darkBlue,
                ),
              ),
            ],
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            textCapitalization:
                TextCapitalization.words,
            decoration: const InputDecoration(
              hintText: 'Tulis nama kamu',
              prefixIcon:
                  Icon(Icons.person_rounded),
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
                  Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  controller.text.trim(),
                );
              },
              icon: const Icon(
                Icons.play_arrow_rounded,
              ),
              label: const Text('Mulai'),
            ),
          ],
        );
      },
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
                  ScoreStorage().saveRecord(
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: SchoolBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                _buildHeader(context),

                const SizedBox(height: 22),

                _buildClassBanner(),

                const SizedBox(height: 25),

                const Text(
                  'Mau melakukan apa?',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                    color: SchoolColors.darkBlue,
                  ),
                ),

                const SizedBox(height: 14),

                PressableCard(
                  onTap: () =>
                      _askStudentName(context),
                  child: _ActivityCard(
                    color: SchoolColors.blue,
                    icon:
                        Icons.sports_esports_rounded,
                    title: 'Mulai Bermain',
                    subtitle:
                        'Jawab soal dan kumpulkan poin!',
                  ),
                ),

                const SizedBox(height: 14),

                PressableCard(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            RankingPage(
                          grade: grade,
                        ),
                      ),
                    );
                  },
                  child: _ActivityCard(
                    color: SchoolColors.yellow,
                    icon:
                        Icons.emoji_events_rounded,
                    title: 'Lihat Peringkat',
                    subtitle:
                        'Lihat skor teman-temanmu.',
                  ),
                ),

                const SizedBox(height: 25),

                Center(
                  child: AnimatedAssetCharacter(
                    asset:
                        'assets/Gambar guru p.jpeg',
                    width: 150,
                    height: 150,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
  ) {
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(15),
          ),
          child: IconButton(
            onPressed: () =>
                Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: SchoolColors.darkBlue,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            'Kelas $grade SD',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: SchoolColors.darkBlue,
            ),
          ),
        ),
        const Text(
          '🎒',
          style: TextStyle(fontSize: 30),
        ),
      ],
    );
  }

  Widget _buildClassBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            SchoolColors.blue,
            Color(0xFF76B8FF),
          ],
        ),
        borderRadius:
            BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color:
                SchoolColors.blue.withOpacity(.20),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color:
                  Colors.white.withOpacity(.22),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$grade',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 38,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          const SizedBox(width: 18),
          const Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Petualanganmu dimulai!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Siapkan dirimu untuk menjawab soal-soal seru.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
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

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({
    required this.color,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final Color color;
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(.10),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              color: color.withOpacity(.14),
              borderRadius:
                  BorderRadius.circular(20),
            ),
            child: Icon(
              icon,
              color: color,
              size: 34,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: SchoolColors.darkBlue,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF718399),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios_rounded,
            color: color,
            size: 19,
          ),
        ],
      ),
    );
  }
}
