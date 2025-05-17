import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workpermit/screens/login_screen.dart';

void main() {
  testWidgets('Login screen UI loads', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: LoginScreen(setLocale: (_) {})));

    expect(find.textContaining('Login'), findsWidgets);
    expect(find.byType(TextField), findsNWidgets(2)); // username + password
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
}
