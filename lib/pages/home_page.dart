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
  int index = 0;

  void openGrade(int grade) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GradeMenuPage(
          grade: grade,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      _HomeContent(
        onGradeSelected: openGrade,
      ),
      const LearningMaterialPage(),
      const RankingPage(),
    ];

    return Scaffold(
      body: pages[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (value) {
          setState(() {
            index = value;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book_rounded),
            label: 'Materi',
          ),
          NavigationDestination(
            icon: Icon(Icons.emoji_events_outlined),
            selectedIcon: Icon(Icons.emoji_events_rounded),
            label: 'Peringkat',
          ),
        ],
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({
    required this.onGradeSelected,
  });

  final ValueChanged<int> onGradeSelected;

  @override
  Widget build(BuildContext context) {
    return SchoolBackground(
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;

            return Scrollbar(
              thumbVisibility: width >= 900,
              trackVisibility: width >= 900,
              interactive: true,
              thickness: 8,
              radius: const Radius.circular(20),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  24,
                  20,
                  40,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 1180,
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.stretch,
                      children: [
                        _Header(),

                        const SizedBox(height: 24),

                        _WelcomeCard(),

                        const SizedBox(height: 24),

                        const Text(
                          'Pilih Kelasmu',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF243B5A),
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          'Yuk pilih kelas dan mulai petualangan belajarmu!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF71869A),
                          ),
                        ),

                        const SizedBox(height: 20),

                        LayoutBuilder(
                          builder: (context, gridConstraints) {
                            int columns;

                            if (gridConstraints.maxWidth >= 1000) {
                              columns = 3;
                            } else if (gridConstraints.maxWidth >= 650) {
                              columns = 2;
                            } else {
                              columns = 1;
                            }

                            return GridView.builder(
                              shrinkWrap: true,
                              physics:
                                  const NeverScrollableScrollPhysics(),
                              itemCount: 6,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: columns,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio:
                                    columns == 1 ? 3.0 : 1.55,
                              ),
                              itemBuilder: (context, index) {
                                final grade = index + 1;

                                return _GradeCard(
                                  grade: grade,
                                  onTap: () {
                                    onGradeSelected(grade);
                                  },
                                );
                              },
                            );
                          },
                        ),

                        const SizedBox(height: 26),

                        _FeatureSection(),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(
                color: Color(0x18000000),
                blurRadius: 15,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(
            Icons.school_rounded,
            size: 32,
            color: Color(0xFF4F8FF7),
          ),
        ),
        const SizedBox(width: 14),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'BELAJAR CERIA',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF243B5A),
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Media pembelajaran anak SD',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF71869A),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WelcomeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .94),
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Color(0x16000000),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 650;

          final content = Column(
            crossAxisAlignment: compact
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF3FF),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text(
                  '✨ SELAMAT DATANG',
                  style: TextStyle(
                    color: Color(0xFF4F8FF7),
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Halo, Teman Belajar! 👋',
                textAlign:
                    compact ? TextAlign.center : TextAlign.left,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF243B5A),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Siap belajar, bermain, dan mendapatkan nilai terbaik?',
                textAlign:
                    compact ? TextAlign.center : TextAlign.left,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF71869A),
                  height: 1.5,
                ),
              ),
            ],
          );

          if (compact) {
            return content;
          }

          return Row(
            children: [
              Expanded(child: content),
              const SizedBox(width: 30),
              Container(
                width: 150,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF5FF),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: const Icon(
                  Icons.auto_stories_rounded,
                  size: 65,
                  color: Color(0xFF4F8FF7),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _GradeCard extends StatelessWidget {
  const _GradeCard({
    required this.grade,
    required this.onTap,
  });

  final int grade;
  final VoidCallback onTap;

  Color get cardColor {
    const colors = [
      Color(0xFF4F8FF7),
      Color(0xFF43C77A),
      Color(0xFFFFB93F),
      Color(0xFF9A6BFF),
      Color(0xFFFF6B81),
      Color(0xFF24B8C8),
    ];

    return colors[(grade - 1) % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return PressableCard(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .96),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: cardColor.withValues(alpha: .18),
            width: 2,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x12000000),
              blurRadius: 15,
              offset: Offset(0, 7),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: cardColor.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Center(
                child: Text(
                  '$grade',
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.w900,
                    color: cardColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Text(
                    'Kelas $grade SD',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF263E5D),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    grade >= 5
                        ? 'Termasuk pilihan tema khusus'
                        : 'Belajar sambil bermain',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF71869A),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
              color: cardColor,
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .90),
        borderRadius: BorderRadius.circular(26),
      ),
      child: const Column(
        children: [
          Text(
            'Belajar Jadi Lebih Seru!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w900,
              color: Color(0xFF243B5A),
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceEvenly,
            children: [
              _FeatureItem(
                icon: Icons.menu_book_rounded,
                title: 'Belajar',
              ),
              _FeatureItem(
                icon: Icons.sports_esports_rounded,
                title: 'Bermain',
              ),
              _FeatureItem(
                icon: Icons.emoji_events_rounded,
                title: 'Berprestasi',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  const _FeatureItem({
    required this.icon,
    required this.title,
  });

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFEAF3FF),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF4F8FF7),
          ),
        ),
        const SizedBox(height: 7),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: Color(0xFF526B84),
          ),
        ),
      ],
    );
  }
}