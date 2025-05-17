import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fake_async/fake_async.dart';
import 'package:workpermit/services/auth_service.dart';

void main() {
  group('AuthService', () {
    setUp(() => SharedPreferences.setMockInitialValues({}));

    test('login stores session', () async {
      final auth = AuthService();
      final result = await auth.login();
      final prefs = await SharedPreferences.getInstance();
      expect(result, true);
      expect(prefs.getBool('isLoggedIn'), true);
    });

    test('verifyCode accepts 0000 only', () async {
      final auth = AuthService();
      expect(await auth.verifyCode('0000'), true);
      expect(await auth.verifyCode('9999'), false);
    });

    test('logout clears session', () async {
      final auth = AuthService();
      await auth.login();
      await auth.logout();
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('isLoggedIn'), null);
    });

    test('auto logout after 30 minutes', () {
      fakeAsync((async) {
        final auth = AuthService();
        auth.login().then((_) => auth.verifyCode('0000'));
        async.elapse(const Duration(minutes: 31));
        SharedPreferences.getInstance().then((prefs) {
          expect(prefs.getBool('isLoggedIn'), null);
          expect(auth.isLoggedIn, false);
        });
      });
    });
  });
}
