import 'package:flutter/material.dart';

import '../models/question.dart';
import '../models/score_record.dart';
import '../services/question_selection_service.dart';
import '../services/score_storage.dart';
import '../widgets/school_background.dart';
import 'quiz_page.dart';

class GradeMenuPage extends StatelessWidget {
  const GradeMenuPage({
    super.key,
    required this.grade,
  });

  final int grade;

  bool get hasTopicSelection => true;

  Future<void> _start(
    BuildContext context, {
    String? topic,
  }) async {
    final name = await _showNameDialog(context);

    if (name == null || name.trim().isEmpty) {
      return;
    }

    if (!context.mounted) return;

    final questions =
        await QuestionSelectionService().selectQuestions(
      grade: grade,
      studentName: name.trim(),
      topic: topic,
    );

    if (!context.mounted) return;

    if (questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF314566),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: const Row(
            children: [
              Icon(
                Icons.info_rounded,
                color: Color(0xFFFFD45A),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Soal untuk kelas ini belum tersedia.',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QuizPage(
          grade: grade,
          studentName: name.trim(),
          topic: topic,
          questions: questions,
          onFinished: (score, total) async {
            await ScoreStorage().saveRecord(
              ScoreRecord(
                name: name.trim(),
                grade: grade,
                score: score,
                total: total,
                completedAt: DateTime.now(),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<String?> _showNameDialog(
    BuildContext context,
  ) async {
    final controller = TextEditingController();

    final result = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 24,
          ),
          child: Center(
            child: ConstrainedBox(
              // Dibatasi supaya di layar lebar (web/desktop)
              // dialognya tidak melar hampir sepanjang layar.
              constraints: const BoxConstraints(
                maxWidth: 380,
              ),
              child: Container(
                padding: const EdgeInsets.fromLTRB(
                  22,
                  24,
                  22,
                  18,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x30000000),
                      blurRadius: 30,
                      offset: Offset(0, 14),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF65CFFF),
                            Color(0xFF4B7BEC),
                          ],
                        ),
                        borderRadius:
                            BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x334B7BEC),
                            blurRadius: 16,
                            offset: Offset(0, 7),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),

                    const SizedBox(height: 14),

                    const Text(
                      'Siapa nama kamu? 👋',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF283B63),
                      ),
                    ),

                    const SizedBox(height: 5),

                    const Text(
                      'Tulis namamu sebelum memulai petualangan kuis.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.4,
                        color: Color(0xFF7B8CA0),
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 18),

                    TextField(
                      controller: controller,
                      autofocus: true,
                      textCapitalization:
                          TextCapitalization.words,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF283B63),
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: 'Masukkan nama kamu',
                        hintStyle: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFA9B7C7),
                        ),
                        prefixIcon: const Icon(
                          Icons.person_outline_rounded,
                          color: Color(0xFF4B7BEC),
                          size: 20,
                        ),
                        prefixIconConstraints:
                            const BoxConstraints(
                          minWidth: 42,
                          minHeight: 20,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF4FAFF),
                        contentPadding:
                            const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 13,
                        ),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: Color(0xFFDCEAF6),
                            width: 1.2,
                          ),
                        ),
                        focusedBorder:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: Color(0xFF4B7BEC),
                            width: 1.8,
                          ),
                        ),
                      ),
                      onSubmitted: (_) {
                        final value =
                            controller.text.trim();

                        if (value.isNotEmpty) {
                          Navigator.pop(
                            dialogContext,
                            value,
                          );
                        }
                      },
                    ),

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(
                                dialogContext,
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor:
                                  const Color(0xFF71839A),
                              side: const BorderSide(
                                color: Color(0xFFD8E6F1),
                              ),
                              minimumSize:
                                  const Size(0, 46),
                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                  14,
                                ),
                              ),
                            ),
                            child: const Text(
                              'Batal',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight:
                                    FontWeight.w800,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          flex: 2,
                          child: FilledButton.icon(
                            onPressed: () {
                              final value =
                                  controller.text.trim();

                              if (value.isEmpty) {
                                return;
                              }

                              Navigator.pop(
                                dialogContext,
                                value,
                              );
                            },
                            icon: const Icon(
                              Icons.play_arrow_rounded,
                              size: 19,
                            ),
                            label: const Text(
                              'Mulai',
                              style: TextStyle(
                                fontSize: 13,
                              ),
                            ),
                            style:
                                FilledButton.styleFrom(
                              backgroundColor:
                                  const Color(0xFF4B7BEC),
                              foregroundColor:
                                  Colors.white,
                              minimumSize:
                                  const Size(0, 46),
                              elevation: 3,
                              shadowColor:
                                  const Color(0x334B7BEC),
                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                  14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    controller.dispose();

    return result;
  }

  Future<void> _chooseTopic(
    BuildContext context,
  ) async {
    final topic = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 24,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 380,
              ),
              child: Container(
            padding: const EdgeInsets.fromLTRB(
              22,
              24,
              22,
              20,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x30000000),
                  blurRadius: 30,
                  offset: Offset(0, 14),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFFFD96B),
                        Color(0xFFFFB84D),
                      ],
                    ),
                    borderRadius:
                        BorderRadius.circular(23),
                  ),
                  child: const Icon(
                    Icons.category_rounded,
                    color: Colors.white,
                    size: 37,
                  ),
                ),

                const SizedBox(height: 15),

                const Text(
                  'Pilih Tema Kuis 🎯',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF283B63),
                  ),
                ),

                const SizedBox(height: 7),

                const Text(
                  'Pilih tema yang ingin kamu kerjakan terlebih dahulu.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF7B8CA0),
                    height: 1.45,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 20),

                _TopicButton(
                  icon: Icons.favorite_rounded,
                  color: const Color(0xFFFF6F91),
                  title: 'Stop Bullying',
                  subtitle:
                      'Belajar tentang sikap saling menghargai',
                  onTap: () {
                    Navigator.pop(
                      dialogContext,
                      'Stop Bullying',
                    );
                  },
                ),

                const SizedBox(height: 12),

                _TopicButton(
                  icon: Icons.eco_rounded,
                  color: const Color(0xFF45C878),
                  title: 'Adiwiyata',
                  subtitle:
                      'Belajar tentang lingkungan sekolah',
                  onTap: () {
                    Navigator.pop(
                      dialogContext,
                      'Adiwiyata',
                    );
                  },
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                    },
                    child: const Text(
                      'Nanti saja',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
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
      },
    );

    if (topic == null || !context.mounted) {
      return;
    }

    await _start(
      context,
      topic: topic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SchoolBackground(
        child: SafeArea(
          child: Scrollbar(
            thumbVisibility:
                MediaQuery.sizeOf(context).width >=
                    900,
            trackVisibility:
                MediaQuery.sizeOf(context).width >=
                    900,
            interactive: true,
            thickness: 8,
            radius: const Radius.circular(20),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                20,
                20,
                20,
                80,
              ),
              children: [
                // Header (tombol kembali + logo + judul kelas)
                // sengaja DILEPAS dari ConstrainedBox(maxWidth: 900)
                // di bawah supaya menempel ke pojok kiri layar,
                // bukan ikut ke tengah saat layar lebar (web/desktop).
                Align(
                  alignment:
                      Alignment.centerLeft,
                  child: _Header(
                    grade: grade,
                  ),
                ),

                const SizedBox(height: 25),

                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 900,
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding:
                              const EdgeInsets.all(25),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(
                              30,
                            ),
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color:
                                    Color(0x18000000),
                                blurRadius: 25,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                padding:
                                    const EdgeInsets.all(
                                  12,
                                ),
                                decoration: BoxDecoration(
                                  gradient:
                                      const LinearGradient(
                                    begin:
                                        Alignment.topLeft,
                                    end: Alignment
                                        .bottomRight,
                                    colors: [
                                      Color(0xFF6CD4FF),
                                      Color(0xFF4B7BEC),
                                    ],
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(
                                    30,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color:
                                          Color(0x334B7BEC),
                                      blurRadius: 20,
                                      offset:
                                          Offset(0, 9),
                                    ),
                                  ],
                                ),
                                // Ikon geometris diganti gambar
                                // ilustrasi "Kelas N" dari assets
                                // supaya senada dengan kartu di
                                // dashboard. Kalau file belum ada,
                                // otomatis balik ke ikon lama.
                                child: Image.asset(
                                  'assets/Kelas $grade.png',
                                  fit: BoxFit.contain,
                                  errorBuilder: (
                                    context,
                                    error,
                                    stackTrace,
                                  ) {
                                    return Icon(
                                      hasTopicSelection
                                          ? Icons
                                              .category_rounded
                                          : Icons
                                              .quiz_rounded,
                                      size: 43,
                                      color:
                                          Colors.white,
                                    );
                                  },
                                ),
                              ),

                              const SizedBox(height: 16),

                              Text(
                                hasTopicSelection
                                    ? 'Pilih Tema Kuis'
                                    : 'Siap untuk Kuis? 🚀',
                                textAlign:
                                    TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight:
                                      FontWeight.w900,
                                  color:
                                      Color(0xFF283B63),
                                ),
                              ),

                              const SizedBox(height: 8),

                              Text(
                                hasTopicSelection
                                    ? 'Untuk kelas $grade, pilih tema soal terlebih dahulu.'
                                    : 'Masukkan nama dan mulai menjawab soal sesuai tingkat kelasmu.',
                                textAlign:
                                    TextAlign.center,
                                style: const TextStyle(
                                  color:
                                      Color(0xFF7B8CA0),
                                  height: 1.5,
                                  fontSize: 13,
                                  fontWeight:
                                      FontWeight.w600,
                                ),
                              ),

                              const SizedBox(
                                height: 24,
                              ),

                              if (hasTopicSelection)
                                LayoutBuilder(
                                  builder:
                                      (
                                    context,
                                    constraints,
                                  ) {
                                    if (constraints
                                            .maxWidth <
                                        560) {
                                      return Column(
                                        children: [
                                          _TopicCard(
                                            icon: Icons
                                                .favorite_rounded,
                                            color:
                                                const Color(
                                              0xFFFF6F91,
                                            ),
                                            title:
                                                'Stop Bullying',
                                            subtitle:
                                                'Sikap saling menghargai',
                                            onTap: () {
                                              _start(
                                                context,
                                                topic:
                                                    'Stop Bullying',
                                              );
                                            },
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          _TopicCard(
                                            icon: Icons
                                                .eco_rounded,
                                            color:
                                                const Color(
                                              0xFF45C878,
                                            ),
                                            title:
                                                'Adiwiyata',
                                            subtitle:
                                                'Peduli lingkungan',
                                            onTap: () {
                                              _start(
                                                context,
                                                topic:
                                                    'Adiwiyata',
                                              );
                                            },
                                          ),
                                        ],
                                      );
                                    }

                                    return Row(
                                      children: [
                                        Expanded(
                                          child:
                                              _TopicCard(
                                            icon: Icons
                                                .favorite_rounded,
                                            color:
                                                const Color(
                                              0xFFFF6F91,
                                            ),
                                            title:
                                                'Stop Bullying',
                                            subtitle:
                                                'Sikap saling menghargai',
                                            onTap: () {
                                              _start(
                                                context,
                                                topic:
                                                    'Stop Bullying',
                                              );
                                            },
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Expanded(
                                          child:
                                              _TopicCard(
                                            icon: Icons
                                                .eco_rounded,
                                            color:
                                                const Color(
                                              0xFF45C878,
                                            ),
                                            title:
                                                'Adiwiyata',
                                            subtitle:
                                                'Peduli lingkungan',
                                            onTap: () {
                                              _start(
                                                context,
                                                topic:
                                                    'Adiwiyata',
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                )
                              else
                                SizedBox(
                                  width:
                                      double.infinity,
                                  child:
                                      FilledButton.icon(
                                    onPressed: () {
                                      _start(
                                        context,
                                      );
                                    },
                                    icon: const Icon(
                                      Icons
                                          .play_arrow_rounded,
                                      size: 24,
                                    ),
                                    label: const Text(
                                      'Mulai Kuis',
                                    ),
                                    style:
                                        FilledButton.styleFrom(
                                      backgroundColor:
                                          const Color(
                                        0xFF4B7BEC,
                                      ),
                                      foregroundColor:
                                          Colors.white,
                                      elevation: 4,
                                      shadowColor:
                                          const Color(
                                        0x334B7BEC,
                                      ),
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

                        const SizedBox(height: 20),

                        _InfoCard(
                          grade: grade,
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

class _Header extends StatelessWidget {
  const _Header({
    required this.grade,
  });

  final int grade;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Material(
          color: Colors.white.withOpacity(.92),
          shape: const CircleBorder(),
          elevation: 2,
          shadowColor:
              const Color(0x22000000),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Color(0xFF283B63),
            ),
            tooltip: 'Kembali',
          ),
        ),

        const SizedBox(width: 10),

        Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFFE47A),
                Color(0xFFFFB84D),
              ],
            ),
            borderRadius:
                BorderRadius.circular(19),
            boxShadow: const [
              BoxShadow(
                color: Color(0x30FFB84D),
                blurRadius: 14,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(
            Icons.school_rounded,
            color: Colors.white,
            size: 32,
          ),
        ),

        const SizedBox(width: 13),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                'Kelas $grade SD',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF283B63),
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Petualangan belajar dimulai! ✨',
                style: TextStyle(
                  color: Color(0xFF71839A),
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TopicCard extends StatelessWidget {
  const _TopicCard({
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
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius:
            BorderRadius.circular(24),
        child: Container(
          padding:
              const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(.13),
                Colors.white,
              ],
            ),
            borderRadius:
                BorderRadius.circular(24),
            border: Border.all(
              color: color.withOpacity(.30),
              width: 1.7,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(.12),
                blurRadius: 16,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      color,
                      color.withOpacity(.78),
                    ],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(.28),
                      blurRadius: 15,
                      offset:
                          const Offset(0, 6),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 34,
                ),
              ),

              const SizedBox(height: 13),

              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight:
                      FontWeight.w900,
                  color: color,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF71839A),
                  fontWeight:
                      FontWeight.w600,
                  height: 1.35,
                ),
              ),

              const SizedBox(height: 13),

              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color:
                      color.withOpacity(.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: color,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopicButton extends StatelessWidget {
  const _TopicButton({
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
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius:
            BorderRadius.circular(18),
        child: Container(
          width: double.infinity,
          padding:
              const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: color.withOpacity(.07),
            borderRadius:
                BorderRadius.circular(18),
            border: Border.all(
              color: color.withOpacity(.25),
              width: 1.3,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      color,
                      color.withOpacity(.78),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 23,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight:
                            FontWeight.w900,
                        color: color,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style:
                          const TextStyle(
                        fontSize: 11,
                        color:
                            Color(0xFF7B8CA0),
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color:
                      color.withOpacity(.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons
                      .arrow_forward_ios_rounded,
                  size: 14,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.grade,
  });

  final int grade;

  @override
  Widget build(BuildContext context) {
    const bool topic = true;

    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFFCF1),
            Color(0xFFFFF8D8),
          ],
        ),
        borderRadius:
            BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFFFD66B)
              .withOpacity(.45),
          width: 1.3,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 12,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: const BoxDecoration(
              color: Color(0xFFFFD66B),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lightbulb_rounded,
              color: Colors.white,
              size: 25,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  'Info Kuis',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF765A18),
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  topic
                      ? 'Untuk kelas $grade, kamu dapat memilih tema Stop Bullying atau Adiwiyata sebelum memasukkan nama dan mengerjakan kuis.'
                      : 'Kamu akan mendapatkan 10 soal secara acak dari kumpulan soal kelas $grade.',
                  style: const TextStyle(
                    color: Color(0xFF6F6549),
                    height: 1.45,
                    fontWeight:
                        FontWeight.w600,
                    fontSize: 12,
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