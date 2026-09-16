import 'package:flutter/material.dart';

import 'pages/splash_page.dart';

class BelajarCeriaApp extends StatelessWidget {
  const BelajarCeriaApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF4B7BEC);
    const dark = Color(0xFF283B63);
    const page = Color(0xFFF4FBFF);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Belajar Ceria',

      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Trebuchet MS',
        scaffoldBackgroundColor: page,

        // ============================================================
        // COLOR SCHEME
        // ============================================================

        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          brightness: Brightness.light,
        ).copyWith(
          primary: primary,
          onPrimary: Colors.white,
          secondary: const Color(0xFFFFB84D),
          onSecondary: Colors.white,
          tertiary: const Color(0xFF55C98A),
          onTertiary: Colors.white,
          surface: Colors.white,
          onSurface: dark,
        ),

        // ============================================================
        // APP BAR
        // ============================================================

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          foregroundColor: dark,
          centerTitle: false,

          titleTextStyle: TextStyle(
            color: dark,
            fontSize: 21,
            fontWeight: FontWeight.w900,
            fontFamily: 'Trebuchet MS',
          ),
        ),

        // ============================================================
        // CARD
        // ============================================================

        cardTheme: const CardThemeData(
          color: Colors.white,
          elevation: 0,
          margin: EdgeInsets.zero,
          surfaceTintColor: Colors.transparent,
        ),

        // ============================================================
        // INPUT TEXT FIELD
        // ============================================================

        inputDecorationTheme:
            InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,

          contentPadding:
              const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 17,
          ),

          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(18),
            borderSide:
                BorderSide.none,
          ),

          enabledBorder:
              OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(18),
            borderSide:
                const BorderSide(
              color: Color(0xFFDCEAF6),
              width: 1.2,
            ),
          ),

          focusedBorder:
              OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(18),
            borderSide:
                const BorderSide(
              color: primary,
              width: 2,
            ),
          ),

          errorBorder:
              OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(18),
            borderSide:
                const BorderSide(
              color: Color(0xFFFF8A9B),
              width: 1.5,
            ),
          ),

          focusedErrorBorder:
              OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(18),
            borderSide:
                const BorderSide(
              color: Color(0xFFFF6680),
              width: 2,
            ),
          ),

          hintStyle:
              const TextStyle(
            color: Color(0xFF9AA9B8),
            fontWeight:
                FontWeight.w600,
          ),

          labelStyle:
              const TextStyle(
            color: Color(0xFF65788D),
            fontWeight:
                FontWeight.w700,
          ),
        ),

        // ============================================================
        // FILLED BUTTON
        // ============================================================

        filledButtonTheme:
            FilledButtonThemeData(
          style:
              FilledButton.styleFrom(
            backgroundColor:
                primary,
            foregroundColor:
                Colors.white,

            elevation: 3,

            shadowColor:
                primary.withOpacity(.25),

            minimumSize:
                const Size(0, 52),

            padding:
                const EdgeInsets
                    .symmetric(
              horizontal: 24,
              vertical: 14,
            ),

            shape:
                RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(
                17,
              ),
            ),

            textStyle:
                const TextStyle(
              fontWeight:
                  FontWeight.w900,
              fontSize: 15,
            ),
          ),
        ),

        // ============================================================
        // ELEVATED BUTTON
        // ============================================================

        elevatedButtonTheme:
            ElevatedButtonThemeData(
          style:
              ElevatedButton.styleFrom(
            backgroundColor:
                primary,
            foregroundColor:
                Colors.white,

            elevation: 3,

            shadowColor:
                primary.withOpacity(.22),

            minimumSize:
                const Size(0, 52),

            shape:
                RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(
                17,
              ),
            ),

            textStyle:
                const TextStyle(
              fontWeight:
                  FontWeight.w900,
            ),
          ),
        ),

        // ============================================================
        // OUTLINED BUTTON
        // ============================================================

        outlinedButtonTheme:
            OutlinedButtonThemeData(
          style:
              OutlinedButton.styleFrom(
            foregroundColor:
                primary,

            side:
                const BorderSide(
              color: Color(0xFFBFD4F4),
              width: 1.5,
            ),

            minimumSize:
                const Size(0, 50),

            shape:
                RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(
                17,
              ),
            ),

            textStyle:
                const TextStyle(
              fontWeight:
                  FontWeight.w900,
            ),
          ),
        ),

        // ============================================================
        // TEXT BUTTON
        // ============================================================

        textButtonTheme:
            TextButtonThemeData(
          style:
              TextButton.styleFrom(
            foregroundColor:
                primary,

            textStyle:
                const TextStyle(
              fontWeight:
                  FontWeight.w800,
            ),
          ),
        ),

        // ============================================================
        // CHIP
        // ============================================================

        chipTheme:
            ChipThemeData(
          backgroundColor:
              const Color(0xFFEAF3FF),

          selectedColor:
              const Color(0xFFD9E8FF),

          checkmarkColor:
              primary,

          side:
              BorderSide.none,

          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              14,
            ),
          ),

          labelStyle:
              const TextStyle(
            color: dark,
            fontWeight:
                FontWeight.w800,
          ),
        ),

        // ============================================================
        // NAVIGATION BAR
        // ============================================================

        navigationBarTheme:
            NavigationBarThemeData(
          backgroundColor:
              Colors.white,

          elevation: 8,

          shadowColor:
              const Color(
            0x25000000,
          ),

          indicatorColor:
              const Color(
            0xFFDCE9FF,
          ),

          height: 72,

          labelTextStyle:
              MaterialStateProperty.all(
            const TextStyle(
              color: dark,
              fontWeight:
                  FontWeight.w800,
              fontSize: 12,
            ),
          ),

          iconTheme:
              MaterialStateProperty.all(
            const IconThemeData(
              color: Color(
                0xFF64758A,
              ),
              size: 24,
            ),
          ),
        ),

        // ============================================================
        // DIALOG
        // ============================================================

        dialogTheme:
            const DialogThemeData(
          backgroundColor:
              Colors.white,

          surfaceTintColor:
              Colors.transparent,

          elevation: 12,

          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.all(
              Radius.circular(28),
            ),
          ),

          titleTextStyle:
              TextStyle(
            color: dark,
            fontSize: 22,
            fontWeight:
                FontWeight.w900,
            fontFamily:
                'Trebuchet MS',
          ),

          contentTextStyle:
              TextStyle(
            color:
                Color(0xFF65788D),
            fontSize: 15,
            height: 1.5,
            fontWeight:
                FontWeight.w600,
            fontFamily:
                'Trebuchet MS',
          ),
        ),

        // ============================================================
        // SNACKBAR
        // ============================================================

        snackBarTheme:
            SnackBarThemeData(
          behavior:
              SnackBarBehavior.floating,

          backgroundColor:
              dark,

          elevation: 8,

          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              16,
            ),
          ),

          contentTextStyle:
              const TextStyle(
            color: Colors.white,
            fontWeight:
                FontWeight.w700,
          ),
        ),

        // ============================================================
        // PROGRESS INDICATOR
        // ============================================================

        progressIndicatorTheme:
            const ProgressIndicatorThemeData(
          color: primary,
          linearTrackColor:
              Color(0xFFDDEBFA),
        ),

        // ============================================================
        // SCROLLBAR
        // ============================================================

        scrollbarTheme:
            ScrollbarThemeData(
          thumbColor:
              MaterialStateProperty.all(
            const Color(0xFF8BB8F7),
          ),

          trackColor:
              MaterialStateProperty.all(
            const Color(0xFFE8F2FF),
          ),

          radius:
              const Radius.circular(
            20,
          ),

          thickness:
              MaterialStateProperty.all(
            7,
          ),
        ),
      ),

      // ==============================================================
      // SPLASH SCREEN
      // ==============================================================

      home: const SplashPage(),
    );
  }
}