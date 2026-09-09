import 'package:flutter/material.dart';

import '../widgets/school_background.dart';
import 'grade_menu_page.dart';
import 'material_page.dart';
import 'ranking_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() =>
      _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [
        _Home(
          onGrade: (grade) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    GradeMenuPage(
                  grade: grade,
                ),
              ),
            );
          },
        ),
        const LearningMaterialPage(),
        const RankingPage(),
      ][index],

      bottomNavigationBar:
          NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (value) {
          setState(() {
            index = value;
          });
        },
        backgroundColor: Colors.white,
        indicatorColor:
            const Color(0xFFFFE29A),

        destinations: const [
          NavigationDestination(
            icon: Icon(
              Icons.home_outlined,
            ),
            selectedIcon: Icon(
              Icons.home_rounded,
            ),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.menu_book_outlined,
            ),
            selectedIcon: Icon(
              Icons.menu_book_rounded,
            ),
            label: 'Materi',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.emoji_events_outlined,
            ),
            selectedIcon: Icon(
              Icons.emoji_events_rounded,
            ),
            label: 'Peringkat',
          ),
        ],
      ),
    );
  }
}

class _Home extends StatelessWidget {
  const _Home({
    required this.onGrade,
  });

  final ValueChanged<int> onGrade;

  static const grades = [
    [
      '1',
      'Pemula Hebat',
      Icons.looks_one_rounded,
      Color(0xFFFF8A65),
    ],
    [
      '2',
      'Penjelajah',
      Icons.looks_two_rounded,
      Color(0xFFFF5C8A),
    ],
    [
      '3',
      'Petualang',
      Icons.looks_3_rounded,
      Color(0xFF8A6FE8),
    ],
    [
      '4',
      'Cerdas',
      Icons.looks_4_rounded,
      Color(0xFF4F8FF7),
    ],
    [
      '5',
      'Jagoan',
      Icons.looks_5_rounded,
      Color(0xFF45C878),
    ],
    [
      '6',
      'Bintang Sekolah',
      Icons.looks_6_rounded,
      Color(0xFFFFB93F),
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide =
            constraints.maxWidth >= 900;

        return SchoolBackground(
          child: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints:
                    const BoxConstraints(
                  maxWidth: 1180,
                ),
                child: Scrollbar(
                  thumbVisibility: wide,
                  thickness: 8,
                  radius:
                      const Radius.circular(20),
                  child: ListView(
                    padding:
                        EdgeInsets.fromLTRB(
                      wide ? 32 : 18,
                      24,
                      wide ? 32 : 18,
                      100,
                    ),
                    children: [
                      _Hero(
                        wide: wide,
                      ),

                      const SizedBox(
                        height: 25,
                      ),

                      const _Title(),

                      const SizedBox(
                        height: 14,
                      ),

                      GridView.builder(
                        shrinkWrap: true,
                        physics:
                            const NeverScrollableScrollPhysics(),
                        itemCount: 6,
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              wide ? 3 : 1,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          childAspectRatio:
                              wide ? 2.8 : 4.8,
                        ),
                        itemBuilder:
                            (context, i) {
                          final grade =
                              grades[i];

                          return PressableCard(
                            onTap: () {
                              onGrade(
                                int.parse(
                                  grade[0]
                                      as String,
                                ),
                              );
                            },
                            child: _Grade(
                              number:
                                  grade[0]
                                      as String,
                              name:
                                  grade[1]
                                      as String,
                              icon:
                                  grade[2]
                                      as IconData,
                              color:
                                  grade[3]
                                      as Color,
                            ),
                          );
                        },
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: _Quick(
                              icon: Icons
                                  .menu_book_rounded,
                              color:
                                  const Color(
                                0xFF4F8FF7,
                              ),
                              title:
                                  'Materi Belajar',
                              sub:
                                  'Pembahasan soal',
                              tap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const LearningMaterialPage(),
                                  ),
                                );
                              },
                            ),
                          ),

                          const SizedBox(
                            width: 14,
                          ),

                          Expanded(
                            child: _Quick(
                              icon: Icons
                                  .emoji_events_rounded,
                              color:
                                  const Color(
                                0xFFFFB93F,
                              ),
                              title: 'Peringkat',
                              sub:
                                  'Lihat hasil belajar',
                              tap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const RankingPage(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({
    required this.wide,
  });

  final bool wide;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      padding:
          const EdgeInsets.fromLTRB(
        25,
        22,
        10,
        16,
      ),
      decoration: BoxDecoration(
        gradient:
            const LinearGradient(
          colors: [
            Color(0xFFFFD96A),
            Color(0xFFFFA55D),
          ],
        ),
        borderRadius:
            BorderRadius.circular(30),
        border: Border.all(
          color: Colors.white,
          width: 3,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x228B6A36),
            blurRadius: 25,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration:
                      BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(
                      30,
                    ),
                  ),
                  child: const Text(
                    '🌟 BELAJAR JADI SERU!',
                    style: TextStyle(
                      color:
                          Color(0xFF8B5D1D),
                      fontWeight:
                          FontWeight.w900,
                      fontSize: 12,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 13,
                ),

                const Text(
                  'Halo, Bintang Kecil! 👋',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight:
                        FontWeight.w900,
                    color:
                        Color(0xFF3E3B36),
                  ),
                ),

                const SizedBox(
                  height: 7,
                ),

                const Text(
                  'Pilih kelas dan jawab soal '
                  'seperti sedang bermain '
                  'bersama teman.',
                  style: TextStyle(
                    color:
                        Color(0xFF625B50),
                    fontWeight:
                        FontWeight.w600,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            width: wide ? 280 : 145,
            child: const FloatingAsset(
              asset:
                  'assets/Gambar anak anak sd.jpeg',
              width: 270,
              height: 185,
            ),
          ),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        _IconBox(
          icon: Icons.school_rounded,
        ),
        SizedBox(
          width: 12,
        ),
        Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              'Pilih kelasmu',
              style: TextStyle(
                fontSize: 21,
                fontWeight:
                    FontWeight.w900,
                color:
                    Color(0xFF243B5A),
              ),
            ),
            Text(
              'Ayo mulai petualangan belajar!',
              style: TextStyle(
                fontSize: 12,
                color:
                    Color(0xFF71869A),
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _IconBox extends StatelessWidget {
  const _IconBox({
    required this.icon,
  });

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color:
            const Color(0xFFFFC94A),
        borderRadius:
            BorderRadius.circular(16),
      ),
      child: Icon(
        icon,
        color: Colors.white,
      ),
    );
  }
}

class _Grade extends StatelessWidget {
  const _Grade({
    required this.number,
    required this.name,
    required this.icon,
    required this.color,
  });

  final String number;
  final String name;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 17,
      ),
      decoration: BoxDecoration(
        color:
            Colors.white.withOpacity(.95),
        borderRadius:
            BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color:
                color.withOpacity(.13),
            blurRadius: 18,
            offset:
                const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration:
                BoxDecoration(
              color:
                  color.withOpacity(.13),
              borderRadius:
                  BorderRadius.circular(
                18,
              ),
            ),
            child: Icon(
              icon,
              color: color,
              size: 30,
            ),
          ),

          const SizedBox(
            width: 14,
          ),

          Expanded(
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Kelas $number',
                  style:
                      const TextStyle(
                    fontSize: 17,
                    fontWeight:
                        FontWeight.w900,
                    color:
                        Color(0xFF243B5A),
                  ),
                ),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight:
                        FontWeight.w800,
                    color: color,
                  ),
                ),
              ],
            ),
          ),

          Container(
            width: 34,
            height: 34,
            decoration:
                BoxDecoration(
              color: color,
              shape:
                  BoxShape.circle,
            ),
            child: const Icon(
              Icons
                  .play_arrow_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class _Quick extends StatelessWidget {
  const _Quick({
    required this.icon,
    required this.color,
    required this.title,
    required this.sub,
    required this.tap,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String sub;
  final VoidCallback tap;

  @override
  Widget build(BuildContext context) {
    return PressableCard(
      onTap: tap,
      child: Container(
        padding:
            const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color:
              Colors.white.withOpacity(.95),
          borderRadius:
              BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color:
                  Colors.black.withOpacity(.06),
              blurRadius: 15,
              offset:
                  const Offset(0, 7),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration:
                  BoxDecoration(
                color:
                    color.withOpacity(.12),
                borderRadius:
                    BorderRadius.circular(
                  16,
                ),
              ),
              child: Icon(
                icon,
                color: color,
              ),
            ),

            const SizedBox(
              width: 11,
            ),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style:
                        const TextStyle(
                      fontWeight:
                          FontWeight.w900,
                      color:
                          Color(0xFF263E5D),
                    ),
                  ),
                  Text(
                    sub,
                    style:
                        const TextStyle(
                      fontSize: 11,
                      color:
                          Color(0xFF71869A),
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              Icons
                  .arrow_forward_ios_rounded,
              color: color,
              size: 15,
            ),
          ],
        ),
      ),
    );
  }
}