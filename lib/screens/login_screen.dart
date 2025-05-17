import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/auth_service.dart';
import 'package:workpermit/local_stores/local_store.dart';

class LoginScreen extends StatefulWidget {
  final void Function(Locale) setLocale;
  const LoginScreen({super.key, required this.setLocale});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Map<String, String> _mockUsers = {};

  @override
  void initState() {
    super.initState();
    _loadMockUsers();
    AuthService().checkPersistedSession(context);
  }

  // Load users from JSON file into a map
  Future<void> _loadMockUsers() async {
    final jsonString = await rootBundle.loadString('assets/users.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    setState(() {
      _mockUsers = jsonMap.map((key, value) => MapEntry(key, value.toString()));
    });
  }

  @override
  Widget build(BuildContext context) {
    final localtext = AppLocalizations.of(context); // Load localized strings
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.blue,
                  child: Text("LTR",
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    hintText: localtext.translate('username'),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: localtext.translate('password'),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () async {
                      final username = _usernameController.text.trim();
                      final password = _passwordController.text.trim();
                      // Validate login from mock users
                      if (_mockUsers[username] == password) {
                        Navigator.pushReplacementNamed(context, '/verify');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  localtext.translate('invalid_credentials'))),
                        );
                      }
                    },
                    child: Text(localtext.translate('login'),
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 12),
                Text(localtext.translate('login_hint'),
                    style: TextStyle(fontSize: 13, color: Colors.grey[900])),
                const SizedBox(height: 24),
                // Dropdown to switch language dynamically
                DropdownButton<Locale>(
                  value: Localizations.localeOf(context),
                  onChanged: (locale) {
                    if (locale != null) widget.setLocale(locale);
                  },
                  items: const [
                    DropdownMenuItem(
                        value: Locale('en'),
                        child: Text('English',
                            style: TextStyle(
                                fontSize: 13, color: Color(0xff212121)))),
                    DropdownMenuItem(
                        value: Locale('th'),
                        child: Text('ไทย',
                            style: TextStyle(
                                fontSize: 13, color: Color(0xff212121)))),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
