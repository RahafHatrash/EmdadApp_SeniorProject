import 'package:flutter_test/flutter_test.dart';

class LoginLogic {
  String? validateLogin(String email, String password) {
    if (email.isEmpty || password.isEmpty) {
      return 'email and password cannot be empty';
    }
    if (email == 'admin@gmail.com' && password == '1234') {
      return null;  // Success
    }
    return 'Invalid email or password';
  }
}

void main() {
  final loginLogic = LoginLogic();

  group('Login Validation Tests', () {
    test('Valid login credentials', () {
      final result = loginLogic.validateLogin('admin@gmail.com', '1234');
      expect(result, isNull);  // إذا كانت المدخلات صحيحة
    });

    test('Invalid login credentials', () {
      final result = loginLogic.validateLogin('admin', 'wrongpassword');
      expect(result, 'Invalid email or password');  // إذا كانت المدخلات خاطئة
    });

    test('Empty email', () {
      final result = loginLogic.validateLogin('', '1234');
      expect(result, 'email and password cannot be empty');  // إذا كان اسم المستخدم فارغًا
    });

    test('Empty password', () {
      final result = loginLogic.validateLogin('admin@gmail.com', '');
      expect(result, 'email and password cannot be empty');  // إذا كانت كلمة المرور فارغة
    });
  });
}
