import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'local_stores/local_store.dart';
import 'screens/login_screen.dart';
import 'screens/verification_screen.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en');

  // Allow dynamic locale switching from any screen
  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('th'),
      ],
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(setLocale: setLocale),
        '/verify': (context) => VerificationScreen(setLocale: setLocale),
        '/main': (context) => MainScreen(setLocale: setLocale),
      },
    );
  }
}
