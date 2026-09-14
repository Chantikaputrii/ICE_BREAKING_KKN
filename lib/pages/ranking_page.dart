import 'package:flutter/material.dart';

import '../models/score_record.dart';
import '../services/score_storage.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({
    super.key,
    this.grade,
  });

  final int? grade;

  @override
  State<RankingPage> createState() =>
      _RankingPageState();
}

class _RankingPageState
    extends State<RankingPage> {
  late Future<List<ScoreRecord>> _recordsFuture;

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  void _loadRecords() {
    _recordsFuture =
        ScoreStorage().loadRecords(
      grade: widget.grade,
    );
  }

  Future<void> _refresh() async {
    setState(() {
      _loadRecords();
    });

    await _recordsFuture;
  }

  int _percentage(ScoreRecord record) {
    if (record.total <= 0) {
      return 0;
    }

    final value =
        ((record.score / record.total) * 100)
            .round();

    return value.clamp(0, 100);
  }

  String _formatDate(DateTime date) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    return '${date.day} '
        '${months[date.month - 1]} '
        '${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.grade == null
        ? 'Peringkat'
        : 'Peringkat Kelas ${widget.grade}';

    return Scaffold(
      backgroundColor:
          const Color(0xFFEAF7FF),
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
        backgroundColor:
            const Color(0xFF4F8FF7),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: FutureBuilder<
              List<ScoreRecord>>(
            future: _recordsFuture,
            builder: (
              context,
              snapshot,
            ) {
              if (snapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(
                  child:
                      CircularProgressIndicator(),
                );
              }

              if (snapshot.hasError) {
                return ListView(
                  physics:
                      const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(
                      height:
                          MediaQuery.sizeOf(context)
                              .height *
                          .30,
                    ),
                    const Icon(
                      Icons
                          .error_outline_rounded,
                      size: 65,
                      color:
                          Color(0xFFE65353),
                    ),
                    const SizedBox(height: 14),
                    const Center(
                      child: Text(
                        'Gagal memuat peringkat.',
                        style: TextStyle(
                          fontWeight:
                              FontWeight.w900,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Center(
                      child: FilledButton(
                        onPressed: _refresh,
                        child:
                            const Text(
                          'Coba Lagi',
                        ),
                      ),
                    ),
                  ],
                );
              }

              final records =
                  List<ScoreRecord>.from(
                snapshot.data ?? [],
              );

              records.sort(
                (a, b) {
                  final aPercent =
                      _percentage(a);
                  final bPercent =
                      _percentage(b);

                  if (aPercent !=
                      bPercent) {
                    return bPercent.compareTo(
                      aPercent,
                    );
                  }

                  return b.score.compareTo(
                    a.score,
                  );
                },
              );

              if (records.isEmpty) {
                return ListView(
                  physics:
                      const AlwaysScrollableScrollPhysics(),
                  padding:
                      const EdgeInsets.all(24),
                  children: [
                    const SizedBox(height: 100),
                    const Icon(
                      Icons
                          .emoji_events_outlined,
                      size: 80,
                      color:
                          Color(0xFFFFB93F),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Belum ada peringkat',
                      textAlign:
                          TextAlign.center,
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight:
                            FontWeight.w900,
                        color:
                            Color(0xFF263E5D),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.grade == null
                          ? 'Belum ada siswa yang menyelesaikan kuis.'
                          : 'Belum ada siswa kelas ${widget.grade} yang menyelesaikan kuis.',
                      textAlign:
                          TextAlign.center,
                      style: const TextStyle(
                        color:
                            Color(0xFF71869A),
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                  ],
                );
              }

              return Scrollbar(
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
                  physics:
                      const AlwaysScrollableScrollPhysics(),
                  padding:
                      const EdgeInsets.fromLTRB(
                    20,
                    20,
                    20,
                    40,
                  ),
                  children: [
                    Center(
                      child: ConstrainedBox(
                        constraints:
                            const BoxConstraints(
                          maxWidth: 1000,
                        ),
                        child: Column(
                          children: [
                            _RankingHeader(
                              grade: widget.grade,
                              total:
                                  records.length,
                            ),

                            const SizedBox(
                              height: 18,
                            ),

                            ...List.generate(
                              records.length,
                              (index) {
                                final record =
                                    records[index];

                                return Padding(
                                  padding:
                                      const EdgeInsets
                                          .only(
                                    bottom: 12,
                                  ),
                                  child:
                                      _RankingCard(
                                    rank:
                                        index + 1,
                                    record:
                                        record,
                                    percentage:
                                        _percentage(
                                      record,
                                    ),
                                    date:
                                        _formatDate(
                                      record
                                          .completedAt,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _RankingHeader
    extends StatelessWidget {
  const _RankingHeader({
    required this.grade,
    required this.total,
  });

  final int? grade;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF4F8FF7),
            Color(0xFF6BCBFF),
          ],
        ),
        borderRadius:
            BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(.08),
            blurRadius: 18,
            offset:
                const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color:
                  Colors.white.withOpacity(.20),
              borderRadius:
                  BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.emoji_events_rounded,
              color: Colors.white,
              size: 35,
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  grade == null
                      ? 'Peringkat Semua Kelas'
                      : 'Peringkat Kelas $grade',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$total siswa telah mengerjakan kuis',
                  style: TextStyle(
                    color: Colors.white
                        .withOpacity(.90),
                    fontWeight:
                        FontWeight.w600,
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

class _RankingCard
    extends StatelessWidget {
  const _RankingCard({
    required this.rank,
    required this.record,
    required this.percentage,
    required this.date,
  });

  final int rank;
  final ScoreRecord record;
  final int percentage;
  final String date;

  @override
  Widget build(BuildContext context) {
    final medalColor = rank == 1
        ? const Color(0xFFFFC83D)
        : rank == 2
            ? const Color(0xFFB9C4CF)
            : rank == 3
                ? const Color(0xFFCD8A54)
                : const Color(0xFFEAF2FF);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFE0EAF2),
        ),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(.045),
            blurRadius: 14,
            offset:
                const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: medalColor,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$rank',
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.w900,
                color: rank <= 3
                    ? Colors.white
                    : const Color(
                        0xFF4F8FF7,
                      ),
              ),
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  record.name,
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight:
                        FontWeight.w900,
                    color:
                        Color(0xFF263E5D),
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  'Skor ${record.score}/${record.total}',
                  style: const TextStyle(
                    color:
                        Color(0xFF71869A),
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 11,
                    color:
                        Color(0xFF9AA9B5),
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 9,
            ),
            decoration: BoxDecoration(
              color:
                  const Color(0xFFE9FFF2),
              borderRadius:
                  BorderRadius.circular(15),
            ),
            child: Text(
              '$percentage%',
              style: const TextStyle(
                fontWeight:
                    FontWeight.w900,
                color:
                    Color(0xFF2EAE68),
              ),
            ),
          ),
        ],
      ),
    );
  }
}