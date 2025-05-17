import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'local_stores/local_store.dart';
import 'screens/login_screen.dart';
import 'screens/verification_screen.dart';
import 'screens/dashboard_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en');

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      localeResolutionCallback: (locale, supportedLocales) {
        return supportedLocales.firstWhere(
          (supported) => supported.languageCode == locale?.languageCode,
          orElse: () => supportedLocales.first,
        );
      },
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(setLocale: setLocale),
        '/verify': (context) => VerificationScreen(setLocale: setLocale),
        '/dashboard': (context) => DashboardScreen(setLocale: setLocale),
      },
    );
  }
}
