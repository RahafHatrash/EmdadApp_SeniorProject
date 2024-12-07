import 'package:flutter_test/flutter_test.dart';

class SignupLogic {
  String? validateLogin(String name, String email, String phone,
      String password, String confirmedPassword) {
    if (email.isEmpty ||
        password.isEmpty ||
        name.isEmpty ||
        phone.isEmpty ||
        confirmedPassword.isEmpty) {
      return 'Text cannot be empty';
    }
    if (name == 'admin' &&
        email == 'admin@gmail.com' &&
        password == confirmedPassword &&
        phone == '123456') {
      return null; // Success
    }
    return 'Invalid Info';
  }
}

void main() {
  final signupLogic = SignupLogic();

  group('Signup Validation Tests', () {
    test('Valid signup credentials', () {
      final result = signupLogic.validateLogin(
          'admin', 'admin@gmail.com', '123456', '123456', '123456');
      expect(result, isNull); // إذا كانت المدخلات صحيحة
    });

    test('Invalid signup credentials', () {
      final result = signupLogic.validateLogin(
          'admin', 'wrongpassword', '123456', '123456', '123456');
      expect(result, 'Invalid Info'); // إذا كانت المدخلات خاطئة
    });

    test('Empty name', () {
      final result =
          signupLogic.validateLogin('', '1234', '123456', '123456', '123456');
      expect(result, 'Text cannot be empty'); // إذا كان اسم المستخدم فارغًا
    });

    test('Empty email', () {
      final result = signupLogic.validateLogin(
          'admin@gmail.com', '', '123456', '123456', '123456');
      expect(result, 'Text cannot be empty'); // إذا كان الايميل فارغا
    });

    test('Empty password', () {
      final result = signupLogic.validateLogin(
          'admin@gmail.com', '123456', '', '123456', '123456');
      expect(result, 'Text cannot be empty'); // إذا كانت كلمة المرور فارغة
    });
  });
}
