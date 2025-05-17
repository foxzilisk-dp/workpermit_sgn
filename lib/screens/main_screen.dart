import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'status_tracking_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../local_stores/local_store.dart';

class MainScreen extends StatefulWidget {
  final void Function(Locale) setLocale;
  const MainScreen({super.key, required this.setLocale});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final localtext = AppLocalizations.of(context);

    final screens = [
      DashboardScreen(setLocale: widget.setLocale),
      StatusTrackingScreen(setLocale: widget.setLocale),
      // _buildProfilePage(localtext),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: localtext.translate('dashboard'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.timeline),
            label: localtext.translate('status_tracking'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: localtext.translate('profile'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (_) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.language, color: Colors.black),
                  title: const Text('English'),
                  onTap: () {
                    widget.setLocale(const Locale('en'));
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.language, color: Colors.black),
                  title: const Text('ไทย'),
                  onTap: () {
                    widget.setLocale(const Locale('th'));
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.language, color: Colors.white),
      ),
    );
  }

  Widget _buildProfilePage(AppLocalizations localtext) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.person, size: 64),
          const SizedBox(height: 16),
          Text(localtext.translate('username')),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _logout,
            child: Text(localtext.translate('logout')),
          ),
          SwitchListTile(
            title: Text(localtext.translate('notifications')),
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() => _notificationsEnabled = value);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }
}
