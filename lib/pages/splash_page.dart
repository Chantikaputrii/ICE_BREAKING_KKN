import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with TickerProviderStateMixin {
  late final AnimationController _characterController;
  late final AnimationController _sunController;
  late final AnimationController _cloudController;
  late final AnimationController _cardController;

  @override
  void initState() {
    super.initState();

    // Karakter bergerak terus-menerus
    _characterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    // Matahari berputar
    _sunController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    // Awan bergerak
    _cloudController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 24),
    )..repeat();

    // Animasi masuk kartu
    _cardController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
  }

  @override
  void dispose() {
    _characterController.dispose();
    _sunController.dispose();
    _cloudController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  void _goToDashboard() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const HomePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final desktop = width >= 900;

          return Stack(
            fit: StackFit.expand,
            children: [
              const _SplashBackground(),

              // ============================================================
              // MATAHARI
              // ============================================================
              Positioned(
                top: desktop ? 45 : 20,
                right: desktop ? 70 : 20,
                child: AnimatedBuilder(
                  animation: _sunController,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _sunController.value * math.pi * 2,
                      child: child,
                    );
                  },
                  child: const _AnimatedSun(),
                ),
              ),

              // ============================================================
              // AWAN 1
              // ============================================================
              AnimatedBuilder(
                animation: _cloudController,
                builder: (context, child) {
                  final x = -250 +
                      ((width + 500) * _cloudController.value);

                  return Positioned(
                    top: desktop ? 70 : 45,
                    left: x,
                    child: const _BigCloud(
                      scale: 1.0,
                    ),
                  );
                },
              ),

              // ============================================================
              // AWAN 2
              // ============================================================
              AnimatedBuilder(
                animation: _cloudController,
                builder: (context, child) {
                  final t =
                      (_cloudController.value + .48) % 1;

                  return Positioned(
                    top: desktop ? 150 : 110,
                    left: -200 + ((width + 400) * t),
                    child: const _BigCloud(
                      scale: .72,
                    ),
                  );
                },
              ),

              // ============================================================
              // BINTANG
              // ============================================================
              const Positioned(
                top: 135,
                left: 85,
                child: _Sparkle(
                  size: 20,
                ),
              ),

              const Positioned(
                top: 225,
                right: 170,
                child: _Sparkle(
                  size: 14,
                ),
              ),

              const Positioned(
                top: 305,
                left: 175,
                child: _Sparkle(
                  size: 12,
                ),
              ),

              // ============================================================
              // CONTENT UTAMA
              // ============================================================
              Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    top: desktop ? 20 : 10,
                    left: desktop ? 90 : 12,
                    right: desktop ? 90 : 12,
                    bottom: desktop ? 95 : 105,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 1120,
                    ),
                    child: FadeTransition(
                      opacity: CurvedAnimation(
                        parent: _cardController,
                        curve: Curves.easeOut,
                      ),
                      child: ScaleTransition(
                        scale: Tween<double>(
                          begin: .90,
                          end: 1.0,
                        ).animate(
                          CurvedAnimation(
                            parent: _cardController,
                            curve: Curves.easeOutBack,
                          ),
                        ),
                        child: _SplashScene(
                          desktop: desktop,
                          screenWidth: width,
                          characterController:
                              _characterController,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // ============================================================
              // TOMBOL DASHBOARD
              // ============================================================
              Positioned(
                right: desktop ? 28 : 15,
                bottom: desktop ? 22 : 15,
                child: _EnterButton(
                  onTap: _goToDashboard,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ============================================================================
// SCENE UTAMA
// ============================================================================

class _SplashScene extends StatelessWidget {
  const _SplashScene({
    required this.desktop,
    required this.screenWidth,
    required this.characterController,
  });

  final bool desktop;
  final double screenWidth;
  final AnimationController characterController;

  @override
  Widget build(BuildContext context) {
    final cardWidth = desktop
        ? 820.0
        : math.min(screenWidth - 28, 600.0);

    // Tinggi stage dipas-kan dekat tinggi kartu saja (bukan dibuat sangat
    // tinggi), supaya karakter yang berdiri di sisi kartu tetap berada di
    // area bawah/tengah kartu — bukan menggantung tinggi di area langit
    // dekat matahari & awan.
    final stageHeight = desktop ? 660.0 : 640.0;

    return SizedBox(
      width: desktop ? 1080 : cardWidth,
      height: stageHeight,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // ================================================================
          // KARTU PUTIH
          // ================================================================
          Positioned(
            top: desktop ? 40 : 35,
            child: _SplashCard(
              desktop: desktop,
              width: cardWidth,
            ),
          ),

          // ================================================================
          // ANAK COWOK
          // UKURAN DIPERBESAR, TETAP DI SAMPING KIRI KARTU, TAPI
          // DISANDARKAN DEKAT DASAR KARTU (TIDAK MENGAMBANG DI LANGIT)
          // ================================================================
          Positioned(
            left: desktop ? -8 : -18,
            bottom: desktop ? 12 : 10,
            child: _AnimatedCharacter(
              controller: characterController,
              assetPath: 'assets/Anak Sd Cowok.png',
              delay: 0,
              desktop: desktop,
            ),
          ),

          // ================================================================
          // ANAK CEWEK
          // UKURAN DIPERBESAR, TETAP DI SAMPING KANAN KARTU, TAPI
          // DISANDARKAN DEKAT DASAR KARTU (TIDAK MENGAMBANG DI LANGIT)
          // ================================================================
          Positioned(
            right: desktop ? -8 : -18,
            bottom: desktop ? 12 : 10,
            child: _AnimatedCharacter(
              controller: characterController,
              assetPath: 'assets/Anak Sd Cewek.png',
              delay: math.pi * .55,
              desktop: desktop,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// KARAKTER ANIMASI
// ============================================================================

class _AnimatedCharacter extends StatelessWidget {
  const _AnimatedCharacter({
    required this.controller,
    required this.assetPath,
    required this.delay,
    required this.desktop,
  });

  final AnimationController controller;
  final String assetPath;
  final double delay;
  final bool desktop;

  @override
  Widget build(BuildContext context) {
    // ==================================================================
    // UKURAN ASSET
    // SEBELUMNYA 235 x 300
    // SEKARANG DIPERBESAR JADI 320 x 410 (desktop) / 280 x 360 (mobile)
    // ==================================================================
    final assetWidth = desktop ? 320.0 : 280.0;
    final assetHeight = desktop ? 410.0 : 360.0;

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final phase =
            controller.value * math.pi * 2 + delay;

        // Bobbing kecil saja (bukan naik-turun besar) supaya karakter
        // tetap terasa berpijak, bukan melayang di udara.
        final y = math.sin(phase) * 6;

        // Gerak kanan kiri sedikit
        final x = math.sin(phase * .8) * 3;

        // Miring sedikit
        final rotation =
            math.sin(phase) * .02;

        return Transform.translate(
          // Offset y dibuat hanya mengurangi (ke atas), tidak pernah
          // mendorong karakter turun melewati garis dasar, sehingga
          // kakinya tetap terlihat menapak.
          offset: Offset(x, -y.abs()),
          child: Transform.rotate(
            angle: rotation,
            alignment: Alignment.bottomCenter,
            child: child,
          ),
        );
      },
      child: SizedBox(
        width: assetWidth,
        height: assetHeight,
        child: Image.asset(
          assetPath,
          fit: BoxFit.contain,
          alignment: Alignment.bottomCenter,
          errorBuilder:
              (context, error, stackTrace) {
            return Container(
              width: assetWidth,
              height: assetHeight,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white.withValues(
                  alpha: .85,
                ),
                borderRadius:
                    BorderRadius.circular(25),
              ),
              child: const Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons
                        .image_not_supported_rounded,
                    size: 45,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Asset tidak ditemukan',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// ============================================================================
// KARTU UTAMA
// ============================================================================

class _SplashCard extends StatelessWidget {
  const _SplashCard({
    required this.desktop,
    required this.width,
  });

  final bool desktop;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      constraints: BoxConstraints(
        minHeight: 510,
        maxHeight: desktop ? 575 : 570,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: desktop ? 42 : 22,
        vertical: desktop ? 30 : 24,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(
          alpha: .94,
        ),
        borderRadius:
            BorderRadius.circular(42),
        border: Border.all(
          color: Colors.white.withValues(
            alpha: .90,
          ),
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF17669A)
                .withValues(alpha: .18),
            blurRadius: 35,
            spreadRadius: 4,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ==============================================================
          // ICON BUKU
          // ==============================================================
          Container(
            width: desktop ? 105 : 82,
            height: desktop ? 105 : 82,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient:
                  const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF5EC9FF),
                  Color(0xFF4F8FF7),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4F8FF7)
                      .withValues(alpha: .25),
                  blurRadius: 25,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Icon(
              Icons.menu_book_rounded,
              color: Colors.white,
              size: desktop ? 52 : 42,
            ),
          ),

          const SizedBox(height: 14),

          // ==============================================================
          // LABEL
          // ==============================================================
          Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFE6F5FF),
              borderRadius:
                  BorderRadius.circular(30),
              border: Border.all(
                color:
                    const Color(0xFFB9E3FF),
              ),
            ),
            child: const Text(
              'MEDIA PEMBELAJARAN ANAK SD',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: Color(0xFF277CC8),
                letterSpacing: .3,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // ==============================================================
          // JUDUL BELAJAR CERIA
          // FONT PLAYFUL + WARNA WARNI
          // ==============================================================
          const _ColorfulTitle(),

          const SizedBox(height: 7),

          Text(
            'Halo, Teman Belajar! 👋',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: desktop ? 25 : 22,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF3989F5),
            ),
          ),

          const SizedBox(height: 7),

          const Text(
            'Selamat datang di dunia belajar yang seru, '
            'menyenangkan, dan penuh tantangan!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              height: 1.4,
              fontWeight: FontWeight.w700,
              color: Color(0xFF617B96),
            ),
          ),

          const SizedBox(height: 17),

          // ==============================================================
          // FITUR
          // ==============================================================
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 8,
            children: const [
              _FeatureChip(
                icon: Icons.menu_book_rounded,
                label: 'Belajar',
                color: Color(0xFF4F8FF7),
              ),
              _FeatureChip(
                icon:
                    Icons.sports_esports_rounded,
                label: 'Bermain',
                color: Color(0xFF25C78A),
              ),
              _FeatureChip(
                icon:
                    Icons.emoji_events_rounded,
                label: 'Berprestasi',
                color: Color(0xFFFFA726),
              ),
            ],
          ),

          const SizedBox(height: 17),

          const _SchoolBook(),
        ],
      ),
    );
  }
}

// ============================================================================
// JUDUL WARNA-WARNI
// ============================================================================

class _ColorfulTitle extends StatelessWidget {
  const _ColorfulTitle();

  @override
  Widget build(BuildContext context) {
    const title = 'BELAJAR CERIA';

    // Warna dibuat bergantian seperti huruf alfabet
    // pada gambar referensi yang kamu kirim.
    const colors = [
      Color(0xFF78A900),
      Color(0xFF009DAA),
      Color(0xFFFF8A00),
      Color(0xFFE8274D),
      Color(0xFF78A900),
      Color(0xFF009DAA),
      Color(0xFFE8274D),
      Color(0xFFFF8A00),
      Color(0xFF78A900),
      Color(0xFF009DAA),
      Color(0xFFE8274D),
      Color(0xFF78A900),
    ];

    final spans = <TextSpan>[];
    var colorIndex = 0;

    for (final char in title.split('')) {
      if (char == ' ') {
        spans.add(
          const TextSpan(
            text: '  ',
          ),
        );
        continue;
      }

      spans.add(
        TextSpan(
          text: char,
          style: GoogleFonts.bubblegumSans(
            fontSize: 58,
            fontWeight: FontWeight.w400,
            color:
                colors[colorIndex % colors.length],
            letterSpacing: 0,
            shadows: const [
              Shadow(
                offset: Offset(0, 3),
                blurRadius: 0,
                color: Color(0x35000000),
              ),
            ],
          ),
        ),
      );

      colorIndex++;
    }

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: spans,
        ),
      ),
    );
  }
}

// ============================================================================
// CHIP FITUR
// ============================================================================

class _FeatureChip extends StatelessWidget {
  const _FeatureChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color:
            color.withValues(alpha: .09),
        borderRadius:
            BorderRadius.circular(25),
        border: Border.all(
          color:
              color.withValues(alpha: .16),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 7),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// BUKU
// ============================================================================

class _SchoolBook extends StatelessWidget {
  const _SchoolBook();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 82,
      height: 60,
      decoration: BoxDecoration(
        gradient:
            const LinearGradient(
          colors: [
            Color(0xFFFFD75A),
            Color(0xFFFFB82E),
          ],
        ),
        borderRadius:
            BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8B6A36)
                .withValues(alpha: .20),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: const Icon(
        Icons.menu_book_rounded,
        color: Colors.white,
        size: 38,
      ),
    );
  }
}

// ============================================================================
// TOMBOL MASUK DASHBOARD
// ============================================================================

class _EnterButton extends StatefulWidget {
  const _EnterButton({
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  State<_EnterButton> createState() =>
      _EnterButtonState();
}

class _EnterButtonState
    extends State<_EnterButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration:
          const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            _controller.value * 4,
            0,
          ),
          child: child,
        );
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius:
              BorderRadius.circular(18),
          child: Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              gradient:
                  const LinearGradient(
                colors: [
                  Color(0xFF4F8FF7),
                  Color(0xFF2875E8),
                ],
              ),
              borderRadius:
                  BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color:
                      const Color(0xFF2875E8)
                          .withValues(
                    alpha: .28,
                  ),
                  blurRadius: 16,
                  offset: const Offset(0, 7),
                ),
              ],
            ),
            child: const Row(
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                SizedBox(width: 7),
                Text(
                  'Masuk Dashboard',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
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

// ============================================================================
// MATAHARI
// ============================================================================

class _AnimatedSun extends StatelessWidget {
  const _AnimatedSun();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color:
            const Color(0xFFFFCE4F),
        boxShadow: [
          BoxShadow(
            color:
                const Color(0xFFFFC94A)
                    .withValues(
              alpha: .35,
            ),
            blurRadius: 35,
            spreadRadius: 12,
          ),
        ],
      ),
      child: const Center(
        child: Icon(
          Icons.sentiment_satisfied_alt_rounded,
          color: Color(0xFFFFF3BF),
          size: 58,
        ),
      ),
    );
  }
}

// ============================================================================
// AWAN
// ============================================================================

class _BigCloud extends StatelessWidget {
  const _BigCloud({
    this.scale = 1,
  });

  final double scale;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: SizedBox(
        width: 230,
        height: 105,
        child: Stack(
          children: [
            Positioned(
              left: 20,
              right: 20,
              bottom: 10,
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color:
                      Colors.white.withValues(
                    alpha: .92,
                  ),
                  borderRadius:
                      BorderRadius.circular(30),
                ),
              ),
            ),
            const Positioned(
              left: 35,
              bottom: 25,
              child: _CloudCircle(
                size: 60,
              ),
            ),
            const Positioned(
              left: 82,
              bottom: 38,
              child: _CloudCircle(
                size: 75,
              ),
            ),
            const Positioned(
              right: 35,
              bottom: 27,
              child: _CloudCircle(
                size: 58,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CloudCircle extends StatelessWidget {
  const _CloudCircle({
    required this.size,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color:
            Colors.white.withValues(
          alpha: .94,
        ),
      ),
    );
  }
}

// ============================================================================
// SPARKLE
// ============================================================================

class _Sparkle extends StatelessWidget {
  const _Sparkle({
    required this.size,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.auto_awesome_rounded,
      size: size,
      color: const Color(0xFFFFD34E),
    );
  }
}

// ============================================================================
// BACKGROUND
// ============================================================================

class _SplashBackground
    extends StatelessWidget {
  const _SplashBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          const BoxDecoration(
        gradient:
            LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF35AEEF),
            Color(0xFF75D4F5),
            Color(0xFFC8F0F7),
            Color(0xFFEAF8DD),
          ],
          stops: [
            0,
            .45,
            .75,
            1,
          ],
        ),
      ),
      child: const CustomPaint(
        painter:
            _SplashLandscapePainter(),
      ),
    );
  }
}

// ============================================================================
// LANDSCAPE / BUKIT / POHON
// ============================================================================

class _SplashLandscapePainter
    extends CustomPainter {
  const _SplashLandscapePainter();

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    // Bukit belakang.
    paint.color =
        const Color(0xFF9BDF8A);

    final backHill = Path()
      ..moveTo(
        0,
        size.height * .82,
      )
      ..quadraticBezierTo(
        size.width * .20,
        size.height * .70,
        size.width * .42,
        size.height * .81,
      )
      ..quadraticBezierTo(
        size.width * .65,
        size.height * .91,
        size.width,
        size.height * .73,
      )
      ..lineTo(
        size.width,
        size.height,
      )
      ..lineTo(
        0,
        size.height,
      )
      ..close();

    canvas.drawPath(
      backHill,
      paint,
    );

    // Bukit depan.
    paint.color =
        const Color(0xFF68C96B);

    final frontHill = Path()
      ..moveTo(
        0,
        size.height * .89,
      )
      ..quadraticBezierTo(
        size.width * .18,
        size.height * .79,
        size.width * .40,
        size.height * .88,
      )
      ..quadraticBezierTo(
        size.width * .67,
        size.height * .98,
        size.width,
        size.height * .84,
      )
      ..lineTo(
        size.width,
        size.height,
      )
      ..lineTo(
        0,
        size.height,
      )
      ..close();

    canvas.drawPath(
      frontHill,
      paint,
    );

    // Pohon kiri.
    _drawTree(
      canvas,
      Offset(
        28,
        size.height * .83,
      ),
      1.0,
    );

    // Pohon kanan.
    _drawTree(
      canvas,
      Offset(
        size.width - 28,
        size.height * .83,
      ),
      .9,
    );
  }

  void _drawTree(
    Canvas canvas,
    Offset base,
    double scale,
  ) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    // Batang.
    paint.color =
        const Color(0xFF8A542F);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(
            base.dx,
            base.dy - 70 * scale,
          ),
          width: 30 * scale,
          height: 130 * scale,
        ),
        Radius.circular(
          10 * scale,
        ),
      ),
      paint,
    );

    // Daun.
    paint.color =
        const Color(0xFF45A95B);

    canvas.drawCircle(
      Offset(
        base.dx - 32 * scale,
        base.dy - 120 * scale,
      ),
      42 * scale,
      paint,
    );

    canvas.drawCircle(
      Offset(
        base.dx + 25 * scale,
        base.dy - 125 * scale,
      ),
      48 * scale,
      paint,
    );

    canvas.drawCircle(
      Offset(
        base.dx,
        base.dy - 155 * scale,
      ),
      50 * scale,
      paint,
    );

    // Highlight daun.
    paint.color =
        const Color(0xFF6FD36D);

    canvas.drawCircle(
      Offset(
        base.dx - 18 * scale,
        base.dy - 140 * scale,
      ),
      15 * scale,
      paint,
    );

    canvas.drawCircle(
      Offset(
        base.dx + 32 * scale,
        base.dy - 115 * scale,
      ),
      13 * scale,
      paint,
    );
  }

  @override
  bool shouldRepaint(
    covariant CustomPainter oldDelegate,
  ) {
    return false;
  }
}