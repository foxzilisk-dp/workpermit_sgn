import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../local_stores/local_store.dart';

class VerificationScreen extends StatefulWidget {
  final void Function(Locale) setLocale;
  const VerificationScreen({super.key, required this.setLocale});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final TextEditingController _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final localtext = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localtext.translate('2fa_title')),
        actions: [
          DropdownButton<Locale>(
            underline: const SizedBox(),
            icon: const Icon(Icons.language, color: Colors.white),
            onChanged: (locale) {
              if (locale != null) widget.setLocale(locale);
            },
            items: const [
              DropdownMenuItem(value: Locale('en'), child: Text('EN')),
              DropdownMenuItem(value: Locale('th'), child: Text('TH')),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              localtext.translate('enter_code'),
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _codeController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 4,
              decoration: InputDecoration(
                counterText: "",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                final code = _codeController.text.trim();
                final verified = await AuthService().verifyCode(code, context);
                if (verified) {
                  Navigator.pushReplacementNamed(context, '/dashboard');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(localtext.translate('invalid_code'))),
                  );
                }
              },
              child: Text(localtext.translate('verify')),
            ),
          ],
        ),
      ),
    );
  }
}
