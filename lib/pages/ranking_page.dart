import 'package:flutter/material.dart';

import '../models/score_record.dart';
import '../services/score_storage.dart';
import '../widgets/school_background.dart';

class RankingPage
    extends StatefulWidget {
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
  final storage = ScoreStorage();

  late Future<
      List<ScoreRecord>> records;

  late DateTime day;

  @override
  void initState() {
    super.initState();

    day = DateTime.now();

    load();
  }

  void load() {
    records =
        storage.loadRecords(
      grade: widget.grade,
    );
  }

  bool same(
    ScoreRecord record,
  ) {
    return record.completedAt.year ==
            day.year &&
        record.completedAt.month ==
            day.month &&
        record.completedAt.day ==
            day.day;
  }

  Future<void> reset() async {
    if (widget.grade == null) {
      return;
    }

    final ok =
        await showDialog<bool>(
      context: context,
      builder: (context) =>
          AlertDialog(
        title: const Text(
          'Reset peringkat hari ini?',
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
            child:
                const Text('Batal'),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.pop(
              context,
              true,
            ),
            child:
                const Text('Reset'),
          ),
        ],
      ),
    );

    if (ok != true) {
      return;
    }

    await storage
        .resetTodayForGrade(
      widget.grade!,
    );

    if (mounted) {
      setState(load);
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final title =
        widget.grade == null
            ? 'Semua Kelas'
            : 'Kelas ${widget.grade}';

    return Scaffold(
      body: SchoolBackground(
        showSchoolIllustrations:
            false,
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints(
                maxWidth: 1050,
              ),
              child: Padding(
                padding:
                    const EdgeInsets.fromLTRB(
                  20,
                  20,
                  20,
                  20,
                ),
                child:
                    FutureBuilder<
                        List<ScoreRecord>>(
                  future: records,
                  builder:
                      (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child:
                            CircularProgressIndicator(),
                      );
                    }

                    final list =
                        snapshot.data!
                            .where(
                              same,
                            )
                            .toList()
                          ..sort(
                            (a, b) => b
                                .percentage
                                .compareTo(
                              a.percentage,
                            ),
                          );

                    final days =
                        snapshot.data!
                            .map(
                              (record) =>
                                  DateUtils
                                      .dateOnly(
                                record
                                    .completedAt,
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
                        day,
                      ),
                    )) {
                      days.insert(
                        0,
                        DateUtils.dateOnly(
                          day,
                        ),
                      );
                    }

                    return Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration:
                                  BoxDecoration(
                                color:
                                    Colors.white,
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                  17,
                                ),
                              ),
                              child:
                                  const Icon(
                                Icons
                                    .emoji_events_rounded,
                                color:
                                    Color(
                                  0xFFFFB93F,
                                ),
                                size: 30,
                              ),
                            ),

                            const SizedBox(
                              width: 12,
                            ),

                            Expanded(
                              child:
                                  Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                children: [
                                  Text(
                                    'Peringkat $title',
                                    style:
                                        const TextStyle(
                                      fontSize:
                                          22,
                                      fontWeight:
                                          FontWeight
                                              .w900,
                                      color:
                                          Color(
                                        0xFF243B5A,
                                      ),
                                    ),
                                  ),
                                  const Text(
                                    'Siapa yang jadi bintang hari ini?',
                                    style:
                                        TextStyle(
                                      fontSize:
                                          12,
                                      color:
                                          Color(
                                        0xFF71869A,
                                      ),
                                      fontWeight:
                                          FontWeight
                                              .w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            if (widget.grade !=
                                null)
                              IconButton(
                                onPressed:
                                    reset,
                                icon:
                                    const Icon(
                                  Icons
                                      .restart_alt_rounded,
                                ),
                              ),
                          ],
                        ),

                        const SizedBox(
                          height: 14,
                        ),

                        Container(
                          padding:
                              const EdgeInsets.all(
                            12,
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
                              20,
                            ),
                          ),
                          child:
                              DropdownButtonFormField<
                                  DateTime>(
                            value:
                                DateUtils
                                    .dateOnly(
                              day,
                            ),
                            decoration:
                                const InputDecoration(
                              labelText:
                                  'Riwayat tanggal',
                              prefixIcon:
                                  Icon(
                                Icons
                                    .calendar_month_rounded,
                              ),
                              border:
                                  InputBorder
                                      .none,
                            ),
                            items: days
                                .map(
                              (d) =>
                                  DropdownMenuItem(
                                value: d,
                                child:
                                    Text(
                                  MaterialLocalizations
                                      .of(
                                    context,
                                  ).formatMediumDate(
                                    d,
                                  ),
                                ),
                              ),
                            )
                                .toList(),
                            onChanged: (d) {
                              if (d !=
                                  null) {
                                setState(
                                  () =>
                                      day =
                                          d,
                                );
                              }
                            },
                          ),
                        ),

                        const SizedBox(
                          height: 12,
                        ),

                        Expanded(
                          child: list
                                  .isEmpty
                              ? const _Empty()
                              : Scrollbar(
                                  child:
                                      ListView
                                          .separated(
                                    itemCount:
                                        list.length,
                                    padding:
                                        const EdgeInsets
                                            .only(
                                      right: 7,
                                      bottom:
                                          20,
                                    ),
                                    separatorBuilder:
                                        (
                                      _,
                                      __,
                                    ) =>
                                            const SizedBox(
                                      height: 10,
                                    ),
                                    itemBuilder:
                                        (
                                      _,
                                      i,
                                    ) =>
                                            _Tile(
                                      record:
                                          list[i],
                                      rank:
                                          i + 1,
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Tile
    extends StatelessWidget {
  const _Tile({
    required this.record,
    required this.rank,
  });

  final ScoreRecord record;
  final int rank;

  @override
  Widget build(
    BuildContext context,
  ) {
    final top = rank <= 3;

    final medal =
        rank == 1
            ? '🥇'
            : rank == 2
                ? '🥈'
                : rank == 3
                    ? '🥉'
                    : '$rank';

    return Container(
      padding:
          const EdgeInsets.all(14),
      decoration:
          BoxDecoration(
        color:
            Colors.white.withOpacity(.95),
        borderRadius:
            BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(.05),
            blurRadius: 12,
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
            alignment:
                Alignment.center,
            decoration:
                BoxDecoration(
              color: top
                  ? const Color(
                      0xFFFFF0C2,
                    )
                  : const Color(
                      0xFFEAF2FF,
                    ),
              borderRadius:
                  BorderRadius.circular(
                15,
              ),
            ),
            child: Text(
              medal,
              style: TextStyle(
                fontSize:
                    top ? 23 : 16,
                fontWeight:
                    FontWeight.w900,
              ),
            ),
          ),

          const SizedBox(
            width: 12,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  record.name,
                  style:
                      const TextStyle(
                    fontWeight:
                        FontWeight.w900,
                    color:
                        Color(0xFF263E5D),
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Kelas ${record.grade} • '
                  '${record.score}/${record.total} poin',
                  style:
                      const TextStyle(
                    fontSize: 11,
                    color:
                        Color(0xFF74879A),
                  ),
                ),
              ],
            ),
          ),

          Text(
            '${record.percentage}%',
            style:
                const TextStyle(
              fontSize: 20,
              fontWeight:
                  FontWeight.w900,
              color:
                  Color(0xFF43B875),
            ),
          ),
        ],
      ),
    );
  }
}

class _Empty
    extends StatelessWidget {
  const _Empty();

  @override
  Widget build(
    BuildContext context,
  ) {
    return Center(
      child: Container(
        padding:
            const EdgeInsets.all(25),
        decoration:
            BoxDecoration(
          color: Colors.white
              .withOpacity(.93),
          borderRadius:
              BorderRadius.circular(
            26,
          ),
        ),
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            SizedBox(
              height: 105,
              child: Image.asset(
                'assets/Gambar guru p.jpeg',
                fit: BoxFit.contain,
              ),
            ),

            const Text(
              'Belum ada nilai',
              style:
                  TextStyle(
                fontSize: 19,
                fontWeight:
                    FontWeight.w900,
                color:
                    Color(0xFF263E5D),
              ),
            ),

            const SizedBox(
              height: 4,
            ),

            const Text(
              'Ayo main kuis dan jadilah bintang pertama!',
              textAlign:
                  TextAlign.center,
              style:
                  TextStyle(
                color:
                    Color(0xFF74879A),
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}