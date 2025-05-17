import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  bool _isLoggedIn = false;
  Timer? _logoutTimer;

  bool get isLoggedIn => _isLoggedIn;

  Future<void> checkPersistedSession(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final hasSession = prefs.getBool('isLoggedIn') ?? false;
    if (hasSession) {
      _isLoggedIn = true;
      _startSessionTimer(context);
      Navigator.pushReplacementNamed(context, '/dashboard');
    }
  }

  Future<bool> login() async {
    _isLoggedIn = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    return true;
  }

  Future<bool> verifyCode(String code, [BuildContext? context]) async {
    if (code == '0000') {
      _startSessionTimer(context);
      return true;
    }
    return false;
  }

  void _startSessionTimer([BuildContext? context]) {
    _logoutTimer?.cancel();
    _logoutTimer = Timer(const Duration(minutes: 30), () {
      logout(context);
    });
  }

  Future<void> logout([BuildContext? context, bool showPopup = false]) async {
    _isLoggedIn = false;
    _logoutTimer?.cancel();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');

    if (showPopup && context != null && context.mounted) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Session Expired'),
          content: const Text('You have been logged out due to inactivity.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else if (context != null) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

// For testing only: expose logout timer
  Timer? get logoutTimer => _logoutTimer;
}
