import 'package:belajar_ceria/app.dart';
import 'package:belajar_ceria/pages/home_page.dart';
import 'package:belajar_ceria/pages/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'menampilkan splash screen Belajar Ceria',
    (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(
        const Size(1280, 800),
      );

      addTearDown(
        () => tester.binding.setSurfaceSize(null),
      );

      await tester.pumpWidget(
        const BelajarCeriaApp(),
      );

      await tester.pump();

      expect(
        find.byType(SplashPage),
        findsOneWidget,
      );

      expect(
        find.text('BELAJAR CERIA'),
        findsOneWidget,
      );

      expect(
        find.text('Masuk Dashboard'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'tombol splash dapat masuk ke dashboard',
    (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(
        const Size(1280, 800),
      );

      addTearDown(
        () => tester.binding.setSurfaceSize(null),
      );

      await tester.pumpWidget(
        const BelajarCeriaApp(),
      );

      await tester.pump();

      await tester.tap(
        find.text('Masuk Dashboard'),
      );

      await tester.pumpAndSettle();

      expect(
        find.byType(HomePage),
        findsOneWidget,
      );
    },
  );
}