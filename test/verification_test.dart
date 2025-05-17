import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workpermit/screens/verification_screen.dart';

void main() {
  testWidgets('Verification screen loads and shows FAB',
      (WidgetTester tester) async {
    await tester
        .pumpWidget(MaterialApp(home: VerificationScreen(setLocale: (_) {})));
    expect(find.byIcon(Icons.language), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(4)); // 4-digit input
  });
}
