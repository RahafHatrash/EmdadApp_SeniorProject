import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  late FirebaseFirestore fakeFirestore;

  setUp(() {
    // Initialize Fake Firestore
    fakeFirestore = FakeFirebaseFirestore();
  });

  test('Verify Farmer role in Firestore', () async {
    // Set up test data in Firestore
    await fakeFirestore.collection('users').doc('farmerUserId').set({
      'email': 'farmer@example.com',
      'userType': 'مزارع',
    });

    // Fetch user role from Firestore
    final userDoc =
        await fakeFirestore.collection('users').doc('farmerUserId').get();
    final userType = userDoc['userType'];

    // Verify role is correct
    expect(userType, 'مزارع');
  });

  test('Verify Investor role in Firestore', () async {
    // Set up test data in Firestore
    await fakeFirestore.collection('users').doc('investorUserId').set({
      'email': 'investor@example.com',
      'userType': 'مستثمر',
    });

    // Fetch user role from Firestore
    final userDoc =
        await fakeFirestore.collection('users').doc('investorUserId').get();
    final userType = userDoc['userType'];

    // Verify role is correct
    expect(userType, 'مستثمر');
  });
}
