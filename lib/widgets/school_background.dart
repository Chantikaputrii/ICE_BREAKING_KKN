import 'dart:math' as math;

import 'package:flutter/material.dart';

class SchoolBackground extends StatefulWidget {
  const SchoolBackground({
    super.key,
    this.child,
    this.showSchoolIllustrations = true,
    this.compact = false,
  });

  final Widget? child;
  final bool showSchoolIllustrations;
  final bool compact;

  @override
  State<SchoolBackground> createState() =>
      _SchoolBackgroundState();
}

class _SchoolBackgroundState
    extends State<SchoolBackground>
    with TickerProviderStateMixin {
  late final AnimationController
      _cloudController;

  late final AnimationController
      _sunController;

  late final AnimationController
      _birdController;

  @override
  void initState() {
    super.initState();

    _cloudController =
        AnimationController(
      vsync: this,
      duration:
          const Duration(seconds: 22),
    )..repeat();

    _sunController =
        AnimationController(
      vsync: this,
      duration:
          const Duration(seconds: 18),
    )..repeat();

    // Burung dibuat jauh lebih lambat.
    _birdController =
        AnimationController(
      vsync: this,
      duration:
          const Duration(seconds: 32),
    )..repeat();
  }

  @override
  void dispose() {
    _cloudController.dispose();
    _sunController.dispose();
    _birdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (
        context,
        constraints,
      ) {
        final width =
            constraints.maxWidth;

        final grassHeight =
            widget.compact
                ? 85.0
                : 125.0;

        return DecoratedBox(
          decoration:
              const BoxDecoration(
            gradient:
                LinearGradient(
              begin:
                  Alignment.topCenter,
              end:
                  Alignment.bottomCenter,
              colors: [
                Color(0xFFBDEBFF),
                Color(0xFFEAF8FF),
                Color(0xFFFFFBEA),
              ],
              stops: [
                0,
                .62,
                1,
              ],
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // =========================
              // MATAHARI
              // =========================
              Positioned(
                top: 28,
                right:
                    width < 700
                        ? 25
                        : 70,
                child:
                    AnimatedBuilder(
                  animation:
                      _sunController,
                  builder:
                      (
                    context,
                    child,
                  ) {
                    return Transform.rotate(
                      angle:
                          _sunController
                                  .value *
                              math.pi *
                              2,
                      child:
                          const _Sun(),
                    );
                  },
                ),
              ),

              // =========================
              // AWAN
              // =========================
              AnimatedBuilder(
                animation:
                    _cloudController,
                builder:
                    (
                  context,
                  child,
                ) {
                  final t =
                      _cloudController
                          .value;

                  return Stack(
                    children: [
                      Positioned(
                        top: 65,
                        left:
                            -150 +
                                (width +
                                        300) *
                                    t,
                        child:
                            const _Cloud(
                          scale: 1,
                        ),
                      ),
                      Positioned(
                        top: 160,
                        left:
                            40 +
                                (width +
                                        250) *
                                    ((t +
                                            .38) %
                                        1),
                        child:
                            const _Cloud(
                          scale: .72,
                        ),
                      ),
                      Positioned(
                        top: 255,
                        left:
                            -170 +
                                (width +
                                        340) *
                                    ((t +
                                            .72) %
                                        1),
                        child:
                            const _Cloud(
                          scale: .82,
                        ),
                      ),
                    ],
                  );
                },
              ),

              // =========================
              // BURUNG LAMBAT
              // =========================
              AnimatedBuilder(
                animation:
                    _birdController,
                builder:
                    (
                  context,
                  child,
                ) {
                  final t =
                      _birdController
                          .value;

                  return Stack(
                    children: [
                      Positioned(
                        top:
                            115 +
                                math.sin(
                                      t *
                                          math.pi *
                                          2,
                                    ) *
                                    8,
                        left:
                            -90 +
                                (width +
                                        180) *
                                    t,
                        child:
                            const _Bird(
                          scale: .85,
                        ),
                      ),
                      Positioned(
                        top:
                            205 +
                                math.sin(
                                      (t +
                                              .4) *
                                          math.pi *
                                          2,
                                    ) *
                                    6,
                        left:
                            -120 +
                                (width +
                                        240) *
                                    ((t +
                                            .55) %
                                        1),
                        child:
                            const _Bird(
                          scale: .58,
                        ),
                      ),
                    ],
                  );
                },
              ),

              // =========================
              // BINTANG
              // =========================
              const Positioned(
                left: 50,
                top: 190,
                child: _Star(),
              ),

              const Positioned(
                left: 145,
                top: 310,
                child: _Star(
                  size: 12,
                ),
              ),

              const Positioned(
                right: 120,
                top: 300,
                child: _Star(
                  size: 14,
                ),
              ),

              // =========================
              // POHON BESAR
              // =========================
              if (widget.showSchoolIllustrations &&
                  width >= 900) ...[
                Positioned(
                  left: 5,
                  bottom:
                      grassHeight - 12,
                  child: Opacity(
                    opacity: .96,
                    child:
                        Image.asset(
                      'assets/Gambar pohon 2.jpeg',
                      width: 280,
                      height: 285,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                Positioned(
                  right: 5,
                  bottom:
                      grassHeight - 10,
                  child: Opacity(
                    opacity: .96,
                    child:
                        Image.asset(
                      'assets/Gambar pohon 3.jpeg',
                      width: 285,
                      height: 295,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],

              // =========================
              // RUMPUT GELOMBANG
              // =========================
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: SizedBox(
                  height:
                      grassHeight,
                  child:
                      const _WavyGrass(),
                ),
              ),

              if (widget.child != null)
                widget.child!,
            ],
          ),
        );
      },
    );
  }
}

class _Sun extends StatelessWidget {
  const _Sun();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      decoration:
          BoxDecoration(
        shape: BoxShape.circle,
        color:
            const Color(0xFFFFC94A),
        boxShadow: [
          BoxShadow(
            color:
                const Color(
              0xFFFFC94A,
            ).withOpacity(.32),
            blurRadius: 24,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Stack(
        alignment:
            Alignment.center,
        children: [
          for (int i = 0;
              i < 8;
              i++)
            Transform.rotate(
              angle:
                  i *
                      math.pi /
                      4,
              child:
                  Align(
                alignment:
                    Alignment.topCenter,
                child:
                    Container(
                  width: 5,
                  height: 15,
                  margin:
                      const EdgeInsets
                          .only(
                    top: -8,
                  ),
                  decoration:
                      BoxDecoration(
                    color:
                        const Color(
                      0xFFFFC94A,
                    ),
                    borderRadius:
                        BorderRadius
                            .circular(
                      10,
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

class _Cloud extends StatelessWidget {
  const _Cloud({
    this.scale = 1,
  });

  final double scale;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      alignment:
          Alignment.center,
      child: SizedBox(
        width: 145,
        height: 70,
        child: Stack(
          alignment:
              Alignment.bottomCenter,
          children: [
            Positioned(
              left: 5,
              bottom: 8,
              child: _cloudCircle(
                45,
              ),
            ),
            Positioned(
              left: 42,
              bottom: 5,
              child: _cloudCircle(
                60,
              ),
            ),
            Positioned(
              left: 91,
              bottom: 10,
              child: _cloudCircle(
                42,
              ),
            ),
            Positioned(
              left: 20,
              bottom: 3,
              child:
                  Container(
                width: 105,
                height: 30,
                decoration:
                    BoxDecoration(
                  color: Colors.white
                      .withOpacity(.82),
                  borderRadius:
                      BorderRadius
                          .circular(
                    30,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cloudCircle(
    double size,
  ) {
    return Container(
      width: size,
      height: size,
      decoration:
          BoxDecoration(
        color: Colors.white
            .withOpacity(.82),
        shape: BoxShape.circle,
      ),
    );
  }
}

class _Bird extends StatelessWidget {
  const _Bird({
    this.scale = 1,
  });

  final double scale;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: CustomPaint(
        size:
            const Size(80, 45),
        painter:
            _BirdPainter(),
      ),
    );
  }
}

class _BirdPainter
    extends CustomPainter {
  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final paint = Paint()
      ..color =
          const Color(0xFF36566B)
      ..style =
          PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap =
          StrokeCap.round;

    final leftWing =
        Path()
          ..moveTo(4, 25)
          ..cubicTo(
            14,
            10,
            27,
            10,
            39,
            23,
          );

    final rightWing =
        Path()
          ..moveTo(39, 23)
          ..cubicTo(
            51,
            10,
            65,
            10,
            76,
            25,
          );

    canvas.drawPath(
      leftWing,
      paint,
    );

    canvas.drawPath(
      rightWing,
      paint,
    );

    final body =
        Paint()
          ..color =
              const Color(
            0xFF36566B,
          )
          ..style =
              PaintingStyle.fill;

    canvas.drawCircle(
      const Offset(39, 23),
      3.5,
      body,
    );
  }

  @override
  bool shouldRepaint(
    covariant CustomPainter oldDelegate,
  ) {
    return false;
  }
}

class _Star extends StatelessWidget {
  const _Star({
    this.size = 18,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.star_rounded,
      size: size,
      color:
          const Color(0xFFFFC94A),
    );
  }
}

class _WavyGrass
    extends StatelessWidget {
  const _WavyGrass();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter:
          _WavyGrassPainter(),
      child:
          const SizedBox.expand(),
    );
  }
}

class _WavyGrassPainter
    extends CustomPainter {
  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final grassPaint =
        Paint()
          ..color =
              const Color(
            0xFF67C96B,
          );

    final path =
        Path()
          ..moveTo(0, 35);

    final segment =
        size.width / 5;

    for (var i = 0; i < 5; i++) {
      final startX =
          i * segment;

      path.cubicTo(
        startX +
            segment * .25,
        5,
        startX +
            segment * .70,
        65,
        startX + segment,
        30,
      );
    }

    path
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
      path,
      grassPaint,
    );

    final lightPaint =
        Paint()
          ..color =
              const Color(
            0xFF8EDB76,
          );

    final smallPath =
        Path()
          ..moveTo(0, 58);

    for (var i = 0; i < 7; i++) {
      final x =
          i *
              (size.width /
                  7);

      smallPath.cubicTo(
        x + 20,
        40,
        x + 45,
        70,
        x +
            size.width /
                7,
        52,
      );
    }

    smallPath
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
      smallPath,
      lightPaint,
    );
  }

  @override
  bool shouldRepaint(
    covariant CustomPainter oldDelegate,
  ) {
    return false;
  }
}

class FloatingAsset
    extends StatelessWidget {
  const FloatingAsset({
    super.key,
    required this.asset,
    this.width = 130,
    this.height = 130,
  });

  final String asset;
  final double width;
  final double height;

  @override
  Widget build(
    BuildContext context,
  ) {
    return TweenAnimationBuilder<
        double>(
      tween: Tween(
        begin: -5,
        end: 5,
      ),
      duration:
          const Duration(seconds: 2),
      curve:
          Curves.easeInOut,
      builder:
          (
        context,
        value,
        child,
      ) {
        return Transform.translate(
          offset:
              Offset(0, value),
          child: child,
        );
      },
      child: Image.asset(
        asset,
        width: width,
        height: height,
        fit: BoxFit.contain,
      ),
    );
  }
}

class PressableCard
    extends StatefulWidget {
  const PressableCard({
    super.key,
    required this.child,
    required this.onTap,
  });

  final Widget child;
  final VoidCallback onTap;

  @override
  State<PressableCard> createState() =>
      _PressableCardState();
}

class _PressableCardState
    extends State<PressableCard> {
  bool pressed = false;

  @override
  Widget build(
    BuildContext context,
  ) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) {
        setState(() {
          pressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          pressed = false;
        });
      },
      onTapCancel: () {
        setState(() {
          pressed = false;
        });
      },
      child: AnimatedScale(
        scale:
            pressed ? .975 : 1,
        duration:
            const Duration(
          milliseconds: 120,
        ),
        child: widget.child,
      ),
    );
  }
}