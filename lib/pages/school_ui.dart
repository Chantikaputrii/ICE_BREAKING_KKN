import 'package:flutter/material.dart';

class SchoolColors {
  static const blue = Color(0xFF4E8DF7);
  static const darkBlue = Color(0xFF183153);
  static const yellow = Color(0xFFFFC857);
  static const orange = Color(0xFFFF9852);
  static const green = Color(0xFF50C878);
  static const pink = Color(0xFFFF719A);
  static const purple = Color(0xFF8A72E8);
  static const lightBlue = Color(0xFFEAF5FF);
  static const background = Color(0xFFF4FAFF);
}

class FloatingCloud extends StatefulWidget {
  const FloatingCloud({
    super.key,
    required this.left,
    required this.top,
    this.size = 70,
  });

  final double left;
  final double top;
  final double size;

  @override
  State<FloatingCloud> createState() => _FloatingCloudState();
}

class _FloatingCloudState extends State<FloatingCloud>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    animation = Tween<double>(
      begin: -8,
      end: 8,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (_, child) {
        return Positioned(
          left: widget.left,
          top: widget.top + animation.value,
          child: child!,
        );
      },
      child: Icon(
        Icons.cloud_rounded,
        size: widget.size,
        color: Colors.white.withOpacity(.9),
      ),
    );
  }
}

class FloatingStar extends StatefulWidget {
  const FloatingStar({
    super.key,
    required this.left,
    required this.top,
    this.size = 25,
  });

  final double left;
  final double top;
  final double size;

  @override
  State<FloatingStar> createState() => _FloatingStarState();
}

class _FloatingStarState extends State<FloatingStar>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    )..repeat(reverse: true);

    animation = Tween<double>(
      begin: .65,
      end: 1.2,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.left,
      top: widget.top,
      child: ScaleTransition(
        scale: animation,
        child: Icon(
          Icons.star_rounded,
          size: widget.size,
          color: SchoolColors.yellow,
        ),
      ),
    );
  }
}

class AnimatedAssetCharacter extends StatefulWidget {
  const AnimatedAssetCharacter({
    super.key,
    required this.asset,
    this.width = 180,
    this.height = 180,
    this.fit = BoxFit.contain,
  });

  final String asset;
  final double width;
  final double height;
  final BoxFit fit;

  @override
  State<AnimatedAssetCharacter> createState() =>
      _AnimatedAssetCharacterState();
}

class _AnimatedAssetCharacterState
    extends State<AnimatedAssetCharacter>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> floatAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    floatAnimation = Tween<double>(
      begin: -5,
      end: 5,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ),
    );
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
      builder: (_, child) {
        return Transform.translate(
          offset: Offset(0, floatAnimation.value),
          child: child,
        );
      },
      child: Image.asset(
        widget.asset,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        errorBuilder: (_, __, ___) {
          return Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.8),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Icon(
              Icons.person_rounded,
              size: 80,
              color: SchoolColors.blue,
            ),
          );
        },
      ),
    );
  }
}

class PressableCard extends StatefulWidget {
  const PressableCard({
    super.key,
    required this.child,
    required this.onTap,
    this.borderRadius = 24,
  });

  final Widget child;
  final VoidCallback onTap;
  final double borderRadius;

  @override
  State<PressableCard> createState() => _PressableCardState();
}

class _PressableCardState extends State<PressableCard> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => pressed = true),
      onTapUp: (_) => setState(() => pressed = false),
      onTapCancel: () => setState(() => pressed = false),
      child: AnimatedScale(
        scale: pressed ? .96 : 1,
        duration: const Duration(milliseconds: 110),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

class SchoolBackground extends StatelessWidget {
  const SchoolBackground({
    super.key,
    required this.child,
    this.showClouds = true,
  });

  final Widget child;
  final bool showClouds;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFDDF3FF),
                Color(0xFFF7FCFF),
                Color(0xFFEAF8EA),
              ],
            ),
          ),
        ),

        if (showClouds) ...[
          const FloatingCloud(
            left: -15,
            top: 65,
            size: 85,
          ),
          const FloatingCloud(
            left: 220,
            top: 110,
            size: 65,
          ),
          const FloatingCloud(
            left: 520,
            top: 55,
            size: 90,
          ),
          const FloatingCloud(
            left: 760,
            top: 140,
            size: 70,
          ),
        ],

        const FloatingStar(
          left: 45,
          top: 190,
          size: 20,
        ),

        const FloatingStar(
          left: 320,
          top: 75,
          size: 18,
        ),

        const FloatingStar(
          left: 650,
          top: 205,
          size: 22,
        ),

        Positioned(
          bottom: -40,
          left: -40,
          right: -40,
          child: Container(
            height: 130,
            decoration: BoxDecoration(
              color: const Color(0xFF8BD17C),
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ),

        child,
      ],
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon = Icons.school_rounded,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: SchoolColors.yellow,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(
            icon,
            color: SchoolColors.darkBlue,
            size: 27,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: SchoolColors.darkBlue,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF63758B),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}