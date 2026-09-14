import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({
    super.key,
  });

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with TickerProviderStateMixin {
  late final AnimationController _floatingController;
  late final AnimationController _sunController;
  late final AnimationController _cloudController;
  late final AnimationController _titleController;

  @override
  void initState() {
    super.initState();

    // Animasi utama yang terus berjalan.
    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    // Matahari berputar sangat pelan.
    _sunController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    // Awan bergerak perlahan.
    _cloudController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 24),
    )..repeat();

    // Animasi masuk untuk tulisan.
    _titleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..forward();
  }

  @override
  void dispose() {
    _floatingController.dispose();
    _sunController.dispose();
    _cloudController.dispose();
    _titleController.dispose();
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
          final height = constraints.maxHeight;

          final bool desktop = width >= 900;

          return Stack(
            fit: StackFit.expand,
            children: [
              // =========================================================
              // BACKGROUND
              // =========================================================
              const _SplashBackground(),

              // =========================================================
              // MATAHARI
              // =========================================================
              Positioned(
                top: desktop ? 35 : 20,
                right: desktop ? 70 : 25,
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

              // =========================================================
              // AWAN 1
              // =========================================================
              AnimatedBuilder(
                animation: _cloudController,
                builder: (context, child) {
                  final t = _cloudController.value;

                  return Positioned(
                    top: desktop ? 65 : 50,
                    left: -180 + ((width + 360) * t),
                    child: const _BigCloud(
                      scale: 1.0,
                    ),
                  );
                },
              ),

              // =========================================================
              // AWAN 2
              // =========================================================
              AnimatedBuilder(
                animation: _cloudController,
                builder: (context, child) {
                  final t =
                      (_cloudController.value + .48) % 1;

                  return Positioned(
                    top: desktop ? 150 : 115,
                    left: -150 + ((width + 300) * t),
                    child: const _BigCloud(
                      scale: .72,
                    ),
                  );
                },
              ),

              // =========================================================
              // DAUN / BINTANG KECIL
              // =========================================================
              const Positioned(
                top: 130,
                left: 80,
                child: _Sparkle(
                  size: 20,
                ),
              ),

              const Positioned(
                top: 230,
                right: 170,
                child: _Sparkle(
                  size: 14,
                ),
              ),

              const Positioned(
                top: 300,
                left: 170,
                child: _Sparkle(
                  size: 12,
                ),
              ),

              // =========================================================
              // KONTEN UTAMA
              // =========================================================
              Center(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  padding: EdgeInsets.only(
                    top: desktop ? 25 : 20,
                    left: 20,
                    right: 20,
                    bottom: desktop ? 90 : 110,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 920,
                    ),
                    child: AnimatedBuilder(
                      animation: _titleController,
                      builder: (context, child) {
                        final curved = CurvedAnimation(
                          parent: _titleController,
                          curve: Curves.easeOutBack,
                        );

                        return Opacity(
                          opacity: _titleController.value,
                          child: Transform.scale(
                            scale: .88 +
                                (curved.value * .12),
                            child: child,
                          ),
                        );
                      },
                      child: _SplashCard(
                        desktop: desktop,
                        height: height,
                      ),
                    ),
                  ),
                ),
              ),

              // =========================================================
              // TOMBOL MASUK DASHBOARD
              // KANAN BAWAH, TIDAK TERLALU BESAR
              // =========================================================
              Positioned(
                right: desktop ? 28 : 18,
                bottom: desktop ? 24 : 18,
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

// =====================================================================
// BACKGROUND SPLASH
// =====================================================================

class _SplashBackground extends StatelessWidget {
  const _SplashBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
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
      child: CustomPaint(
        painter: _SplashLandscapePainter(),
      ),
    );
  }
}

// =====================================================================
// SPLASH CARD
// =====================================================================

class _SplashCard extends StatelessWidget {
  const _SplashCard({
    required this.desktop,
    required this.height,
  });

  final bool desktop;
  final double height;

  @override
  Widget build(BuildContext context) {
    final double cardWidth = desktop ? 760 : 500;

    return Container(
      width: cardWidth,
      constraints: BoxConstraints(
        maxWidth: 760,
        minHeight: desktop ? 480 : 430,
        maxHeight: desktop
            ? math.min(height - 120, 600)
            : 620,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: desktop ? 45 : 25,
        vertical: desktop ? 32 : 25,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .94),
        borderRadius: BorderRadius.circular(42),
        border: Border.all(
          color: Colors.white.withValues(alpha: .85),
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
          // ===========================================================
          // LOGO / ICON BUKU
          // ===========================================================
          Container(
            width: desktop ? 105 : 85,
            height: desktop ? 105 : 85,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
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
            child: const Center(
              child: Icon(
                Icons.menu_book_rounded,
                color: Colors.white,
                size: 52,
              ),
            ),
          ),

          const SizedBox(height: 14),

          // ===========================================================
          // LABEL
          // ===========================================================
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFE6F5FF),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: const Color(0xFFB9E3FF),
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

          const SizedBox(height: 13),

          // ===========================================================
          // JUDUL
          // ===========================================================
          const FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'BELAJAR CERIA',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.w900,
                color: Color(0xFF234E86),
                letterSpacing: 1,
              ),
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Halo, Teman Belajar! 👋',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w900,
              color: Color(0xFF3989F5),
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Selamat datang di dunia belajar yang seru, '
            'menyenangkan, dan penuh tantangan!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              height: 1.45,
              fontWeight: FontWeight.w700,
              color: Color(0xFF617B96),
            ),
          ),

          const SizedBox(height: 18),

          // ===========================================================
          // 3 FITUR
          // ===========================================================
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
                icon: Icons.sports_esports_rounded,
                label: 'Bermain',
                color: Color(0xFF25C78A),
              ),
              _FeatureChip(
                icon: Icons.emoji_events_rounded,
                label: 'Berprestasi',
                color: Color(0xFFFFA726),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ===========================================================
          // ANAK SD / ILUSTRASI
          // ===========================================================
          SizedBox(
            height: desktop ? 100 : 80,
            child: _ChildrenIllustration(),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// FEATURE CHIP
// =====================================================================

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
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .09),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: color.withValues(alpha: .16),
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

// =====================================================================
// ILUSTRASI ANAK
// =====================================================================

class _ChildrenIllustration extends StatefulWidget {
  @override
  State<_ChildrenIllustration> createState() =>
      _ChildrenIllustrationState();
}

class _ChildrenIllustrationState
    extends State<_ChildrenIllustration>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final y =
            math.sin(controller.value * math.pi) * 5;

        return Transform.translate(
          offset: Offset(0, -y),
          child: child,
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _ChildCharacter(
            boy: true,
          ),
          const SizedBox(width: 12),
          const _SchoolBook(),
          const SizedBox(width: 12),
          _ChildCharacter(
            boy: false,
          ),
        ],
      ),
    );
  }
}

class _ChildCharacter extends StatelessWidget {
  const _ChildCharacter({
    required this.boy,
  });

  final bool boy;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 100,
      child: CustomPaint(
        painter: _ChildPainter(
          boy: boy,
        ),
      ),
    );
  }
}

class _ChildPainter extends CustomPainter {
  const _ChildPainter({
    required this.boy,
  });

  final bool boy;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    // Kepala
    paint.color = const Color(0xFFFFC79D);
    canvas.drawCircle(
      Offset(size.width / 2, 27),
      18,
      paint,
    );

    // Rambut
    paint.color = boy
        ? const Color(0xFF5B321F)
        : const Color(0xFF3C241A);

    if (boy) {
      final hair = Path()
        ..moveTo(23, 27)
        ..quadraticBezierTo(
          28,
          3,
          42,
          8,
        )
        ..quadraticBezierTo(
          55,
          5,
          58,
          27,
        )
        ..close();

      canvas.drawPath(hair, paint);
    } else {
      canvas.drawCircle(
        Offset(size.width / 2, 22),
        23,
        paint,
      );

      paint.color = const Color(0xFFFF365D);

      canvas.drawRect(
        Rect.fromLTWH(
          25,
          8,
          30,
          5,
        ),
        paint,
      );
    }

    // Mata
    paint.color = const Color(0xFF35251F);

    canvas.drawCircle(
      const Offset(34, 28),
      2.5,
      paint,
    );

    canvas.drawCircle(
      const Offset(46, 28),
      2.5,
      paint,
    );

    // Senyum
    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;

    final smile = Path()
      ..moveTo(35, 36)
      ..quadraticBezierTo(
        40,
        41,
        46,
        36,
      );

    canvas.drawPath(smile, paint);

    // Badan seragam
    paint
      ..style = PaintingStyle.fill
      ..color = Colors.white;

    final body = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        21,
        46,
        38,
        40,
      ),
      const Radius.circular(9),
    );

    canvas.drawRRect(body, paint);

    // Celana / rok
    paint.color = boy
        ? const Color(0xFFE83B32)
        : const Color(0xFFE83B32);

    canvas.drawRect(
      Rect.fromLTWH(
        23,
        82,
        16,
        15,
      ),
      paint,
    );

    canvas.drawRect(
      Rect.fromLTWH(
        41,
        82,
        16,
        15,
      ),
      paint,
    );

    // Dasi
    paint.color = const Color(0xFFE73535);

    final tie = Path()
      ..moveTo(37, 48)
      ..lineTo(43, 48)
      ..lineTo(40, 70)
      ..lineTo(37, 48)
      ..close();

    canvas.drawPath(tie, paint);

    // Tangan
    paint.color = const Color(0xFFFFC79D);

    canvas.drawCircle(
      const Offset(18, 58),
      6,
      paint,
    );

    canvas.drawCircle(
      const Offset(62, 58),
      6,
      paint,
    );
  }

  @override
  bool shouldRepaint(
    covariant _ChildPainter oldDelegate,
  ) {
    return oldDelegate.boy != boy;
  }
}

class _SchoolBook extends StatelessWidget {
  const _SchoolBook();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 68,
      height: 55,
      decoration: BoxDecoration(
        color: const Color(0xFFFFC94A),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x228B6A36),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: const Icon(
        Icons.menu_book_rounded,
        color: Colors.white,
        size: 35,
      ),
    );
  }
}

// =====================================================================
// TOMBOL MASUK
// =====================================================================

class _EnterButton extends StatefulWidget {
  const _EnterButton({
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  State<_EnterButton> createState() =>
      _EnterButtonState();
}

class _EnterButtonState extends State<_EnterButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final value = controller.value;

        return Transform.translate(
          offset: Offset(value * 3, 0),
          child: child,
        );
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF4F8FF7),
                  Color(0xFF2875E8),
                ],
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2875E8)
                      .withValues(alpha: .28),
                  blurRadius: 16,
                  offset: const Offset(0, 7),
                ),
              ],
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
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

// =====================================================================
// MATAHARI
// =====================================================================

class _AnimatedSun extends StatelessWidget {
  const _AnimatedSun();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 105,
      height: 105,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFFFCE4F),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFC94A)
                .withValues(alpha: .35),
            blurRadius: 35,
            spreadRadius: 12,
          ),
        ],
      ),
      child: const Center(
        child: Icon(
          Icons.sentiment_satisfied_alt_rounded,
          color: Color(0xFFFFF3BF),
          size: 55,
        ),
      ),
    );
  }
}

// =====================================================================
// AWAN
// =====================================================================

class _BigCloud extends StatelessWidget {
  const _BigCloud({
    this.scale = 1,
  });

  final double scale;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      alignment: Alignment.center,
      child: SizedBox(
        width: 220,
        height: 100,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: 20,
              right: 20,
              bottom: 10,
              child: Container(
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .92),
                  borderRadius:
                      BorderRadius.circular(30),
                ),
              ),
            ),
            Positioned(
              left: 35,
              bottom: 25,
              child: _CloudCircle(
                size: 58,
              ),
            ),
            Positioned(
              left: 78,
              bottom: 38,
              child: _CloudCircle(
                size: 72,
              ),
            ),
            Positioned(
              right: 35,
              bottom: 27,
              child: _CloudCircle(
                size: 56,
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
        color: Colors.white.withValues(alpha: .94),
      ),
    );
  }
}

// =====================================================================
// SPARKLE
// =====================================================================

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

// =====================================================================
// LANDSCAPE
// =====================================================================

class _SplashLandscapePainter extends CustomPainter {
  const _SplashLandscapePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    // Bukit belakang
    paint.color = const Color(0xFF9BDF8A);

    final backHill = Path()
      ..moveTo(0, size.height * .82)
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
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(backHill, paint);

    // Bukit depan
    paint.color = const Color(0xFF68C96B);

    final frontHill = Path()
      ..moveTo(0, size.height * .89)
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
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(frontHill, paint);

    // Pohon kiri
    _drawTree(
      canvas,
      Offset(
        25,
        size.height * .83,
      ),
      1.0,
    );

    // Pohon kanan
    _drawTree(
      canvas,
      Offset(
        size.width - 25,
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

    // Batang
    paint.color = const Color(0xFF8A542F);

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
        Radius.circular(10 * scale),
      ),
      paint,
    );

    // Daun
    paint.color = const Color(0xFF45A95B);

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

    paint.color = const Color(0xFF6FD36D);

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