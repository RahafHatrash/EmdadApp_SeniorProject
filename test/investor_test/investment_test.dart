import 'package:flutter_test/flutter_test.dart';

void main() {
  bool canInvest(
      double totalInvestment, double PortfolioBalance, double remainingAmount) {
    return PortfolioBalance >= totalInvestment &&
        totalInvestment <= remainingAmount;
  }

  Map<String, dynamic> processTransaction(
    double PortfolioBalance,
    double totalInvestment,
    double currentInvestment,
  ) {
    return {
      'newPortfolioBalance': PortfolioBalance - totalInvestment,
      'newProjectInvestment': currentInvestment + totalInvestment,
      'status': PortfolioBalance >= totalInvestment ? 'success' : 'failure',
    };
  }

  group('Investment Logic', () {
    test('Portfolio has enough balance to invest', () {
      const PortfolioBalance = 10000.0;
      const totalInvestment = 3000.0;
      const remainingAmount = 5000.0;
      final result = canInvest(totalInvestment, PortfolioBalance, remainingAmount);

      expect(result, true);
    });

    test('Portfolio has not enough balance to invest', () {
      const PortfolioBalance = 1000.0;
      const totalInvestment = 3000.0;
      const remainingAmount = 5000.0;
      final result = canInvest(totalInvestment, PortfolioBalance, remainingAmount);

      expect(result, false);
    });

    test('Process investment and return updated values', () {
      const PortfolioBalance = 10000.0;
      const totalInvestment = 3000.0;
      const currentInvestment = 2000.0;

      final result =
          processTransaction(PortfolioBalance, totalInvestment, currentInvestment);

      expect(result['newPortfolioBalance'], 7000.0);
      expect(result['newProjectInvestment'], 5000.0);
      expect(result['status'], 'success');
    });

    test('Fail transaction due to insufficient balance', () {
      const PortfolioBalance = 2000.0;
      const totalInvestment = 3000.0;
      const currentInvestment = 2000.0;

      final result =
          processTransaction(PortfolioBalance, totalInvestment, currentInvestment);

      expect(result['status'], 'failure');
    });
  });
}
