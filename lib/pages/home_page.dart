import 'package:flutter/material.dart';

import 'grade_menu_page.dart';
import 'material_page.dart';
import 'ranking_page.dart';
import 'school_ui.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _openGradeMenu(int grade) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => GradeMenuPage(grade: grade),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SchoolBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 850;

              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 1150,
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: wide ? 40 : 18,
                      vertical: 20,
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        _buildTopBar(context),

                        const SizedBox(height: 20),

                        _buildHero(wide),

                        const SizedBox(height: 30),

                        const SectionTitle(
                          title: 'Pilih Kelasmu',
                          subtitle:
                              'Ayo mulai petualangan belajar!',
                          icon: Icons.backpack_rounded,
                        ),

                        const SizedBox(height: 16),

                        _buildGrades(wide),

                        const SizedBox(height: 30),

                        _buildQuickMenu(context, wide),

                        const SizedBox(height: 90),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(17),
            boxShadow: [
              BoxShadow(
                color: Colors.blueGrey.withOpacity(.08),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            Icons.school_rounded,
            color: SchoolColors.blue,
            size: 30,
          ),
        ),

        const SizedBox(width: 12),

        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'BELAJAR CERIA',
                style: TextStyle(
                  color: SchoolColors.darkBlue,
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                  letterSpacing: .5,
                ),
              ),
              Text(
                'Petualangan belajar anak SD',
                style: TextStyle(
                  color: Color(0xFF718399),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.blueGrey.withOpacity(.08),
                blurRadius: 15,
              ),
            ],
          ),
          child: const Icon(
            Icons.notifications_none_rounded,
            color: SchoolColors.darkBlue,
          ),
        ),
      ],
    );
  }

  Widget _buildHero(bool wide) {
    final content = Row(
      children: [
        Expanded(
          flex: 6,
          child: Padding(
            padding: EdgeInsets.only(
              left: wide ? 28 : 20,
              top: 25,
              bottom: 25,
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 13,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: SchoolColors.yellow,
                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '🎒 WAKTUNYA BELAJAR!',
                    style: TextStyle(
                      color: SchoolColors.darkBlue,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                const Text(
                  'Halo, Sobat\nBelajar! 👋',
                  style: TextStyle(
                    fontSize: 35,
                    height: 1.05,
                    color: SchoolColors.darkBlue,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  'Belajar jadi lebih seru bersama teman-teman di sekolah.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Color(0xFF63758B),
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 11,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.85),
                    borderRadius:
                        BorderRadius.circular(16),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star_rounded,
                        color: SchoolColors.yellow,
                      ),
                      SizedBox(width: 7),
                      Text(
                        'Kumpulkan bintangmu!',
                        style: TextStyle(
                          color: SchoolColors.darkBlue,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        Expanded(
          flex: 4,
          child: Center(
            child: AnimatedAssetCharacter(
              asset:
                  'assets/Gambar anak sd lagi.png',
              width: wide ? 280 : 190,
              height: wide ? 280 : 190,
            ),
          ),
        ),
      ],
    );

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFBDEBFF),
            Color(0xFFDDF7FF),
          ],
        ),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: Colors.white,
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6EA9D9)
                .withOpacity(.15),
            blurRadius: 25,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: wide
          ? content
          : Column(
              children: [
                content.children[0],
                content.children[1],
              ],
            ),
    );
  }

  Widget _buildGrades(bool wide) {
    final grades = [
      (
        1,
        'Pemula Hebat',
        SchoolColors.orange,
        Icons.looks_one_rounded,
      ),
      (
        2,
        'Penjelajah',
        SchoolColors.pink,
        Icons.looks_two_rounded,
      ),
      (
        3,
        'Petualang',
        SchoolColors.purple,
        Icons.looks_3_rounded,
      ),
      (
        4,
        'Cerdas',
        SchoolColors.blue,
        Icons.looks_4_rounded,
      ),
      (
        5,
        'Jagoan',
        SchoolColors.green,
        Icons.looks_5_rounded,
      ),
      (
        6,
        'Bintang Sekolah',
        SchoolColors.yellow,
        Icons.looks_6_rounded,
      ),
    ];

    if (wide) {
      return GridView.builder(
        shrinkWrap: true,
        physics:
            const NeverScrollableScrollPhysics(),
        itemCount: grades.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          childAspectRatio: 2.25,
        ),
        itemBuilder: (_, index) {
          final item = grades[index];

          return _GradeCard(
            grade: item.$1,
            title: item.$2,
            color: item.$3,
            icon: item.$4,
            onTap: () =>
                _openGradeMenu(item.$1),
          );
        },
      );
    }

    return Column(
      children: grades.map((item) {
        return Padding(
          padding:
              const EdgeInsets.only(bottom: 12),
          child: _GradeCard(
            grade: item.$1,
            title: item.$2,
            color: item.$3,
            icon: item.$4,
            onTap: () =>
                _openGradeMenu(item.$1),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildQuickMenu(
    BuildContext context,
    bool wide,
  ) {
    final items = [
      (
        'Materi Belajar',
        'Buka buku dan pelajari materi',
        Icons.menu_book_rounded,
        SchoolColors.blue,
        () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const LearningMaterialPage(),
            ),
          );
        },
      ),
      (
        'Peringkat',
        'Lihat siapa yang paling jago',
        Icons.emoji_events_rounded,
        SchoolColors.yellow,
        () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const RankingPage(),
            ),
          );
        },
      ),
    ];

    return Flex(
      direction: wide
          ? Axis.horizontal
          : Axis.vertical,
      children: items.map((item) {
        final card = PressableCard(
          onTap: item.$5,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color:
                      Colors.blueGrey.withOpacity(.08),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    color: item.$4.withOpacity(.16),
                    borderRadius:
                        BorderRadius.circular(17),
                  ),
                  child: Icon(
                    item.$3,
                    color: item.$4,
                    size: 29,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.$1,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color:
                              SchoolColors.darkBlue,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.$2,
                        style: const TextStyle(
                          fontSize: 11,
                          color:
                              Color(0xFF718399),
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Color(0xFF9AA9BA),
                ),
              ],
            ),
          ),
        );

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: wide ? 8 : 0,
              bottom: wide ? 0 : 12,
            ),
            child: card,
          ),
        );
      }).toList(),
    );
  }
}

class _GradeCard extends StatelessWidget {
  const _GradeCard({
    required this.grade,
    required this.title,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  final int grade;
  final String title;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PressableCard(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(23),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(.10),
              blurRadius: 18,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: color.withOpacity(.15),
                borderRadius:
                    BorderRadius.circular(17),
              ),
              child: Icon(
                icon,
                color: color,
                size: 30,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Text(
                    'Kelas $grade',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      color:
                          SchoolColors.darkBlue,
                    ),
                  ),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 11,
                      color: color,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.play_circle_fill_rounded,
              color: color,
              size: 30,
            ),
          ],
        ),
      ),
    );
  }
}
