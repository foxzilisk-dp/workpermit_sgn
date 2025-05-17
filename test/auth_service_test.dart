import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fake_async/fake_async.dart';
import 'package:workpermit/services/auth_service.dart';

void main() {
  group('AuthService Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('login stores session in SharedPreferences', () async {
      final auth = AuthService();
      await auth.login();
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('isLoggedIn'), true);
      expect(auth.isLoggedIn, true);
    });

    test('verifyCode accepts only "0000"', () async {
      final auth = AuthService();
      expect(await auth.verifyCode('0000'), true);
      expect(await auth.verifyCode('1234'), false);
    });

    test('logout clears session', () async {
      final auth = AuthService();
      await auth.login();
      await auth.logout(); // No BuildContext required
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('isLoggedIn'), isNull);
      expect(auth.isLoggedIn, false);
    });

    test('auto logout clears session after 30 minutes', () {
      fakeAsync((async) {
        final auth = AuthService();
        auth.login().then((_) {
          auth.verifyCode('0000'); // No context required
          async.elapse(const Duration(minutes: 30, seconds: 1));
          SharedPreferences.getInstance().then((prefs) {
            expect(prefs.getBool('isLoggedIn'), isNull);
            expect(auth.isLoggedIn, false);
          });
        });
      });
    });
  });
}
