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
          indicatorColor: const Color(0xFFD7EAFF),
          labelTextStyle:
              WidgetStateProperty.resolveWith<TextStyle?>(
            (states) {
              if (states.contains(WidgetState.selected)) {
                return const TextStyle(
                  color: Color(0xFF1976F3),
                  fontWeight: FontWeight.w800,
                );
              }

              return const TextStyle(
                color: Color(0xFF4F5F73),
                fontWeight: FontWeight.w600,
              );
            },
          ),
          iconTheme:
              WidgetStateProperty.resolveWith<IconThemeData?>(
            (states) {
              if (states.contains(WidgetState.selected)) {
                return const IconThemeData(
                  color: Color(0xFF1976F3),
                  size: 26,
                );
              }

              return const IconThemeData(
                color: Color(0xFF4F5F73),
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
                                color: Color(0xFF637D96),
                              ),
                            ),

                            const SizedBox(height: 20),

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
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
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

                            const SizedBox(height: 26),

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
          // LANGIT BIRU
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
                    Color(0xFF35BDF6),
                    Color(0xFF6DD5FA),
                    Color(0xFFBDEEFF),
                  ],
                ),
              ),
            ),
          ),

          // ==================================================
          // AWAN BERJALAN 1
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
          // AWAN BERJALAN 2
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
          // AWAN BERJALAN 3
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
          // BURUNG BERJALAN 1
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
          // BURUNG BERJALAN 2
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
          // MATAHARI BERPUTAR
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
                    Container(
                      width: width < 600 ? 62 : 80,
                      height: width < 600 ? 62 : 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFFD54F)
                                .withValues(alpha: .40),
                            blurRadius: 35,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.wb_sunny_rounded,
                      size: width < 600 ? 58 : 76,
                      color: const Color(0xFFFFC928),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ==================================================
          // LAHAN HIJAU BERGELOMBANG
          // ==================================================

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: height * .42,
            child: CustomPaint(
              painter: _RollingGrassPainter(),
            ),
          ),

          // ==================================================
          // POHON KIRI
          // ==================================================

          Positioned(
            left: width < 600 ? 8 : 35,
            bottom: height * .25,
            child: _TreeDecoration(
              scale: width < 600 ? .65 : 1.0,
            ),
          ),

          // ==================================================
          // POHON KANAN
          // ==================================================

          Positioned(
            right: width < 600 ? 8 : 40,
            bottom: height * .23,
            child: _TreeDecoration(
              scale: width < 600 ? .58 : .90,
            ),
          ),

          // ==================================================
          // POHON KECIL
          // ==================================================

          Positioned(
            left: width * .27,
            bottom: height * .19,
            child: const _TreeDecoration(
              scale: .48,
            ),
          ),

          Positioned(
            right: width * .27,
            bottom: height * .17,
            child: const _TreeDecoration(
              scale: .42,
            ),
          ),

          // ==================================================
          // RUMPUT KECIL
          // ==================================================

          Positioned(
            left: width * .08,
            bottom: height * .11,
            child: const _GrassDecoration(
              size: 28,
            ),
          ),

          Positioned(
            left: width * .18,
            bottom: height * .08,
            child: const _GrassDecoration(
              size: 22,
            ),
          ),

          Positioned(
            left: width * .36,
            bottom: height * .12,
            child: const _GrassDecoration(
              size: 25,
            ),
          ),

          Positioned(
            left: width * .52,
            bottom: height * .10,
            child: const _GrassDecoration(
              size: 24,
            ),
          ),

          Positioned(
            right: width * .08,
            bottom: height * .11,
            child: const _GrassDecoration(
              size: 28,
            ),
          ),

          Positioned(
            right: width * .19,
            bottom: height * .07,
            child: const _GrassDecoration(
              size: 22,
            ),
          ),

          Positioned(
            left: width * .70,
            bottom: height * .12,
            child: const _GrassDecoration(
              size: 24,
            ),
          ),

          // ==================================================
          // BUNGA-BUNGA KECIL
          // ==================================================

          Positioned(
            left: 15,
            bottom: height * .06,
            child: const _FlowerDecoration(
              size: 28,
              color: Color(0xFFFF6FAE),
            ),
          ),

          Positioned(
            left: width * .13,
            bottom: height * .04,
            child: const _FlowerDecoration(
              size: 20,
              color: Color(0xFFFFD34E),
            ),
          ),

          Positioned(
            left: width * .25,
            bottom: height * .07,
            child: const _FlowerDecoration(
              size: 22,
              color: Color(0xFFFF8FA3),
            ),
          ),

          Positioned(
            left: width * .42,
            bottom: height * .04,
            child: const _FlowerDecoration(
              size: 18,
              color: Color(0xFFFFD34E),
            ),
          ),

          Positioned(
            left: width * .58,
            bottom: height * .06,
            child: const _FlowerDecoration(
              size: 22,
              color: Color(0xFFFF70A6),
            ),
          ),

          Positioned(
            left: width * .72,
            bottom: height * .04,
            child: const _FlowerDecoration(
              size: 19,
              color: Color(0xFFFFD34E),
            ),
          ),

          Positioned(
            right: width * .22,
            bottom: height * .04,
            child: const _FlowerDecoration(
              size: 19,
              color: Color(0xFFFFD34E),
            ),
          ),

          Positioned(
            right: width * .11,
            bottom: height * .07,
            child: const _FlowerDecoration(
              size: 25,
              color: Color(0xFFFF8BB5),
            ),
          ),

          Positioned(
            right: 12,
            bottom: height * .05,
            child: const _FlowerDecoration(
              size: 30,
              color: Color(0xFFFFD34E),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// AWAN
// ============================================================

class _CloudDecoration extends StatelessWidget {
  const _CloudDecoration({
    this.scale = 1,
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
              bottom: 0,
              left: 15,
              child: Container(
                width: 135,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .92),
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            Positioned(
              left: 38,
              bottom: 22,
              child: Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .95),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              left: 78,
              bottom: 25,
              child: Container(
                width: 65,
                height: 65,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .95),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              right: 18,
              bottom: 18,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .94),
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
// BURUNG
// ============================================================

class _BirdDecoration extends StatelessWidget {
  const _BirdDecoration({
    this.scale = 1,
  });

  final double scale;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: SizedBox(
        width: 70,
        height: 35,
        child: CustomPaint(
          painter: _BirdPainter(),
        ),
      ),
    );
  }
}

class _BirdPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF38516B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final path = Path();

    path.moveTo(5, 18);
    path.quadraticBezierTo(
      18,
      5,
      32,
      18,
    );

    path.moveTo(32, 18);
    path.quadraticBezierTo(
      47,
      5,
      62,
      18,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

// ============================================================
// LAHAN HIJAU BERGELOMBANG
// ============================================================

class _RollingGrassPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final backPaint = Paint()
      ..color = const Color(0xFF4FB84B)
      ..style = PaintingStyle.fill;

    final backPath = Path();

    backPath.moveTo(0, size.height * .38);

    backPath.cubicTo(
      size.width * .18,
      size.height * .22,
      size.width * .30,
      size.height * .45,
      size.width * .48,
      size.height * .34,
    );

    backPath.cubicTo(
      size.width * .64,
      size.height * .22,
      size.width * .78,
      size.height * .43,
      size.width,
      size.height * .30,
    );

    backPath.lineTo(size.width, size.height);
    backPath.lineTo(0, size.height);
    backPath.close();

    canvas.drawPath(backPath, backPaint);

    final paint = Paint()
      ..color = const Color(0xFF65C85A)
      ..style = PaintingStyle.fill;

    final path = Path();

    path.moveTo(0, size.height * .22);

    path.cubicTo(
      size.width * .12,
      size.height * .05,
      size.width * .23,
      size.height * .34,
      size.width * .36,
      size.height * .20,
    );

    path.cubicTo(
      size.width * .50,
      size.height * .05,
      size.width * .60,
      size.height * .35,
      size.width * .73,
      size.height * .18,
    );

    path.cubicTo(
      size.width * .84,
      size.height * .05,
      size.width * .92,
      size.height * .30,
      size.width,
      size.height * .15,
    );

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);

    // Gelombang kecil tambahan
    final frontPaint = Paint()
      ..color = const Color(0xFF78D669)
      ..style = PaintingStyle.fill;

    final frontPath = Path();

    frontPath.moveTo(0, size.height * .58);

    frontPath.cubicTo(
      size.width * .15,
      size.height * .46,
      size.width * .28,
      size.height * .65,
      size.width * .42,
      size.height * .55,
    );

    frontPath.cubicTo(
      size.width * .57,
      size.height * .44,
      size.width * .70,
      size.height * .65,
      size.width * .84,
      size.height * .52,
    );

    frontPath.cubicTo(
      size.width * .92,
      size.height * .46,
      size.width * .97,
      size.height * .55,
      size.width,
      size.height * .51,
    );

    frontPath.lineTo(size.width, size.height);
    frontPath.lineTo(0, size.height);
    frontPath.close();

    canvas.drawPath(frontPath, frontPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

// ============================================================
// POHON
// ============================================================

class _TreeDecoration extends StatelessWidget {
  const _TreeDecoration({
    this.scale = 1,
  });

  final double scale;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        width: 105,
        height: 165,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // Batang
            Positioned(
              bottom: 0,
              child: Container(
                width: 22,
                height: 72,
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5A35),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            // Dahan
            Positioned(
              bottom: 52,
              child: Container(
                width: 70,
                height: 15,
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5A35),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),

            // Daun kiri
            Positioned(
              top: 32,
              left: 0,
              child: Container(
                width: 58,
                height: 58,
                decoration: const BoxDecoration(
                  color: Color(0xFF46B84D),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // Daun tengah
            Positioned(
              top: 5,
              left: 12,
              child: Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: Color(0xFF3EAD4A),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // Daun kanan
            Positioned(
              top: 35,
              right: 5,
              child: Container(
                width: 65,
                height: 65,
                decoration: const BoxDecoration(
                  color: Color(0xFF51BD55),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // Buah
            const Positioned(
              top: 38,
              left: 35,
              child: Icon(
                Icons.circle,
                size: 9,
                color: Color(0xFFFFD34E),
              ),
            ),

            const Positioned(
              top: 55,
              right: 28,
              child: Icon(
                Icons.circle,
                size: 8,
                color: Color(0xFFFF7A7A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// RUMPUT KECIL
// ============================================================

class _GrassDecoration extends StatelessWidget {
  const _GrassDecoration({
    this.size = 25,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size * 1.3,
      child: CustomPaint(
        painter: _GrassPainter(),
      ),
    );
  }
}

class _GrassPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF238F3A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final centerX = size.width / 2;

    final left = Path()
      ..moveTo(centerX, size.height)
      ..quadraticBezierTo(
        centerX - 5,
        size.height * .45,
        centerX - 9,
        size.height * .12,
      );

    final center = Path()
      ..moveTo(centerX, size.height)
      ..quadraticBezierTo(
        centerX,
        size.height * .40,
        centerX + 1,
        size.height * .05,
      );

    final right = Path()
      ..moveTo(centerX, size.height)
      ..quadraticBezierTo(
        centerX + 6,
        size.height * .45,
        centerX + 11,
        size.height * .18,
      );

    canvas.drawPath(left, paint);
    canvas.drawPath(center, paint);
    canvas.drawPath(right, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

// ============================================================
// BUNGA
// ============================================================

class _FlowerDecoration extends StatelessWidget {
  const _FlowerDecoration({
    required this.size,
    required this.color,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size + 16,
      height: size + 22,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            bottom: 0,
            child: Container(
              width: 3,
              height: size * .65,
              decoration: BoxDecoration(
                color: const Color(0xFF3C9B3E),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          Positioned(
            bottom: size * .20,
            left: 0,
            child: Transform.rotate(
              angle: -.55,
              child: Container(
                width: size * .35,
                height: size * .17,
                decoration: BoxDecoration(
                  color: const Color(0xFF54A94D),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),

          Positioned(
            bottom: size * .32,
            right: 0,
            child: Transform.rotate(
              angle: .55,
              child: Container(
                width: size * .35,
                height: size * .17,
                decoration: BoxDecoration(
                  color: const Color(0xFF54A94D),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),

          Positioned(
            top: 0,
            child: Icon(
              Icons.local_florist_rounded,
              size: size,
              color: color,
            ),
          ),
        ],
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
            color: Color(0xFF1976F3),
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
                  color: Color(0xFF243B5A),
                ),
              ),

              SizedBox(height: 2),

              Text(
                'Media pembelajaran anak SD',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF637D96),
                ),
              ),
            ],
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
        color: Colors.white.withValues(alpha: .96),
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
          final compact =
              constraints.maxWidth < 650;

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
                  color: const Color(0xFFD7EAFF),
                  borderRadius:
                      BorderRadius.circular(30),
                ),
                child: const Text(
                  '✨ SELAMAT DATANG',
                  style: TextStyle(
                    color: Color(0xFF1976F3),
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              Text(
                'Halo, Teman Belajar! 👋',
                textAlign: compact
                    ? TextAlign.center
                    : TextAlign.left,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF243B5A),
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
                  color: Color(0xFF637D96),
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
                  color: const Color(0xFFD7EAFF),
                  borderRadius:
                      BorderRadius.circular(28),
                ),
                child: const Icon(
                  Icons.auto_stories_rounded,
                  size: 65,
                  color: Color(0xFF1976F3),
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
      Color(0xFF1976F3),
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
            color: cardColor.withValues(alpha: .22),
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
                borderRadius:
                    BorderRadius.circular(18),
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
                      color: Color(0xFF637D96),
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

// ============================================================
// FEATURE SECTION
// ============================================================

class _FeatureSection extends StatelessWidget {
  const _FeatureSection();

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

// ============================================================
// FEATURE ITEM
// ============================================================

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
            color: const Color(0xFFD7EAFF),
            borderRadius:
                BorderRadius.circular(15),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF1976F3),
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