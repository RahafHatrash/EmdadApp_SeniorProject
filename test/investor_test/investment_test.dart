import 'package:flutter_test/flutter_test.dart';

void main() {
  bool canInvest(
      double totalInvestment, double walletBalance, double remainingAmount) {
    return walletBalance >= totalInvestment &&
        totalInvestment <= remainingAmount;
  }

  Map<String, dynamic> processTransaction(
    double walletBalance,
    double totalInvestment,
    double currentInvestment,
  ) {
    return {
      'newWalletBalance': walletBalance - totalInvestment,
      'newProjectInvestment': currentInvestment + totalInvestment,
      'status': walletBalance >= totalInvestment ? 'success' : 'failure',
    };
  }

  group('Investment Logic', () {
    test('wallet has enough balance to invest', () {
      const walletBalance = 10000.0;
      const totalInvestment = 3000.0;
      const remainingAmount = 5000.0;
      final result = canInvest(totalInvestment, walletBalance, remainingAmount);

      expect(result, true);
    });

    test('wallet has not enough balance to invest', () {
      const walletBalance = 1000.0;
      const totalInvestment = 3000.0;
      const remainingAmount = 5000.0;
      final result = canInvest(totalInvestment, walletBalance, remainingAmount);

      expect(result, false);
    });

    test('Process investment and return updated values', () {
      const walletBalance = 10000.0;
      const totalInvestment = 3000.0;
      const currentInvestment = 2000.0;

      final result =
          processTransaction(walletBalance, totalInvestment, currentInvestment);

      expect(result['newWalletBalance'], 7000.0);
      expect(result['newProjectInvestment'], 5000.0);
      expect(result['status'], 'success');
    });

    test('Fail transaction due to insufficient balance', () {
      const walletBalance = 2000.0;
      const totalInvestment = 3000.0;
      const currentInvestment = 2000.0;

      final result =
          processTransaction(walletBalance, totalInvestment, currentInvestment);

      expect(result['status'], 'failure');
    });
  });
}
