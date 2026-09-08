import 'package:flutter/material.dart';

import '../models/score_record.dart';
import '../services/score_storage.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({super.key, this.grade});

  final int? grade;

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  final _storage = ScoreStorage();
  late Future<List<ScoreRecord>> _records;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _loadRecords();
  }

  void _loadRecords() {
    _records = _storage.loadRecords(grade: widget.grade);
  }

  bool _isSelectedDay(ScoreRecord record) =>
      record.completedAt.year == _selectedDay.year &&
      record.completedAt.month == _selectedDay.month &&
      record.completedAt.day == _selectedDay.day;

  Future<void> _resetToday() async {
    if (widget.grade == null) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset peringkat hari ini?'),
        content: const Text('Semua nilai Kelas ini yang dibuat hari ini akan dihapus.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Reset')),
        ],
      ),
    );
    if (confirmed != true) return;
    await _storage.resetTodayForGrade(widget.grade!);
    if (!mounted) return;
    setState(_loadRecords);
  }

  @override
  Widget build(BuildContext context) {
    final gradeTitle = widget.grade == null ? 'Semua Kelas' : 'Kelas ${widget.grade}';
    return Scaffold(
      appBar: AppBar(
        title: Text('Peringkat $gradeTitle'),
        actions: [
          if (widget.grade != null)
            IconButton(
              onPressed: _resetToday,
              tooltip: 'Reset skor hari ini',
              icon: const Icon(Icons.restart_alt_rounded),
            ),
        ],
      ),
      body: FutureBuilder<List<ScoreRecord>>(
        future: _records,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final records = snapshot.data!.where(_isSelectedDay).toList();
          final days = snapshot.data!
              .map((record) => DateUtils.dateOnly(record.completedAt))
              .toSet()
              .toList()
            ..sort((a, b) => b.compareTo(a));
          if (!days.contains(DateUtils.dateOnly(_selectedDay))) {
            days.insert(0, DateUtils.dateOnly(_selectedDay));
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
                child: DropdownButtonFormField<DateTime>(
                  value: DateUtils.dateOnly(_selectedDay),
                  decoration: const InputDecoration(
                    labelText: 'Riwayat tanggal',
                    border: OutlineInputBorder(),
                  ),
                  items: days
                      .map((day) => DropdownMenuItem(
                            value: day,
                            child: Text(MaterialLocalizations.of(context).formatMediumDate(day)),
                          ))
                      .toList(),
                  onChanged: (day) => setState(() => _selectedDay = day!),
                ),
              ),
              Expanded(
                child: records.isEmpty
                    ? const Center(child: Text('Belum ada nilai pada tanggal ini.'))
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: records.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (_, index) {
                          final record = records[index];
                          return Card(
                            child: ListTile(
                              leading: CircleAvatar(child: Text('${index + 1}')),
                              title: Text(record.name),
                              subtitle: Text('Kelas ${record.grade} • ${record.score}/${record.total} poin'),
                              trailing: Text(
                                '${record.percentage}%',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
