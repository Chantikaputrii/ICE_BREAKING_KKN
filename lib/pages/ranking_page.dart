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
  late Future<List<ScoreRecord>>
      _recordsFuture;

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

  int _percentage(
    ScoreRecord record,
  ) {
    if (record.total <= 0) {
      return 0;
    }

    final value =
        ((record.score /
                    record.total) *
                100)
            .round();

    return value.clamp(0, 100);
  }

  String _formatDate(
    DateTime date,
  ) {
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
  Widget build(
    BuildContext context,
  ) {
    final title =
        widget.grade == null
            ? 'Peringkat'
            : 'Peringkat Kelas ${widget.grade}';

    return Scaffold(
      backgroundColor:
          const Color(0xFFEAF7FF),

      appBar: AppBar(
        title: Text(
          title,
          style:
              const TextStyle(
            fontWeight:
                FontWeight.w900,
            color:
                Color(0xFF283B63),
          ),
        ),
        backgroundColor:
            Colors.transparent,
        foregroundColor:
            const Color(
          0xFF283B63,
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),

      body: SafeArea(
        child:
            RefreshIndicator(
          color:
              const Color(
            0xFF4B7BEC,
          ),
          onRefresh: _refresh,
          child:
              FutureBuilder<
                  List<ScoreRecord>>(
            future: _recordsFuture,
            builder:
                (
              context,
              snapshot,
            ) {
              if (snapshot
                      .connectionState ==
                  ConnectionState
                      .waiting) {
                return const Center(
                  child:
                      CircularProgressIndicator(
                    color:
                        Color(
                      0xFF4B7BEC,
                    ),
                  ),
                );
              }

              if (snapshot.hasError) {
                return ListView(
                  physics:
                      const AlwaysScrollableScrollPhysics(),
                  padding:
                      const EdgeInsets
                          .all(
                    24,
                  ),
                  children: [
                    const SizedBox(
                      height: 120,
                    ),

                    Container(
                      width: 95,
                      height: 95,
                      margin:
                          const EdgeInsets
                              .all(0),
                      decoration:
                          const BoxDecoration(
                        color:
                            Color(
                          0xFFFFE8E8,
                        ),
                        shape:
                            BoxShape
                                .circle,
                      ),
                      child:
                          const Icon(
                        Icons
                            .error_outline_rounded,
                        size: 55,
                        color:
                            Color(
                          0xFFE65353,
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 18,
                    ),

                    const Text(
                      'Gagal memuat peringkat.',
                      textAlign:
                          TextAlign.center,
                      style:
                          TextStyle(
                        fontWeight:
                            FontWeight
                                .w900,
                        fontSize: 18,
                        color:
                            Color(
                          0xFF263E5D,
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 7,
                    ),

                    const Text(
                      'Coba muat ulang untuk melihat data peringkat.',
                      textAlign:
                          TextAlign.center,
                      style:
                          TextStyle(
                        color:
                            Color(
                          0xFF71869A,
                        ),
                        fontWeight:
                            FontWeight
                                .w600,
                        fontSize: 12,
                      ),
                    ),

                    const SizedBox(
                      height: 16,
                    ),

                    Center(
                      child:
                          FilledButton.icon(
                        onPressed:
                            _refresh,
                        icon:
                            const Icon(
                          Icons
                              .refresh_rounded,
                        ),
                        label:
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
                    return bPercent
                        .compareTo(
                      aPercent,
                    );
                  }

                  return b.score
                      .compareTo(
                    a.score,
                  );
                },
              );

              if (records.isEmpty) {
                return ListView(
                  physics:
                      const AlwaysScrollableScrollPhysics(),
                  padding:
                      const EdgeInsets
                          .all(
                    22,
                  ),
                  children: [
                    const SizedBox(
                      height: 70,
                    ),

                    Container(
                      width: 115,
                      height: 115,
                      margin:
                          const EdgeInsets
                              .all(0),
                      decoration:
                          const BoxDecoration(
                        gradient:
                            LinearGradient(
                          colors: [
                            Color(
                              0xFFFFE99A,
                            ),
                            Color(
                              0xFFFFC95C,
                            ),
                          ],
                        ),
                        shape:
                            BoxShape
                                .circle,
                      ),
                      child:
                          const Icon(
                        Icons
                            .emoji_events_rounded,
                        size: 65,
                        color:
                            Colors.white,
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    const Text(
                      'Belum ada peringkat',
                      textAlign:
                          TextAlign.center,
                      style:
                          TextStyle(
                        fontSize: 23,
                        fontWeight:
                            FontWeight
                                .w900,
                        color:
                            Color(
                          0xFF263E5D,
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 8,
                    ),

                    Text(
                      widget.grade ==
                              null
                          ? 'Belum ada siswa yang menyelesaikan kuis.'
                          : 'Belum ada siswa kelas ${widget.grade} yang menyelesaikan kuis.',
                      textAlign:
                          TextAlign.center,
                      style:
                          const TextStyle(
                        color:
                            Color(
                          0xFF71869A,
                        ),
                        fontWeight:
                            FontWeight
                                .w600,
                        fontSize: 12,
                      ),
                    ),

                    const SizedBox(
                      height: 15,
                    ),

                    const Text(
                      'Yuk jadi yang pertama! 🚀',
                      textAlign:
                          TextAlign.center,
                      style:
                          TextStyle(
                        color:
                            Color(
                          0xFF4B7BEC,
                        ),
                        fontWeight:
                            FontWeight
                                .w900,
                      ),
                    ),
                  ],
                );
              }

              return Scrollbar(
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
                  physics:
                      const AlwaysScrollableScrollPhysics(),
                  padding:
                      const EdgeInsets
                          .fromLTRB(
                    18,
                    16,
                    18,
                    45,
                  ),
                  children: [
                    Center(
                      child:
                          ConstrainedBox(
                        constraints:
                            const BoxConstraints(
                          maxWidth: 1000,
                        ),
                        child:
                            Column(
                          children: [
                            // ==================================================
                            // HEADER
                            // ==================================================

                            _RankingHeader(
                              grade:
                                  widget.grade,
                              total:
                                  records.length,
                            ),

                            const SizedBox(
                              height: 15,
                            ),

                            // ==================================================
                            // INFO
                            // ==================================================

                            Container(
                              width:
                                  double.infinity,
                              padding:
                                  const EdgeInsets
                                      .symmetric(
                                horizontal:
                                    15,
                                vertical:
                                    13,
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
                                  19,
                                ),
                                border:
                                    Border.all(
                                  color:
                                      const Color(
                                    0xFFE0EBF4,
                                  ),
                                ),
                              ),
                              child:
                                  const Row(
                                children: [
                                  Icon(
                                    Icons
                                        .info_outline_rounded,
                                    size:
                                        20,
                                    color:
                                        Color(
                                      0xFF4B7BEC,
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        9,
                                  ),
                                  Expanded(
                                    child:
                                        Text(
                                      'Peringkat diurutkan berdasarkan persentase nilai, lalu skor.',
                                      style:
                                          TextStyle(
                                        fontSize:
                                            11,
                                        color:
                                            Color(
                                          0xFF667D92,
                                        ),
                                        fontWeight:
                                            FontWeight
                                                .w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(
                              height: 15,
                            ),

                            // ==================================================
                            // LIST
                            // ==================================================

                            ...List.generate(
                              records.length,
                              (index) {
                                final record =
                                    records[
                                        index];

                                return Padding(
                                  padding:
                                      const EdgeInsets
                                          .only(
                                    bottom:
                                        11,
                                  ),
                                  child:
                                      _RankingCard(
                                    rank:
                                        index +
                                            1,
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

// ============================================================
// RANKING HEADER
// ============================================================

class _RankingHeader
    extends StatelessWidget {
  const _RankingHeader({
    required this.grade,
    required this.total,
  });

  final int? grade;
  final int total;

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(
        21,
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
            Color(0xFF4B7BEC),
            Color(0xFF62C9F7),
            Color(0xFF72D7B0),
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
                Color(0x284B7BEC),
            blurRadius: 22,
            offset:
                Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 65,
            height: 65,
            decoration:
                BoxDecoration(
              color: Colors.white
                  .withOpacity(
                .19,
              ),
              borderRadius:
                  BorderRadius.circular(
                20,
              ),
              border: Border.all(
                color: Colors.white
                    .withOpacity(
                  .35,
                ),
              ),
            ),
            child:
                const Icon(
              Icons
                  .emoji_events_rounded,
              color:
                  Colors.white,
              size: 38,
            ),
          ),

          const SizedBox(
            width: 14,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              children: [
                Text(
                  grade == null
                      ? 'Peringkat Semua Kelas'
                      : 'Peringkat Kelas $grade',
                  style:
                      const TextStyle(
                    color:
                        Colors.white,
                    fontSize: 20,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),

                const SizedBox(
                  height: 5,
                ),

                Text(
                  '$total siswa telah mengerjakan kuis',
                  style:
                      TextStyle(
                    color: Colors
                        .white
                        .withOpacity(
                      .90,
                    ),
                    fontWeight:
                        FontWeight.w700,
                    fontSize: 11,
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
// RANKING CARD
// ============================================================

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

  Color get medalColor {
    if (rank == 1) {
      return const Color(
        0xFFFFC83D,
      );
    }

    if (rank == 2) {
      return const Color(
        0xFFB9C4CF,
      );
    }

    if (rank == 3) {
      return const Color(
        0xFFCD8A54,
      );
    }

    return const Color(
      0xFFEAF2FF,
    );
  }

  Color get percentageColor {
    if (percentage >= 80) {
      return const Color(
        0xFF36B96D,
      );
    }

    if (percentage >= 60) {
      return const Color(
        0xFFF0A23A,
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
    final topThree =
        rank <= 3;

    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(
        15,
      ),
      decoration:
          BoxDecoration(
        color: Colors.white
            .withOpacity(.97),
        borderRadius:
            BorderRadius.circular(
          23,
        ),
        border: Border.all(
          color: topThree
              ? medalColor
                  .withOpacity(
                  .35,
                )
              : const Color(
                  0xFFE0EAF2,
                ),
          width: topThree
              ? 1.5
              : 1,
        ),
        boxShadow:
            const [
          BoxShadow(
            color:
                Color(0x10000000),
            blurRadius: 14,
            offset:
                Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // ==================================================
          // RANK NUMBER
          // ==================================================

          Stack(
            clipBehavior:
                Clip.none,
            children: [
              Container(
                width: 53,
                height: 53,
                alignment:
                    Alignment.center,
                decoration:
                    BoxDecoration(
                  gradient:
                      topThree
                          ? LinearGradient(
                              colors: [
                                medalColor,
                                medalColor
                                    .withOpacity(
                                  .75,
                                ),
                              ],
                            )
                          : null,
                  color: topThree
                      ? null
                      : const Color(
                          0xFFEAF3FF,
                        ),
                  shape:
                      BoxShape.circle,
                ),
                child: Text(
                  '$rank',
                  style:
                      TextStyle(
                    fontSize: 18,
                    fontWeight:
                        FontWeight.w900,
                    color: topThree
                        ? Colors.white
                        : const Color(
                            0xFF4F8FF7,
                          ),
                  ),
                ),
              ),

              if (rank == 1)
                const Positioned(
                  top: -8,
                  right: -3,
                  child: Text(
                    '👑',
                    style:
                        TextStyle(
                      fontSize: 19,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(
            width: 13,
          ),

          // ==================================================
          // NAME + SCORE
          // ==================================================

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              children: [
                Text(
                  record.name,
                  maxLines: 1,
                  overflow:
                      TextOverflow
                          .ellipsis,
                  style:
                      const TextStyle(
                    fontSize: 16,
                    fontWeight:
                        FontWeight.w900,
                    color:
                        Color(
                      0xFF263E5D,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 4,
                ),

                Row(
                  children: [
                    const Icon(
                      Icons
                          .stars_rounded,
                      size: 15,
                      color:
                          Color(
                        0xFFFFB84D,
                      ),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      'Skor ${record.score}/${record.total}',
                      style:
                          const TextStyle(
                        color:
                            Color(
                          0xFF71869A,
                        ),
                        fontWeight:
                            FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 3,
                ),

                Text(
                  date,
                  style:
                      const TextStyle(
                    fontSize: 10,
                    color:
                        Color(
                      0xFF9AA9B5,
                    ),
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(
            width: 8,
          ),

          // ==================================================
          // PERCENTAGE
          // ==================================================

          Container(
            padding:
                const EdgeInsets
                    .symmetric(
              horizontal: 12,
              vertical: 9,
            ),
            decoration:
                BoxDecoration(
              color:
                  percentageColor
                      .withOpacity(
                .11,
              ),
              borderRadius:
                  BorderRadius.circular(
                15,
              ),
            ),
            child:
                Column(
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                Text(
                  '$percentage%',
                  style:
                      TextStyle(
                    fontWeight:
                        FontWeight.w900,
                    color:
                        percentageColor,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(
                  height: 1,
                ),
                const Text(
                  'nilai',
                  style:
                      TextStyle(
                    fontSize: 8,
                    fontWeight:
                        FontWeight.w700,
                    color:
                        Color(
                      0xFF8A9AAA,
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