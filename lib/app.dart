import 'package:flutter/material.dart';

import 'pages/home_page.dart';

class BelajarCeriaApp extends StatelessWidget {
  const BelajarCeriaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Belajar Ceria',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4F7DF3),
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F8FF),
      ),
      home: const HomePage(),
    );
  }
}

// =====================================================
// BANK SOAL KELAS 1 - 6
// =====================================================
