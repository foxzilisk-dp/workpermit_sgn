import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workpermit/screens/status_tracking_screen.dart';

void main() {
  testWidgets('Status tracking screen shows steps',
      (WidgetTester tester) async {
    await tester
        .pumpWidget(MaterialApp(home: StatusTrackingScreen(setLocale: (_) {})));
    expect(find.textContaining('Status'), findsWidgets);
    expect(find.byType(ListTile), findsWidgets);
  });
}
