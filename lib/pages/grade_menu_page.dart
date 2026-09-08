import 'package:flutter/material.dart';

import '../models/score_record.dart';
import '../services/score_storage.dart';
import 'quiz_page.dart';
import 'ranking_page.dart';

class GradeMenuPage extends StatelessWidget {
  const GradeMenuPage({super.key, required this.grade});

  final int grade;

  Future<void> _askStudentName(BuildContext context) async {
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Nama siswa'),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            hintText: 'Masukkan nama siswa',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (value) => Navigator.pop(dialogContext, value.trim()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, controller.text.trim()),
            child: const Text('Mulai'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (!context.mounted || name == null || name.isEmpty) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QuizPage(
          grade: grade,
          studentName: name,
          onFinished: (score, total) => ScoreStorage().saveRecord(
            ScoreRecord(
              name: name,
              grade: grade,
              score: score,
              total: total,
              completedAt: DateTime.now(),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Kelas $grade')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Pilih aktivitas Kelas $grade',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 20),
            _MenuCard(
              icon: Icons.play_arrow_rounded,
              color: const Color(0xFF4F7DF3),
              title: 'Mulai Game',
              subtitle: 'Isi nama siswa, lalu mulai menjawab soal.',
              onTap: () => _askStudentName(context),
            ),
            const SizedBox(height: 14),
            _MenuCard(
              icon: Icons.emoji_events_rounded,
              color: const Color(0xFFF4A62A),
              title: 'Lihat Peringkat',
              subtitle: 'Urutan nilai siswa dari tertinggi ke rendah.',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => RankingPage(grade: grade)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({
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
  Widget build(BuildContext context) => Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 27,
                  backgroundColor: color.withOpacity(.14),
                  child: Icon(icon, color: color, size: 30),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(subtitle),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded),
              ],
            ),
          ),
        ),
      );
}
