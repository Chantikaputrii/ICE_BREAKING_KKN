import 'package:flutter/material.dart';

import 'pages/home_page.dart';

class BelajarCeriaApp extends StatelessWidget {
  const BelajarCeriaApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Belajar Ceria',

      theme: ThemeData(
        useMaterial3: true,

        fontFamily: 'Trebuchet MS',

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4F8FF7),
          brightness: Brightness.light,
        ),

        scaffoldBackgroundColor:
            const Color(0xFFEAF8FF),

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          foregroundColor: Color(0xFF243B5A),
        ),

        inputDecorationTheme:
            InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.all(
              Radius.circular(18),
            ),
            borderSide: BorderSide.none,
          ),
        ),
      ),

      home: const HomePage(),
    );
  }
}