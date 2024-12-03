import 'package:flutter_test/flutter_test.dart';

class FarmAddingLogic {
  String? validateLogin(String name, String location, String type, int size,
      int duration, int price) {
    if (name.isEmpty) {
      return 'Farm name cannot be empty';
    }
    if (location.isEmpty) {
      return 'Location cannot be empty';
    }
    if (type.isEmpty) {
      return 'Type cannot be empty';
    }
    if (size <= 0) {
      return 'Size must be greater than 0';
    }
    if (duration <= 0) {
      return 'Duration must be greater than 0';
    }
    if (price <= 0) {
      return 'Price must be greater than 0';
    }
    if (name == 'My Farm' &&
        location == 'Jada' &&
        type == 'Orange' &&
        size == 500 &&
        duration == 3 &&
        price == 50000) {
      return null; // Success
    }
    return 'Invalid information';
  }
}

void main() {
  final farmAddingLogic = FarmAddingLogic();

  group('Adding farm Validation Tests', () {
    test('Valid farm', () {
      final result = farmAddingLogic.validateLogin(
          'My Farm', 'Jada', 'Orange', 500, 3, 50000);
      expect(result, isNull); // If the input is correct
    });

    test('Invalid farm', () {
      final result =
          farmAddingLogic.validateLogin('My Farm', 'Jada', 'Orange', 500, 3, 0);
      expect(result, 'Price must be greater than 0'); // Price is 0
    });

    test('Empty name', () {
      final result =
          farmAddingLogic.validateLogin('', 'Jada', 'Orange', 500, 3, 50000);
      expect(result, 'Farm name cannot be empty'); // Name is empty
    });

    test('Empty location', () {
      final result =
          farmAddingLogic.validateLogin('My Farm', '', 'Orange', 500, 3, 50000);
      expect(result, 'Location cannot be empty'); // Location is empty
    });

    test('Empty type', () {
      final result =
          farmAddingLogic.validateLogin('My Farm', 'Jada', '', 500, 3, 50000);
      expect(result, 'Type cannot be empty'); // Type is empty
    });

    test('Invalid size', () {
      final result = farmAddingLogic.validateLogin(
          'My Farm', 'Jada', 'Orange', 0, 3, 50000);
      expect(result, 'Size must be greater than 0'); // Size is 0
    });

    test('Invalid duration', () {
      final result = farmAddingLogic.validateLogin(
          'My Farm', 'Jada', 'Orange', 500, 0, 50000);
      expect(result, 'Duration must be greater than 0'); // Duration is 0
    });

    test('Invalid price', () {
      final result = farmAddingLogic.validateLogin(
          'My Farm', 'Jada', 'Orange', 500, 3, -1);
      expect(result, 'Price must be greater than 0'); // Negative price
    });
  });
}
