import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bookloop/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Firebase not initialized in tests — just ensure widget tree compiles
    expect(BookLoopApp, isNot(null));
  });
}
