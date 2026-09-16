import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with TickerProviderStateMixin {
  late final AnimationController _cloudController;
  late final AnimationController _sunController;

  @override
  void initState() {
    super.initState();

    // Controller untuk animasi awan berjalan (loop terus menerus)
    _cloudController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 22),
    )..repeat();

    // Controller untuk animasi matahari bergerak lucu (membal/wobble)
    _sunController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _cloudController.dispose();
    _sunController.dispose();
    super.dispose();
  }

  void _goToDashboard(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background utama
          Image.asset(
            'assets/Splash Screen.jpeg',
            fit: BoxFit.cover,
          ),

          // Animasi Matahari Bergerak Lucu (Membal & Berotasi Sedikit)
          Positioned(
            top: 30,
            left: 0,
            right: 0,
            child: Align(
              alignment: const Alignment(0.15, 0),
              child: AnimatedBuilder(
                animation: _sunController,
                builder: (context, child) {
                  final bounce =
                      math.sin(_sunController.value * math.pi) * 8;
                  final rotate =
                      math.sin(_sunController.value * math.pi) * 0.05;

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
                  width: 170,
                  height: 170,
                ),
              ),
            ),
          ),

          // Animasi Awan — jalan dari KANAN ke KIRI. Semua awan
          // dikunci di jalur atas tipis (top: 5-45) supaya tidak
          // pernah turun nabrak teks/kartu di tengah. Jumlahnya
          // diduplikat jadi 6 dengan phase berbeda-beda supaya
          // yang muncul di layar selalu banyak, gak jarang-jarang.
          AnimatedBuilder(
            animation: _cloudController,
            builder: (context, child) {
              final screenWidth = MediaQuery.of(context).size.width;

              double pathX(double phase, double extra) {
                final t = (_cloudController.value + phase) % 1.0;
                final range = screenWidth + extra * 2;
                return (screenWidth + extra) - t * range;
              }

              Widget cloud(String asset, double width, double top,
                      double phase) =>
                  Positioned(
                    top: top,
                    left: pathX(phase, width * .8),
                    child: Image.asset(asset, width: width),
                  );

              return Stack(
                children: [
                  cloud('assets/AWAN 1.png', 240, 15, 0.00),
                  cloud('assets/AWAN 2.png', 200, 40, 0.16),
                  cloud('assets/AWAN 3.png', 220, 25, 0.33),
                  cloud('assets/AWAN 1.png', 190, 5, 0.50),
                  cloud('assets/AWAN 2.png', 260, 45, 0.66),
                  cloud('assets/AWAN 3.png', 210, 20, 0.83),
                ],
              );
            },
          ),

          // Tombol Masuk Dashboard
          Positioned(
            right: 20,
            bottom: 24,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _goToDashboard(context),
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4F8FF7), Color(0xFF2875E8)],
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2875E8).withValues(alpha: .35),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Masuk Dashboard',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}