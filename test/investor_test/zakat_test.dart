import 'package:flutter_test/flutter_test.dart';

void main() {
  double calculateZakat({required double amount, required double nisab}) {
    if (amount < nisab) {
      return 0.0;
    }
    return amount * 0.025;
  }

  group('Zakat Calculation Tests', () {
    const double nisab = 1749.3;

    test('Amount below nisab', () {
      final zakat = calculateZakat(amount: 1000.0, nisab: nisab);
      expect(zakat, 0.0); // Zakat is 0 for amounts below nisab
    });

    test('Amount equal to nisab', () {
      final zakat = calculateZakat(amount: nisab, nisab: nisab);
      expect(zakat, nisab * 0.025); // 2.5% of nisab
    });

    test('Amount above nisab', () {
      final zakat = calculateZakat(amount: 2000.0, nisab: nisab);
      expect(zakat, 2000.0 * 0.025); // 2.5% of the amount
    });
  });
}
