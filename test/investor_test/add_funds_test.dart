import 'package:flutter_test/flutter_test.dart';

void main() {
  Map<String, dynamic> addFunds(double currentBalance, double amount) {
    if (amount <= 0) {
      return {
        'status': 'error',
        'message': 'Amount must be greater than 0',
      };
    }
    final newBalance = currentBalance + amount;
    return {
      'status': 'success',
      'newBalance': newBalance,
      'transaction': {
        'type': 'add_funds',
        'amount': amount,
        'timestamp': DateTime.now(),
      },
    };
  }

  group('Add Funds Logic', () {
    test('Add positive amount to wallet', () {
      // Initial wallet balance
      const double currentBalance = 1000.0;
      const double amountToAdd = 500.0;

      // Execute the function
      final result = addFunds(currentBalance, amountToAdd);

      // Verify the result
      expect(result['status'], 'success');
      expect(result['newBalance'], 1500.0); // 1000 + 500
      expect(result['transaction']['type'], 'add_funds');
      expect(result['transaction']['amount'], amountToAdd);
      expect(result['transaction']['timestamp'], isA<DateTime>());
    });
  });
}
