// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:belajar_ceria/main.dart';

void main() {
  testWidgets('menampilkan beranda Belajar Ceria', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1280, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const BelajarCeriaApp());
    await tester.pumpAndSettle();

    expect(find.text('Yuk Belajar Sambil Bermain!'), findsOneWidget);
    expect(find.text('Kelas 1 SD'), findsOneWidget);
  });
}
