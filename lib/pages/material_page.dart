import 'package:flutter/material.dart';

import 'school_ui.dart';

class LearningMaterialPage extends StatelessWidget {
  const LearningMaterialPage({super.key});

  @override
  Widget build(BuildContext context) {
    final subjects = [
      (
        'Matematika',
        'Belajar angka, hitungan, dan logika.',
        Icons.calculate_rounded,
        SchoolColors.blue,
      ),
      (
        'Bahasa Indonesia',
        'Membaca, memahami, dan berbahasa.',
        Icons.menu_book_rounded,
        SchoolColors.pink,
      ),
      (
        'PKN',
        'Belajar menjadi warga negara yang baik.',
        Icons.flag_rounded,
        SchoolColors.yellow,
      ),
      (
        'IPA',
        'Kenali dunia dan lingkungan sekitar.',
        Icons.science_rounded,
        SchoolColors.green,
      ),
      (
        'Logika',
        'Latih otak dengan teka-teki seru.',
        Icons.psychology_rounded,
        SchoolColors.purple,
      ),
    ];

    return Scaffold(
      body: SchoolBackground(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor:
                    Colors.transparent,
                title: const Text(
                  'Perpustakaan Ceria',
                ),
                leading: Container(
                  margin: const EdgeInsets.all(7),
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
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.fromLTRB(
                    20,
                    15,
                    20,
                    20,
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding:
                            const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(28),
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
                                    '📚 Yuk, Belajar!',
                                    style: TextStyle(
                                      fontSize: 23,
                                      fontWeight:
                                          FontWeight.w900,
                                      color:
                                          SchoolColors
                                              .darkBlue,
                                    ),
                                  ),
                                  SizedBox(height: 7),
                                  Text(
                                    'Pilih buku yang ingin kamu pelajari hari ini.',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color:
                                          Color(
                                        0xFF718399,
                                      ),
                                      fontWeight:
                                          FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            AnimatedAssetCharacter(
                              asset:
                                  'assets/Gambar guru l.jpeg',
                              width: 105,
                              height: 105,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  0,
                  20,
                  90,
                ),
                sliver: SliverList(
                  delegate:
                      SliverChildBuilderDelegate(
                    (context, index) {
                      final subject =
                          subjects[index];

                      return Padding(
                        padding:
                            const EdgeInsets.only(
                          bottom: 13,
                        ),
                        child: PressableCard(
                          onTap: () {
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Materi ${subject.$1} siap dipelajari!',
                                ),
                                behavior:
                                    SnackBarBehavior
                                        .floating,
                              ),
                            );
                          },
                          child: Container(
                            padding:
                                const EdgeInsets.all(
                              17,
                            ),
                            decoration:
                                BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(
                                23,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: subject.$4
                                      .withOpacity(.08),
                                  blurRadius: 18,
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
                                  width: 62,
                                  height: 62,
                                  decoration:
                                      BoxDecoration(
                                    color: subject.$4
                                        .withOpacity(
                                      .13,
                                    ),
                                    borderRadius:
                                        BorderRadius
                                            .circular(
                                      18,
                                    ),
                                  ),
                                  child: Icon(
                                    subject.$3,
                                    color:
                                        subject.$4,
                                    size: 31,
                                  ),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                    children: [
                                      Text(
                                        subject.$1,
                                        style:
                                            const TextStyle(
                                          fontSize: 17,
                                          fontWeight:
                                              FontWeight
                                                  .w900,
                                          color:
                                              SchoolColors
                                                  .darkBlue,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        subject.$2,
                                        style:
                                            const TextStyle(
                                          fontSize: 11,
                                          color:
                                              Color(
                                            0xFF718399,
                                          ),
                                          fontWeight:
                                              FontWeight
                                                  .w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons
                                      .arrow_forward_ios_rounded,
                                  color: subject.$4,
                                  size: 17,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: subjects.length,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
