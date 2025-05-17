import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../local_stores/local_store.dart';

class DashboardScreen extends StatelessWidget {
  final void Function(Locale) setLocale;
  const DashboardScreen({super.key, required this.setLocale});

  @override
  Widget build(BuildContext context) {
    final localtext = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localtext.translate('dashboard')),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              AuthService().logout(context);
            },
            tooltip: localtext.translate('logout'),
          ),
          DropdownButton<Locale>(
            underline: const SizedBox(),
            icon: const Icon(Icons.language, color: Colors.white),
            onChanged: (locale) {
              if (locale != null) setLocale(locale);
            },
            items: const [
              DropdownMenuItem(value: Locale('en'), child: Text('EN')),
              DropdownMenuItem(value: Locale('th'), child: Text('TH')),
            ],
          ),
        ],
      ),
      body: Center(
        child: Text(
          localtext.translate('dashboard'),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
