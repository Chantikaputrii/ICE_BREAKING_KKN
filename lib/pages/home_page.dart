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
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: Colors.white.withValues(alpha: .98),
          elevation: 12,
          shadowColor: const Color(0x22000000),
          indicatorColor: const Color(0xFFFFE49A),
          height: 76,
          labelTextStyle:
              WidgetStateProperty.resolveWith<TextStyle?>(
            (states) {
              if (states.contains(WidgetState.selected)) {
                return const TextStyle(
                  color: Color(0xFF356AE6),
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                );
              }

              return const TextStyle(
                color: Color(0xFF71839A),
                fontWeight: FontWeight.w700,
                fontSize: 12,
              );
            },
          ),
          iconTheme:
              WidgetStateProperty.resolveWith<IconThemeData?>(
            (states) {
              if (states.contains(WidgetState.selected)) {
                return const IconThemeData(
                  color: Color(0xFF356AE6),
                  size: 27,
                );
              }

              return const IconThemeData(
                color: Color(0xFF71839A),
                size: 24,
              );
            },
          ),
        ),
        child: NavigationBar(
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
      ),
    );
  }
}

// ============================================================
// HOME CONTENT
// ============================================================

class _HomeContent extends StatefulWidget {
  const _HomeContent({
    required this.onGradeSelected,
  });

  final ValueChanged<int> onGradeSelected;

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent>
    with SingleTickerProviderStateMixin {
  late final AnimationController _sunController;

  @override
  void initState() {
    super.initState();

    _sunController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat();
  }

  @override
  void dispose() {
    _sunController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SchoolBackground(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: _SkyAndGardenDecoration(
              sunAnimation: _sunController,
            ),
          ),
          SafeArea(
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
                            const _Header(),

                            const SizedBox(height: 24),

                            const _WelcomeCard(),

                            const SizedBox(height: 28),

                            const Text(
                              'Pilih Kelasmu 🎒',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 29,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF283B63),
                                letterSpacing: -.4,
                              ),
                            ),

                            const SizedBox(height: 8),

                            const Text(
                              'Yuk pilih kelas dan mulai petualangan belajarmu!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF71839A),
                                height: 1.4,
                              ),
                            ),

                            const SizedBox(height: 22),

                            LayoutBuilder(
                              builder:
                                  (context, gridConstraints) {
                                int columns;

                                if (gridConstraints.maxWidth >=
                                    1000) {
                                  columns = 3;
                                } else if (gridConstraints
                                        .maxWidth >=
                                    650) {
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
                                    crossAxisSpacing: 18,
                                    mainAxisSpacing: 18,
                                    childAspectRatio:
                                        columns == 1
                                            ? 3.0
                                            : 1.55,
                                  ),
                                  itemBuilder:
                                      (context, index) {
                                    final grade = index + 1;

                                    return _GradeCard(
                                      grade: grade,
                                      onTap: () {
                                        widget.onGradeSelected(
                                          grade,
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            ),

                            const SizedBox(height: 28),

                            const _FeatureSection(),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// LANGIT + AWAN + BURUNG + MATAHARI + LAHAN HIJAU
// ============================================================

class _SkyAndGardenDecoration extends StatefulWidget {
  const _SkyAndGardenDecoration({
    required this.sunAnimation,
  });

  final Animation<double> sunAnimation;

  @override
  State<_SkyAndGardenDecoration> createState() =>
      _SkyAndGardenDecorationState();
}

class _SkyAndGardenDecorationState
    extends State<_SkyAndGardenDecoration>
    with TickerProviderStateMixin {
  late final AnimationController _cloudController;
  late final AnimationController _birdController;

  @override
  void initState() {
    super.initState();

    _cloudController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 25),
    )..repeat();

    _birdController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat();
  }

  @override
  void dispose() {
    _cloudController.dispose();
    _birdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    final width = size.width;
    final height = size.height;

    return IgnorePointer(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // ==================================================
          // LANGIT
          // ==================================================

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: height * .60,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF4FC7F5),
                    Color(0xFF7DDBFA),
                    Color(0xFFD7F2FF),
                  ],
                ),
              ),
            ),
          ),

          // ==================================================
          // AWAN 1
          // ==================================================

          AnimatedBuilder(
            animation: _cloudController,
            builder: (context, child) {
              final x =
                  -190 +
                  (width + 380) *
                      _cloudController.value;

              return Positioned(
                top: 70,
                left: x,
                child: child!,
              );
            },
            child: const _CloudDecoration(
              scale: 1.15,
            ),
          ),

          // ==================================================
          // AWAN 2
          // ==================================================

          AnimatedBuilder(
            animation: _cloudController,
            builder: (context, child) {
              final x =
                  width -
                  (width + 340) *
                      _cloudController.value;

              return Positioned(
                top: 145,
                left: x,
                child: child!,
              );
            },
            child: const _CloudDecoration(
              scale: .80,
            ),
          ),

          // ==================================================
          // AWAN 3
          // ==================================================

          AnimatedBuilder(
            animation: _cloudController,
            builder: (context, child) {
              final x =
                  -250 +
                  (width + 500) *
                      ((_cloudController.value + .45) % 1.0);

              return Positioned(
                top: 220,
                left: x,
                child: child!,
              );
            },
            child: const _CloudDecoration(
              scale: .62,
            ),
          ),

          // ==================================================
          // BURUNG 1
          // ==================================================

          AnimatedBuilder(
            animation: _birdController,
            builder: (context, child) {
              final x =
                  -80 +
                  (width + 160) *
                      _birdController.value;

              final y =
                  120 +
                  (20 *
                      ((_birdController.value * 2) % 1.0));

              return Positioned(
                left: x,
                top: y,
                child: child!,
              );
            },
            child: const _BirdDecoration(
              scale: 1.0,
            ),
          ),

          // ==================================================
          // BURUNG 2
          // ==================================================

          AnimatedBuilder(
            animation: _birdController,
            builder: (context, child) {
              final x =
                  width -
                  (width + 120) *
                      ((_birdController.value + .35) % 1.0);

              final y =
                  180 +
                  (16 *
                      ((_birdController.value * 1.5) % 1.0));

              return Positioned(
                left: x,
                top: y,
                child: child!,
              );
            },
            child: const _BirdDecoration(
              scale: .65,
            ),
          ),

          // ==================================================
          // MATAHARI
          // ==================================================

          Positioned(
            top: 18,
            right: width < 600 ? 20 : 55,
            child: RotationTransition(
              turns: widget.sunAnimation,
              child: SizedBox(
                width: width < 600 ? 85 : 110,
                height: width < 600 ? 85 : 110,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ...List.generate(
                      8,
                      (index) {
                        final angle =
                            index * 3.14159265359 / 4;

                        return Transform.rotate(
                          angle: angle,
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              width: 7,
                              height: width < 600 ? 19 : 25,
                              decoration: BoxDecoration(
                                color:
                                    const Color(0xFFFFC83D),
                                borderRadius:
                                    BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    Container(
                      width: width < 600 ? 62 : 80,
                      height: width < 600 ? 62 : 80,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFFFE66D),
                            Color(0xFFFFB82E),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x44FFB82E),
                            blurRadius: 20,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ==================================================
          // TAMAN / RUMPUT
          // ==================================================

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: height * .23,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF9BE27D),
                    Color(0xFF62C95D),
                    Color(0xFF42AA50),
                  ],
                ),
              ),
            ),
          ),

          // ==================================================
          // BUNGA
          // ==================================================

          Positioned(
            left: width * .08,
            bottom: height * .08,
            child: const _FlowerDecoration(
              scale: .9,
            ),
          ),

          Positioned(
            right: width * .12,
            bottom: height * .06,
            child: const _FlowerDecoration(
              scale: .7,
            ),
          ),

          Positioned(
            left: width * .42,
            bottom: height * .03,
            child: const _FlowerDecoration(
              scale: .55,
            ),
          ),

          // ==================================================
          // POHON KECIL
          // ==================================================

          Positioned(
            left: width < 600 ? 8 : 35,
            bottom: height * .13,
            child: _TreeDecoration(
              scale: width < 600 ? .65 : .9,
            ),
          ),

          Positioned(
            right: width < 600 ? 5 : 30,
            bottom: height * .12,
            child: _TreeDecoration(
              scale: width < 600 ? .60 : .85,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// CLOUD
// ============================================================

class _CloudDecoration extends StatelessWidget {
  const _CloudDecoration({
    required this.scale,
  });

  final double scale;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      alignment: Alignment.center,
      child: SizedBox(
        width: 170,
        height: 75,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Positioned(
              bottom: 5,
              left: 10,
              right: 0,
              child: Container(
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .88),
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
            ),
            Positioned(
              bottom: 17,
              left: 25,
              child: Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .92),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 70,
              child: Container(
                width: 65,
                height: 65,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .94),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: 17,
              right: 20,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .90),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// BIRD
// ============================================================

class _BirdDecoration extends StatelessWidget {
  const _BirdDecoration({
    required this.scale,
  });

  final double scale;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: SizedBox(
        width: 45,
        height: 25,
        child: CustomPaint(
          painter: _BirdPainter(),
        ),
      ),
    );
  }
}

class _BirdPainter extends CustomPainter {
  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final paint = Paint()
      ..color = const Color(0xFF45627D)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final path = Path();

    path.moveTo(2, 12);
    path.quadraticBezierTo(
      10,
      4,
      20,
      12,
    );

    path.moveTo(20, 12);
    path.quadraticBezierTo(
      30,
      4,
      40,
      12,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(
    covariant CustomPainter oldDelegate,
  ) {
    return false;
  }
}

// ============================================================
// FLOWER
// ============================================================

class _FlowerDecoration extends StatelessWidget {
  const _FlowerDecoration({
    required this.scale,
  });

  final double scale;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        width: 55,
        height: 90,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Positioned(
              bottom: 0,
              child: Container(
                width: 4,
                height: 58,
                decoration: BoxDecoration(
                  color: const Color(0xFF379B4C),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            Positioned(
              bottom: 26,
              left: 9,
              child: Transform.rotate(
                angle: -.5,
                child: Container(
                  width: 24,
                  height: 11,
                  decoration: const BoxDecoration(
                    color: Color(0xFF58B957),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 45,
              right: 7,
              child: Transform.rotate(
                angle: .5,
                child: Container(
                  width: 24,
                  height: 11,
                  decoration: const BoxDecoration(
                    color: Color(0xFF58B957),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              child: SizedBox(
                width: 42,
                height: 42,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    _petal(
                      Alignment.topCenter,
                      const Color(0xFFFF7190),
                    ),
                    _petal(
                      Alignment.bottomCenter,
                      const Color(0xFFFF7190),
                    ),
                    _petal(
                      Alignment.centerLeft,
                      const Color(0xFFFF8DA6),
                    ),
                    _petal(
                      Alignment.centerRight,
                      const Color(0xFFFF8DA6),
                    ),
                    Container(
                      width: 13,
                      height: 13,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFD34E),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _petal(
    Alignment alignment,
    Color color,
  ) {
    return Align(
      alignment: alignment,
      child: Container(
        width: 19,
        height: 19,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

// ============================================================
// TREE
// ============================================================

class _TreeDecoration extends StatelessWidget {
  const _TreeDecoration({
    required this.scale,
  });

  final double scale;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        width: 100,
        height: 150,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              width: 17,
              height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFF8B5A38),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            Positioned(
              top: 4,
              child: Container(
                width: 78,
                height: 78,
                decoration: const BoxDecoration(
                  color: Color(0xFF58BD5A),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              top: 26,
              left: 0,
              child: Container(
                width: 58,
                height: 58,
                decoration: const BoxDecoration(
                  color: Color(0xFF4DAD52),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              top: 27,
              right: 0,
              child: Container(
                width: 58,
                height: 58,
                decoration: const BoxDecoration(
                  color: Color(0xFF69C961),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// HEADER
// ============================================================

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 62,
          height: 62,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Color(0x18000000),
                blurRadius: 18,
                offset: Offset(0, 7),
              ),
            ],
          ),
          child: const Icon(
            Icons.school_rounded,
            size: 34,
            color: Color(0xFF3F6FE8),
          ),
        ),

        const SizedBox(width: 14),

        const Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                'BELAJAR CERIA',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF283B63),
                  letterSpacing: .2,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Media pembelajaran anak SD',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF71839A),
                ),
              ),
            ],
          ),
        ),

        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .92),
            shape: BoxShape.circle,
            boxShadow: const [
              BoxShadow(
                color: Color(0x12000000),
                blurRadius: 12,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: const Icon(
            Icons.notifications_none_rounded,
            color: Color(0xFF3F6FE8),
            size: 23,
          ),
        ),
      ],
    );
  }
}

// ============================================================
// WELCOME CARD
// ============================================================

class _WelcomeCard extends StatelessWidget {
  const _WelcomeCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Color(0xFFF7FBFF),
          ],
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 25,
            offset: Offset(0, 11),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact =
              constraints.maxWidth < 650;

          final content = Column(
            crossAxisAlignment: compact
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFFFE99A),
                      Color(0xFFFFD66B),
                    ],
                  ),
                  borderRadius:
                      BorderRadius.circular(30),
                ),
                child: const Text(
                  '✨ SELAMAT DATANG',
                  style: TextStyle(
                    color: Color(0xFF795600),
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              Text(
                'Halo, Teman Belajar! 👋',
                textAlign: compact
                    ? TextAlign.center
                    : TextAlign.left,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF283B63),
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Siap belajar, bermain, dan mendapatkan nilai terbaik?',
                textAlign: compact
                    ? TextAlign.center
                    : TextAlign.left,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF71839A),
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
              Expanded(
                child: content,
              ),

              const SizedBox(width: 30),

              Container(
                width: 150,
                height: 120,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFE2F4FF),
                      Color(0xFFD7EAFF),
                    ],
                  ),
                  borderRadius:
                      BorderRadius.circular(28),
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                child: const Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 12,
                      right: 16,
                      child: Text(
                        '⭐',
                        style: TextStyle(
                          fontSize: 22,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 13,
                      left: 18,
                      child: Text(
                        '✨',
                        style: TextStyle(
                          fontSize: 19,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.auto_stories_rounded,
                      size: 65,
                      color: Color(0xFF3F6FE8),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ============================================================
// GRADE CARD
// ============================================================

class _GradeCard extends StatelessWidget {
  const _GradeCard({
    required this.grade,
    required this.onTap,
  });

  final int grade;
  final VoidCallback onTap;

  Color get cardColor {
    const colors = [
      Color(0xFF3F6FE8),
      Color(0xFF55C98A),
      Color(0xFFFFB84D),
      Color(0xFF9A7BE3),
      Color(0xFFFF718F),
      Color(0xFF36B8C9),
    ];

    return colors[(grade - 1) % colors.length];
  }

  IconData get gradeIcon {
    const icons = [
      Icons.palette_rounded,
      Icons.calculate_rounded,
      Icons.science_rounded,
      Icons.menu_book_rounded,
      Icons.lightbulb_rounded,
      Icons.rocket_launch_rounded,
    ];

    return icons[(grade - 1) % icons.length];
  }

  String get subtitle {
    const subtitles = [
      'Belajar dasar dengan seru',
      'Yuk makin jago berhitung',
      'Temukan hal-hal baru',
      'Asah kemampuanmu',
      'Tantang dirimu sendiri',
      'Siap jadi bintang belajar',
    ];

    return subtitles[(grade - 1) % subtitles.length];
  }

  @override
  Widget build(BuildContext context) {
    return PressableCard(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .97),
          borderRadius: BorderRadius.circular(26),
          border: Border.all(
            color: cardColor.withValues(alpha: .20),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: cardColor.withValues(alpha: .13),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
            const BoxShadow(
              color: Color(0x10000000),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    cardColor.withValues(alpha: .18),
                    cardColor.withValues(alpha: .08),
                  ],
                ),
                borderRadius:
                    BorderRadius.circular(20),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    gradeIcon,
                    size: 28,
                    color: cardColor,
                  ),
                  Positioned(
                    right: 5,
                    top: 4,
                    child: Container(
                      width: 19,
                      height: 19,
                      decoration: BoxDecoration(
                        color: cardColor,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '$grade',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight:
                                FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
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
                      color: Color(0xFF314566),
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF71839A),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: cardColor.withValues(alpha: .11),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_forward_rounded,
                size: 20,
                color: cardColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// FEATURE SECTION
// ============================================================

class _FeatureSection extends StatelessWidget {
  const _FeatureSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFFFFF),
            Color(0xFFF7FCFF),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x15000000),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Belajar Jadi Lebih Seru! 🎉',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w900,
              color: Color(0xFF283B63),
            ),
          ),

          const SizedBox(height: 7),

          const Text(
            'Belajar, bermain, dan raih prestasi bersama!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF71839A),
            ),
          ),

          const SizedBox(height: 20),

          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 520) {
                return const Column(
                  children: [
                    _FeatureItem(
                      icon: Icons.menu_book_rounded,
                      title: 'Belajar',
                      color: Color(0xFF3F6FE8),
                    ),
                    SizedBox(height: 14),
                    _FeatureItem(
                      icon: Icons.sports_esports_rounded,
                      title: 'Bermain',
                      color: Color(0xFF55C98A),
                    ),
                    SizedBox(height: 14),
                    _FeatureItem(
                      icon: Icons.emoji_events_rounded,
                      title: 'Berprestasi',
                      color: Color(0xFFFFB84D),
                    ),
                  ],
                );
              }

              return const Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceEvenly,
                children: [
                  _FeatureItem(
                    icon: Icons.menu_book_rounded,
                    title: 'Belajar',
                    color: Color(0xFF3F6FE8),
                  ),
                  _FeatureItem(
                    icon: Icons.sports_esports_rounded,
                    title: 'Bermain',
                    color: Color(0xFF55C98A),
                  ),
                  _FeatureItem(
                    icon: Icons.emoji_events_rounded,
                    title: 'Berprestasi',
                    color: Color(0xFFFFB84D),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

// ============================================================
// FEATURE ITEM
// ============================================================

class _FeatureItem extends StatelessWidget {
  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.color,
  });

  final IconData icon;
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withValues(alpha: .18),
                color.withValues(alpha: .08),
              ],
            ),
            borderRadius:
                BorderRadius.circular(17),
          ),
          child: Icon(
            icon,
            color: color,
            size: 26,
          ),
        ),

        const SizedBox(width: 10),

        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: Color(0xFF526B84),
          ),
        ),
      ],
    );
  }
}