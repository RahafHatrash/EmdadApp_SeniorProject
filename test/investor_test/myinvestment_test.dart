import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Investment Returns Calculation', () {
    late FakeFirebaseFirestore fakeFirestore;

    setUp(() {
      // Initialize a fake Firestore instance
      fakeFirestore = FakeFirebaseFirestore();
    });

    test('Calculate 20% return for each investment and sum totals', () async {
      // Mock user ID
      const userId = 'mockUserId';

      // Add mock investments with individual amounts
      await fakeFirestore.collection('investments').add({
        'userId': userId,
        'FarmName': 'Farm A',
        'investmentAmount': 1000.0,
        'FarmId': 'project1',
      });

      await fakeFirestore.collection('investments').add({
        'userId': userId,
        'FarmName': 'Farm B',
        'investmentAmount': 500.0,
        'FarmId': 'project2',
      });

      // Fetch investments for the user
      final investmentSnapshot = await fakeFirestore
          .collection('investments')
          .where('userId', isEqualTo: userId)
          .get();

      // Logic to calculate 20% return for each investment and sum totals
      double totalInvestments = 0.0;
      double totalReturns = 0.0;

      for (var investment in investmentSnapshot.docs) {
        final investmentAmount = investment['investmentAmount'] as double;

        // Sum the total investment amount
        totalInvestments += investmentAmount;

        // Calculate 20% return for this investment
        final investmentReturn = investmentAmount * 0.2;

        print('Project: ${investment['FarmName']}');
        print('Investment Amount: $investmentAmount');
        print('Investment Return (20%): $investmentReturn');

        // Sum the total returns
        totalReturns += investmentReturn;
      }

      // Assertions
      expect(totalInvestments, 1500.0); // 1000 + 500
      expect(totalReturns, 300.0); // 20% of 1000 = 200, 20% of 500 = 100
    });
  });
}
