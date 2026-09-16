import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'grade_menu_page.dart';
import 'material_page.dart';
import 'ranking_page.dart';
import 'school_ui.dart';

// ============================================================
// HELPER: GAMBAR ASSET + FALLBACK IKON
// Kalau file asset belum ada / salah nama, aplikasi tidak crash,
// tapi otomatis balik ke ikon bawaan Flutter.
// ============================================================

class AssetIcon extends StatelessWidget {
  const AssetIcon({
    super.key,
    required this.asset,
    required this.fallbackIcon,
    required this.size,
    this.fallbackColor = const Color(0xFF3F6FE8),
    this.fit = BoxFit.contain,
  });

  final String asset;
  final IconData fallbackIcon;
  final double size;
  final Color fallbackColor;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      asset,
      width: size,
      height: size,
      fit: fit,
      filterQuality: FilterQuality.high,
      errorBuilder: (context, error, stackTrace) {
        return Icon(
          fallbackIcon,
          size: size * .8,
          color: fallbackColor,
        );
      },
    );
  }
}

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

    // Disamakan dengan Splash Screen: matahari membal pelan
    // (bounce + rotate sedikit), bukan berputar penuh.
    _sunController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
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
                                            ? 3.6
                                            : 2.6,
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

                            const SizedBox(height: 20),

                            const _GaleriSection(),
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
// Matahari, awan, dan pohon SUDAH memakai gambar asset.
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

    final sunSize = width < 600 ? 120.0 : 165.0;

    final treeWidth = width < 600 ? 150.0 : 230.0;

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
          // AWAN 1 (asset: AWAN 1.png)
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
              asset: 'assets/AWAN 1.png',
              width: 230,
            ),
          ),

          // ==================================================
          // AWAN 2 (asset: AWAN 2.png)
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
              asset: 'assets/AWAN 2.png',
              width: 175,
            ),
          ),

          // ==================================================
          // AWAN 3 (asset: AWAN 3.png)
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
              asset: 'assets/AWAN 3.png',
              width: 140,
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
          // MATAHARI (asset: Matahari.png)
          // Posisi tetap seperti dashboard: pojok kanan atas.
          // Animasi disamakan dengan Splash Screen (membal).
          // ==================================================

          Positioned(
            top: 10,
            right: width < 600 ? 10 : 40,
            child: AnimatedBuilder(
              animation: widget.sunAnimation,
              builder: (context, child) {
                final bounce = math.sin(
                      widget.sunAnimation.value * math.pi,
                    ) *
                    8;

                final rotate = math.sin(
                      widget.sunAnimation.value * math.pi,
                    ) *
                    0.05;

                return Transform.translate(
                  offset: Offset(0, -bounce),
                  child: Transform.rotate(
                    angle: rotate,
                    child: child,
                  ),
                );
              },
              child: Image.asset(
                'assets/Matahari.png',
                width: sunSize,
                height: sunSize,
                fit: BoxFit.contain,
                errorBuilder:
                    (context, error, stackTrace) {
                  return Icon(
                    Icons.wb_sunny_rounded,
                    size: sunSize * .7,
                    color: const Color(0xFFFFC83D),
                  );
                },
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
          // POHON — dibuat sama (pakai gambar pohon kiri) di
          // kanan & kiri saja, tanpa pohon tengah.
          // (asset: Gambar pohon 1.png)
          // ==================================================

          Positioned(
            left: width < 600 ? -10 : 10,
            bottom: -6,
            child: _TreeDecoration(
              asset: 'assets/Gambar pohon 1.png',
              width: treeWidth,
            ),
          ),

          Positioned(
            right: width < 600 ? -10 : 10,
            bottom: -6,
            child: _TreeDecoration(
              asset: 'assets/Gambar pohon 1.png',
              width: treeWidth * .95,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// CLOUD (pakai gambar asset seperti Splash Screen)
// ============================================================

class _CloudDecoration extends StatelessWidget {
  const _CloudDecoration({
    required this.asset,
    required this.width,
  });

  final String asset;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      asset,
      width: width,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return SizedBox(
          width: width,
          height: width * .42,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .9),
              borderRadius: BorderRadius.circular(60),
            ),
          ),
        );
      },
    );
  }
}

// ============================================================
// TREE (pakai gambar asset)
// ============================================================

class _TreeDecoration extends StatelessWidget {
  const _TreeDecoration({
    required this.asset,
    required this.width,
  });

  final String asset;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      asset,
      width: width,
      fit: BoxFit.contain,
      alignment: Alignment.bottomCenter,
      filterQuality: FilterQuality.high,
      errorBuilder: (context, error, stackTrace) {
        return const SizedBox.shrink();
      },
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
// HEADER (ikon pakai asset "Gambar anak anak sd.png")
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
          padding: const EdgeInsets.all(6),
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
          child: const AssetIcon(
            asset: 'assets/Gambar anak anak sd.png',
            fallbackIcon: Icons.school_rounded,
            size: 50,
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
      ],
    );
  }
}

// ============================================================
// WELCOME CARD (ilustrasi pakai asset "Gambar anak sd.png")
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
                width: 160,
                height: 130,
                padding: const EdgeInsets.all(8),
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
                      top: 6,
                      right: 10,
                      child: Text(
                        '⭐',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      left: 10,
                      child: Text(
                        '✨',
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                    ),
                    AssetIcon(
                      asset:
                          'assets/Gambar anak sd.png',
                      fallbackIcon:
                          Icons.auto_stories_rounded,
                      size: 112,
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
// GRADE CARD (ikon pakai asset "Kelas 1.png" s/d "Kelas 6.png")
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

  // Nama file mengikuti isi folder assets: "Kelas 1.png" dst.
  String get gradeAsset => 'assets/Kelas $grade.png';

  IconData get fallbackIcon {
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
        padding: const EdgeInsets.symmetric(
          horizontal: 13,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: cardColor.withValues(alpha: .20),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: cardColor.withValues(alpha: .13),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
            const BoxShadow(
              color: Color(0x10000000),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 62,
              height: 62,
              padding: const EdgeInsets.all(6),
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
                    BorderRadius.circular(18),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  AssetIcon(
                    asset: gradeAsset,
                    fallbackIcon: fallbackIcon,
                    fallbackColor: cardColor,
                    size: 50,
                  ),
                  Positioned(
                    right: -4,
                    top: -4,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: cardColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
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

            const SizedBox(width: 12),

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
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF314566),
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF71839A),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 6),

            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: cardColor.withValues(alpha: .11),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_forward_rounded,
                size: 17,
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
// FEATURE SECTION (ikon pakai asset)
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
                      asset:
                          'assets/Gambar anak sd lagi.png',
                      fallbackIcon:
                          Icons.menu_book_rounded,
                      title: 'Belajar',
                      color: Color(0xFF3F6FE8),
                    ),
                    SizedBox(height: 14),
                    _FeatureItem(
                      asset:
                          'assets/anak sd tolong menolong.png',
                      fallbackIcon:
                          Icons.sports_esports_rounded,
                      title: 'Bermain',
                      color: Color(0xFF55C98A),
                    ),
                    SizedBox(height: 14),
                    _FeatureItem(
                      asset:
                          'assets/anak sd angkat tangan.png',
                      fallbackIcon:
                          Icons.emoji_events_rounded,
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
                    asset:
                        'assets/Gambar anak sd lagi.png',
                    fallbackIcon:
                        Icons.menu_book_rounded,
                    title: 'Belajar',
                    color: Color(0xFF3F6FE8),
                  ),
                  _FeatureItem(
                    asset:
                        'assets/anak sd tolong menolong.png',
                    fallbackIcon:
                        Icons.sports_esports_rounded,
                    title: 'Bermain',
                    color: Color(0xFF55C98A),
                  ),
                  _FeatureItem(
                    asset:
                        'assets/anak sd angkat tangan.png',
                    fallbackIcon:
                        Icons.emoji_events_rounded,
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
// GALERI SEKOLAH
// Menampilkan sisa gambar asset supaya semua ilustrasi terpakai.
// ============================================================

class _GaleriSection extends StatelessWidget {
  const _GaleriSection();

  @override
  Widget build(BuildContext context) {
    const items = [
      _GaleriItem(
        asset: 'assets/Gambar guru l.png',
        label: 'Pak Guru',
        color: Color(0xFF3F6FE8),
      ),
      _GaleriItem(
        asset: 'assets/Gambar guru p.png',
        label: 'Bu Guru',
        color: Color(0xFFFF718F),
      ),
      _GaleriItem(
        asset: 'assets/Anak Sd Cowok.png',
        label: 'Teman Cowok',
        color: Color(0xFF36B8C9),
      ),
      _GaleriItem(
        asset: 'assets/Anak Sd Cewek.png',
        label: 'Teman Cewek',
        color: Color(0xFF9A7BE3),
      ),
      _GaleriItem(
        asset: 'assets/Naik bus.png',
        label: 'Berangkat Sekolah',
        color: Color(0xFFFFB84D),
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFFFFF),
            Color(0xFFFFFBF2),
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
            'Kenalan Dulu Yuk! 🙌',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w900,
              color: Color(0xFF283B63),
            ),
          ),

          const SizedBox(height: 7),

          const Text(
            'Ini teman-teman dan guru yang menemani kamu belajar.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF71839A),
            ),
          ),

          const SizedBox(height: 20),

          const Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            runSpacing: 16,
            children: items,
          ),
        ],
      ),
    );
  }
}

class _GaleriItem extends StatelessWidget {
  const _GaleriItem({
    required this.asset,
    required this.label,
    required this.color,
  });

  final String asset;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 110,
            height: 110,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withValues(alpha: .16),
                  color.withValues(alpha: .06),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: color.withValues(alpha: .18),
                width: 2,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: AssetIcon(
                asset: asset,
                fallbackIcon: Icons.person_rounded,
                fallbackColor: color,
                size: 94,
              ),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: Color(0xFF526B84),
            ),
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
    required this.asset,
    required this.fallbackIcon,
    required this.title,
    required this.color,
  });

  final String asset;
  final IconData fallbackIcon;
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 64,
          height: 64,
          padding: const EdgeInsets.all(6),
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
                BorderRadius.circular(18),
          ),
          child: AssetIcon(
            asset: asset,
            fallbackIcon: fallbackIcon,
            fallbackColor: color,
            size: 52,
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