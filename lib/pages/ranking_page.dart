import 'package:flutter/material.dart';

import '../models/score_record.dart';
import '../services/score_storage.dart';
import 'school_ui.dart';

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
    _records =
        _storage.loadRecords(
      grade: widget.grade,
    );
  }

  bool _isSelectedDay(
    ScoreRecord record,
  ) {
    return record.completedAt.year ==
            _selectedDay.year &&
        record.completedAt.month ==
            _selectedDay.month &&
        record.completedAt.day ==
            _selectedDay.day;
  }

  Future<void> _resetToday() async {
    if (widget.grade == null) return;

    final confirmed =
        await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(25),
          ),
          title: const Text(
            'Reset peringkat?',
            style: TextStyle(
              fontWeight: FontWeight.w900,
            ),
          ),
          content: const Text(
            'Semua nilai kelas ini yang dibuat hari ini akan dihapus.',
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(
                context,
                false,
              ),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () =>
                  Navigator.pop(
                context,
                true,
              ),
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    await _storage.resetTodayForGrade(
      widget.grade!,
    );

    if (!mounted) return;

    setState(_loadRecords);
  }

  @override
  Widget build(BuildContext context) {
    final gradeTitle =
        widget.grade == null
            ? 'Semua Kelas'
            : 'Kelas ${widget.grade}';

    return Scaffold(
      body: SchoolBackground(
        child: SafeArea(
          child: FutureBuilder<List<ScoreRecord>>(
            future: _records,
            builder:
                (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child:
                      CircularProgressIndicator(),
                );
              }

              final allRecords =
                  snapshot.data!;

              final records =
                  allRecords
                      .where(
                        _isSelectedDay,
                      )
                      .toList()
                    ..sort(
                      (a, b) =>
                          b.percentage.compareTo(
                        a.percentage,
                      ),
                    );

              final days =
                  allRecords
                      .map(
                        (record) =>
                            DateUtils.dateOnly(
                          record.completedAt,
                        ),
                      )
                      .toSet()
                      .toList()
                    ..sort(
                      (a, b) =>
                          b.compareTo(a),
                    );

              if (!days.contains(
                DateUtils.dateOnly(
                  _selectedDay,
                ),
              )) {
                days.insert(
                  0,
                  DateUtils.dateOnly(
                    _selectedDay,
                  ),
                );
              }

              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    backgroundColor:
                        Colors.transparent,
                    leading: Container(
                      margin:
                          const EdgeInsets.all(7),
                      decoration:
                          BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(
                          15,
                        ),
                      ),
                      child: IconButton(
                        onPressed: () =>
                            Navigator.pop(
                          context,
                        ),
                        icon: const Icon(
                          Icons
                              .arrow_back_rounded,
                        ),
                      ),
                    ),
                    title: Text(
                      'Peringkat $gradeTitle',
                    ),
                    actions: [
                      if (widget.grade != null)
                        IconButton(
                          onPressed:
                              _resetToday,
                          tooltip:
                              'Reset skor hari ini',
                          icon: const Icon(
                            Icons
                                .restart_alt_rounded,
                          ),
                        ),
                    ],
                  ),

                  SliverToBoxAdapter(
                    child: Padding(
                      padding:
                          const EdgeInsets.fromLTRB(
                        20,
                        10,
                        20,
                        18,
                      ),
                      child: Column(
                        children: [
                          Container(
                            width:
                                double.infinity,
                            padding:
                                const EdgeInsets.all(
                              22,
                            ),
                            decoration:
                                BoxDecoration(
                              gradient:
                                  const LinearGradient(
                                colors: [
                                  SchoolColors
                                      .yellow,
                                  Color(
                                    0xFFFFE58A,
                                  ),
                                ],
                              ),
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                28,
                              ),
                            ),
                            child: Row(
                              children: [
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                    children: [
                                      Text(
                                        '🏆 Top Siswa',
                                        style:
                                            TextStyle(
                                          color:
                                              SchoolColors
                                                  .darkBlue,
                                          fontSize:
                                              22,
                                          fontWeight:
                                              FontWeight
                                                  .w900,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        'Siapa yang jadi juara hari ini?',
                                        style:
                                            TextStyle(
                                          color:
                                              Color(
                                            0xFF75652A,
                                          ),
                                          fontSize:
                                              12,
                                          fontWeight:
                                              FontWeight
                                                  .w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                AnimatedAssetCharacter(
                                  asset:
                                      'assets/Gambar anak anak sd.jpeg',
                                  width: 100,
                                  height: 80,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(
                            height: 16,
                          ),

                          DropdownButtonFormField<
                              DateTime>(
                            value:
                                DateUtils.dateOnly(
                              _selectedDay,
                            ),
                            decoration:
                                const InputDecoration(
                              labelText:
                                  'Riwayat tanggal',
                              prefixIcon: Icon(
                                Icons
                                    .calendar_month_rounded,
                              ),
                            ),
                            items: days
                                .map(
                                  (
                                    day,
                                  ) =>
                                      DropdownMenuItem(
                                    value: day,
                                    child: Text(
                                      MaterialLocalizations
                                          .of(
                                        context,
                                      ).formatMediumDate(
                                        day,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged:
                                (day) {
                              if (day == null) {
                                return;
                              }

                              setState(
                                () =>
                                    _selectedDay =
                                        day,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  if (records.isEmpty)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Padding(
                          padding:
                              EdgeInsets.all(30),
                          child: Text(
                            'Belum ada nilai pada tanggal ini.',
                            textAlign:
                                TextAlign.center,
                            style: TextStyle(
                              color:
                                  Color(
                                0xFF718399,
                              ),
                              fontWeight:
                                  FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding:
                          const EdgeInsets.fromLTRB(
                        20,
                        0,
                        20,
                        80,
                      ),
                      sliver: SliverList(
                        delegate:
                            SliverChildBuilderDelegate(
                          (context, index) {
                            final record =
                                records[index];

                            final rank =
                                index + 1;

                            final color =
                                rank == 1
                                    ? SchoolColors
                                        .yellow
                                    : rank == 2
                                        ? const Color(
                                            0xFFB9C4D0,
                                          )
                                        : rank == 3
                                            ? SchoolColors
                                                .orange
                                            : SchoolColors
                                                .blue;

                            return Padding(
                              padding:
                                  const EdgeInsets
                                      .only(
                                bottom: 12,
                              ),
                              child: PressableCard(
                                onTap: () {},
                                child:
                                    Container(
                                  padding:
                                      const EdgeInsets
                                          .all(
                                    16,
                                  ),
                                  decoration:
                                      BoxDecoration(
                                    color:
                                        Colors.white,
                                    borderRadius:
                                        BorderRadius
                                            .circular(
                                      23,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: color
                                            .withOpacity(
                                          .08,
                                        ),
                                        blurRadius:
                                            18,
                                        offset:
                                            const Offset(
                                          0,
                                          7,
                                        ),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 55,
                                        height: 55,
                                        decoration:
                                            BoxDecoration(
                                          color: color
                                              .withOpacity(
                                            .18,
                                          ),
                                          shape:
                                              BoxShape
                                                  .circle,
                                        ),
                                        child:
                                            Center(
                                          child: Text(
                                            '$rank',
                                            style:
                                                TextStyle(
                                              color:
                                                  color,
                                              fontSize:
                                                  21,
                                              fontWeight:
                                                  FontWeight
                                                      .w900,
                                            ),
                                          ),
                                        ),
                                      ),

                                      const SizedBox(
                                        width: 14,
                                      ),

                                      Expanded(
                                        child:
                                            Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,
                                          children: [
                                            Text(
                                              record
                                                  .name,
                                              style:
                                                  const TextStyle(
                                                color:
                                                    SchoolColors
                                                        .darkBlue,
                                                fontSize:
                                                    16,
                                                fontWeight:
                                                    FontWeight
                                                        .w900,
                                              ),
                                            ),
                                            const SizedBox(
                                              height:
                                                  4,
                                            ),
                                            Text(
                                              'Kelas ${record.grade} • ${record.score}/${record.total} poin',
                                              style:
                                                  const TextStyle(
                                                color:
                                                    Color(
                                                  0xFF718399,
                                                ),
                                                fontSize:
                                                    11,
                                                fontWeight:
                                                    FontWeight
                                                        .w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      Container(
                                        padding:
                                            const EdgeInsets
                                                .symmetric(
                                          horizontal:
                                              11,
                                          vertical:
                                              8,
                                        ),
                                        decoration:
                                            BoxDecoration(
                                          color: color
                                              .withOpacity(
                                            .13,
                                          ),
                                          borderRadius:
                                              BorderRadius
                                                  .circular(
                                            13,
                                          ),
                                        ),
                                        child:
                                            Text(
                                          '${record.percentage}%',
                                          style:
                                              TextStyle(
                                            color:
                                                color,
                                            fontWeight:
                                                FontWeight
                                                    .w900,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          childCount:
                              records.length,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
