import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workpermit/screens/dashboard_screen.dart';

void main() {
  testWidgets('Dashboard displays visa status and notifications',
      (WidgetTester tester) async {
    await tester
        .pumpWidget(MaterialApp(home: DashboardScreen(setLocale: (_) {})));
    expect(find.textContaining('Visa'), findsOneWidget);
    expect(find.byType(Card), findsWidgets);
  });
}
