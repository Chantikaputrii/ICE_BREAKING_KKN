import 'package:flutter/material.dart';

import 'quiz_page.dart';
import 'material_page.dart';
import 'ranking_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  int _score = 240;

  void _openQuiz(int grade) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => QuizPage(
          grade: grade,
          onFinished: (score) {
            setState(() {
              _score += score;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      _HomeContent(
        score: _score,
        onGradeSelected: _openQuiz,
      ),
      const LearningMaterialPage(),
      const RankingPage(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FB),
      body: pages[_selectedIndex],

      // Kalau ingin PERSIS seperti screenshot,
      // bottom navigation jangan ditampilkan.
      //
      // Kalau tetap ingin navigasi Materi/Peringkat,
      // hapus komentar di bawah:
      //
      // bottomNavigationBar: _AnimatedNavBar(
      //   selectedIndex: _selectedIndex,
      //   onSelected: (index) {
      //     setState(() => _selectedIndex = index);
      //   },
      // ),
    );
  }
}

// ============================================================
// HOME
// ============================================================

class _HomeContent extends StatelessWidget {
  const _HomeContent({
    required this.score,
    required this.onGradeSelected,
  });

  final int score;
  final ValueChanged<int> onGradeSelected;

  static const grades = [
    _GradeInfo(
      grade: 1,
      icon: Icons.rocket_launch_rounded,
      iconColor: Color(0xFFFF7B55),
      status: '3 dari 6 bintang',
    ),
    _GradeInfo(
      grade: 2,
      icon: Icons.location_on_rounded,
      iconColor: Color(0xFFE95786),
      status: '5 dari 6 bintang',
    ),
    _GradeInfo(
      grade: 3,
      icon: Icons.hub_rounded,
      iconColor: Color(0xFF776EEA),
      status: '2 dari 6 bintang',
    ),
    _GradeInfo(
      grade: 4,
      icon: Icons.auto_awesome_rounded,
      iconColor: Color(0xFF6D63D9),
      status: 'Belum mulai',
    ),
    _GradeInfo(
      grade: 5,
      icon: Icons.lightbulb_rounded,
      iconColor: Color(0xFFFFA63D),
      status: 'Belum mulai',
    ),
    _GradeInfo(
      grade: 6,
      icon: Icons.emoji_events_rounded,
      iconColor: Color(0xFF35B88A),
      status: 'Belum mulai',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: Container(
            width: 480,
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
              maxHeight: constraints.maxHeight,
            ),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFAEA9EF),
                  Color(0xFF7D74DD),
                  Color(0xFF6259C7),
                ],
              ),
            ),
            child: Stack(
              children: [
                // Background decoration
                const _BackgroundDecoration(),

                SafeArea(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(
                      17,
                      24,
                      17,
                      24,
                    ),
                    children: [
                      // HEADER
                      _Header(
                        score: score,
                      ),

                      const SizedBox(height: 14),

                      // CHARACTER
                      const SizedBox(
                        height: 160,
                        child: Center(
                          child: _CuteCharacter(),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // MISSION
                      const _MissionCard(),

                      const SizedBox(height: 18),

                      // TITLE
                      const Text(
                        'Pilih kelasmu',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // GRADES
                      ...grades.take(3).map(
                        (grade) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _GradeTile(
                            info: grade,
                            onTap: () => onGradeSelected(grade.grade),
                          ),
                        ),
                      ),

                      const SizedBox(height: 4),

                      // DOWN BUTTON
                      const Center(
                        child: _DownButton(),
                      ),
                    ],
                  ),
                ),

                // THREE DOTS
                const Positioned(
                  right: 20,
                  top: 22,
                  child: Icon(
                    Icons.more_horiz_rounded,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ============================================================
// BACKGROUND
// ============================================================

class _BackgroundDecoration extends StatelessWidget {
  const _BackgroundDecoration();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Lingkaran kiri atas
        Positioned(
          left: -150,
          top: -120,
          child: Container(
            width: 440,
            height: 440,
            decoration: BoxDecoration(
              color: const Color(0xFFBDB9F3).withOpacity(.65),
              shape: BoxShape.circle,
            ),
          ),
        ),

        // Lingkaran kanan tengah
        Positioned(
          right: -140,
          top: 145,
          child: Container(
            width: 330,
            height: 330,
            decoration: BoxDecoration(
              color: const Color(0xFF443BAA).withOpacity(.65),
              shape: BoxShape.circle,
            ),
          ),
        ),

        // Lingkaran kanan bawah
        Positioned(
          right: -80,
          bottom: 90,
          child: Container(
            width: 270,
            height: 270,
            decoration: BoxDecoration(
              color: const Color(0xFF302873).withOpacity(.65),
              shape: BoxShape.circle,
            ),
          ),
        ),

        // Biru bawah kiri
        Positioned(
          left: -90,
          bottom: -100,
          child: Container(
            width: 380,
            height: 270,
            decoration: BoxDecoration(
              color: const Color(0xFF278DE0).withOpacity(.8),
              borderRadius: BorderRadius.circular(160),
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================
// HEADER
// ============================================================

class _Header extends StatelessWidget {
  const _Header({
    required this.score,
  });

  final int score;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Profile
        Container(
          width: 48,
          height: 48,
          decoration: const BoxDecoration(
            color: Color(0xFFF7F7FF),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.person_outline_rounded,
            color: Color(0xFF554CC7),
            size: 27,
          ),
        ),

        const SizedBox(width: 10),

        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hai, Dito!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Kelas 3 SD',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        // Streak
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 11,
            vertical: 7,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.local_fire_department_rounded,
                color: Color(0xFFE17B27),
                size: 17,
              ),
              SizedBox(width: 4),
              Text(
                '5',
                style: TextStyle(
                  color: Color(0xFF4C4C55),
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 6),

        // Points
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 11,
            vertical: 7,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.star_border_rounded,
                color: Color(0xFF554CC7),
                size: 17,
              ),
              const SizedBox(width: 4),
              Text(
                '$score',
                style: const TextStyle(
                  color: Color(0xFF4C4C55),
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
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
// CHARACTER
// ============================================================

class _CuteCharacter extends StatelessWidget {
  const _CuteCharacter();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 150,
      child: CustomPaint(
        painter: _CharacterPainter(),
      ),
    );
  }
}

class _CharacterPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;

    // Shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(.12);

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX, 136),
        width: 48,
        height: 9,
      ),
      shadowPaint,
    );

    // Legs
    final legPaint = Paint()
      ..color = const Color(0xFFEF594C)
      ..strokeWidth = 9
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(centerX - 10, 103),
      Offset(centerX - 20, 128),
      legPaint,
    );

    canvas.drawLine(
      Offset(centerX + 10, 103),
      Offset(centerX + 20, 128),
      legPaint,
    );

    // Shoes
    final shoePaint = Paint()
      ..color = Colors.white;

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX - 22, 129),
        width: 20,
        height: 9,
      ),
      shoePaint,
    );

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX + 22, 129),
        width: 20,
        height: 9,
      ),
      shoePaint,
    );

    // Body
    final bodyPaint = Paint()
      ..color = Colors.white;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(centerX, 89),
          width: 43,
          height: 48,
        ),
        const Radius.circular(20),
      ),
      bodyPaint,
    );

    // Tie
    final tiePaint = Paint()
      ..color = const Color(0xFFE84848);

    final tiePath = Path()
      ..moveTo(centerX, 78)
      ..lineTo(centerX + 7, 88)
      ..lineTo(centerX, 102)
      ..lineTo(centerX - 7, 88)
      ..close();

    canvas.drawPath(tiePath, tiePaint);

    // Arms
    final armPaint = Paint()
      ..color = const Color(0xFFEF594C)
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(centerX - 19, 91),
      Offset(centerX - 29, 111),
      armPaint,
    );

    canvas.drawLine(
      Offset(centerX + 19, 91),
      Offset(centerX + 29, 111),
      armPaint,
    );

    // Neck
    final skinPaint = Paint()
      ..color = const Color(0xFFFFC982);

    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(centerX, 67),
        width: 13,
        height: 13,
      ),
      skinPaint,
    );

    // Head
    canvas.drawCircle(
      Offset(centerX, 55),
      22,
      skinPaint,
    );

    // Hair
    final hairPaint = Paint()
      ..color = const Color(0xFF2F2D32);

    final hairPath = Path()
      ..moveTo(centerX - 20, 51)
      ..quadraticBezierTo(
        centerX - 20,
        30,
        centerX,
        31,
      )
      ..quadraticBezierTo(
        centerX + 21,
        29,
        centerX + 21,
        51,
      )
      ..lineTo(centerX + 14, 43)
      ..lineTo(centerX + 7, 48)
      ..lineTo(centerX, 42)
      ..lineTo(centerX - 8, 48)
      ..lineTo(centerX - 15, 43)
      ..close();

    canvas.drawPath(hairPath, hairPaint);

    // Eyes
    final eyePaint = Paint()
      ..color = const Color(0xFF2F2D32);

    canvas.drawCircle(
      Offset(centerX - 8, 56),
      2.5,
      eyePaint,
    );

    canvas.drawCircle(
      Offset(centerX + 8, 56),
      2.5,
      eyePaint,
    );

    // Smile
    final smilePaint = Paint()
      ..color = const Color(0xFF2F2D32)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;

    final smile = Path()
      ..moveTo(centerX - 7, 63)
      ..quadraticBezierTo(
        centerX,
        70,
        centerX + 7,
        63,
      );

    canvas.drawPath(smile, smilePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

// ============================================================
// MISSION
// ============================================================

class _MissionCard extends StatelessWidget {
  const _MissionCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.90),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Misi hari ini',
            style: TextStyle(
              color: Color(0xFF20202A),
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 4),

          const Text(
            'Selesaikan 3 soal dan dapatkan bintang emas!',
            style: TextStyle(
              color: Color(0xFF52525D),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 14),

          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: 2 / 3,
              minHeight: 9,
              backgroundColor: const Color(0xFFE8E7F5),
              valueColor: const AlwaysStoppedAnimation(
                Color(0xFF746BE1),
              ),
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            '2 dari 3 selesai',
            style: TextStyle(
              color: Color(0xFF555562),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// GRADE
// ============================================================

class _GradeInfo {
  const _GradeInfo({
    required this.grade,
    required this.icon,
    required this.iconColor,
    required this.status,
  });

  final int grade;
  final IconData icon;
  final Color iconColor;
  final String status;
}

class _GradeTile extends StatefulWidget {
  const _GradeTile({
    required this.info,
    required this.onTap,
  });

  final _GradeInfo info;
  final VoidCallback onTap;

  @override
  State<_GradeTile> createState() => _GradeTileState();
}

class _GradeTileState extends State<_GradeTile> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
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
        scale: pressed ? .97 : 1,
        duration: const Duration(milliseconds: 100),
        child: Container(
          height: 80,
          padding: const EdgeInsets.symmetric(
            horizontal: 17,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.91),
            borderRadius: BorderRadius.circular(21),
          ),
          child: Row(
            children: [
              // Icon circle
              Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  color: widget.info.iconColor.withOpacity(.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.info.icon,
                  color: widget.info.iconColor,
                  size: 28,
                ),
              ),

              const SizedBox(width: 15),

              // Text
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kelas ${widget.info.grade}',
                      style: const TextStyle(
                        color: Color(0xFF20202A),
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.info.status,
                      style: const TextStyle(
                        color: Color(0xFF555562),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFF888891),
                size: 26,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// DOWN BUTTON
// ============================================================

class _DownButton extends StatelessWidget {
  const _DownButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: Color(0xFF555562),
        size: 28,
      ),
    );
  }
}

// ============================================================
// OPTIONAL BOTTOM NAVIGATION
// ============================================================

class _AnimatedNavBar extends StatelessWidget {
  const _AnimatedNavBar({
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    const items = [
      (
        icon: Icons.home_rounded,
        label: 'Beranda',
      ),
      (
        icon: Icons.menu_book_rounded,
        label: 'Materi',
      ),
      (
        icon: Icons.emoji_events_rounded,
        label: 'Peringkat',
      ),
    ];

    return Container(
      padding: const EdgeInsets.only(
        top: 8,
        bottom: 8,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          items.length,
          (index) {
            final selected = selectedIndex == index;

            return GestureDetector(
              onTap: () => onSelected(index),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    items[index].icon,
                    size: 24,
                    color: selected
                        ? const Color(0xFF7067DC)
                        : const Color(0xFF9EA0AA),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    items[index].label,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: selected
                          ? const Color(0xFF7067DC)
                          : const Color(0xFF9EA0AA),
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