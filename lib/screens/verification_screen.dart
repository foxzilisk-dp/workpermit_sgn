import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../local_stores/local_store.dart';

class VerificationScreen extends StatefulWidget {
  final void Function(Locale) setLocale;
  const VerificationScreen({super.key, required this.setLocale});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());
  Timer? _resendTimer;
  int _secondsRemaining = 90;
  String _expectedCode = '0000'; // default, will be overwritten

  @override
  void initState() {
    super.initState();
    _startTimer();
    _loadExpectedCode(); // load from mock JSON
  }

  // Load verification code from assets/mock/verification_code.json
  Future<void> _loadExpectedCode() async {
    final jsonStr =
        await rootBundle.loadString('assets/verification_code.json');
    final data = json.decode(jsonStr);
    setState(() {
      _expectedCode = data['code'];
    });
  }

  void _startTimer() {
    _resendTimer?.cancel();
    _secondsRemaining = 90;
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        timer.cancel();
      }
    });
  }

  // Called when user taps "Verify"
  void _submitCode() async {
    final code = _controllers.map((c) => c.text).join();
    if (code == _expectedCode) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text(AppLocalizations.of(context).translate('invalid_code'))),
      );
    }
  }

  // Called when user taps "Resend Code"
  void _onResendCode() async {
    for (var controller in _controllers) {
      controller.clear(); // Clear previous inputs
    }

    _startTimer(); // Restart timer
    await _loadExpectedCode(); // Reload code from JSON (simulate refresh)

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Verification code has been resent.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Blue icon in a bordered circle
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.blue, width: 2),
                ),
                child: const CircleAvatar(
                  radius: 40,
                  backgroundColor: Color(0xffbbdefb),
                  child:
                      Icon(Icons.email_outlined, size: 40, color: Colors.blue),
                ),
              ),
              const SizedBox(height: 24),

              Text(t.translate('enter_code'),
                  style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 4),
              Text(t.translate('login_hint'),
                  style: TextStyle(color: Colors.grey[600], fontSize: 13)),
              const SizedBox(height: 24),

              // 4 digit input boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (i) {
                  return SizedBox(
                    width: 48,
                    child: TextField(
                      controller: _controllers[i],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      onChanged: (val) {
                        if (val.isNotEmpty && i < 3) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                      decoration: InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),

              // Verify button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _submitCode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(t.translate('verify'),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18)),
                ),
              ),
              const SizedBox(height: 12),

              // Resend code button or countdown
              GestureDetector(
                onTap: _secondsRemaining == 0 ? _onResendCode : null,
                child: Text(
                  _secondsRemaining == 0
                      ? t.translate('resend')
                      : '${t.translate('resend')} (${_formatTime(_secondsRemaining)})',
                  style: TextStyle(
                    fontSize: 13,
                    color:
                        _secondsRemaining == 0 ? Colors.grey[800] : Colors.blue,
                    decoration: _secondsRemaining == 0
                        ? TextDecoration.underline
                        : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(1, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    for (var c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }
}
