import 'package:cloud_firestore/cloud_firestore.dart';

class WalletService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // إنشاء المحفظة إذا لم تكن موجودة
  Future<void> createWalletIfNotExists(String userId) async {
    try {
      final walletDoc = _firestore.collection('wallets').doc(userId);

      final snapshot = await walletDoc.get();
      if (!snapshot.exists) {
        await walletDoc.set({
          'userId': userId,
          'currentBalance': 0.0,
          'lastUpdated': FieldValue.serverTimestamp(),
          'transactions': [],
        });
        print('تم إنشاء المحفظة بنجاح');
      } else {
        print('المحفظة موجودة بالفعل');
      }
    } catch (e) {
      print('خطأ أثناء إنشاء المحفظة: $e');
    }
  }

  // تحديث المحفظة (إيداع أو سحب)
  Future<void> updateWallet(String userId, double amount, String transactionType) async {
    try {
      final walletDoc = _firestore.collection('wallets').doc(userId);

      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(walletDoc);

        if (!snapshot.exists) {
          throw Exception('المحفظة غير موجودة');
        }

        final currentBalance = snapshot.data()?['currentBalance'] ?? 0.0;

        if (transactionType == 'withdraw' && currentBalance < amount) {
          throw Exception('الرصيد غير كافٍ لإتمام العملية');
        }

        final newBalance = transactionType == 'deposit'
            ? currentBalance + amount
            : currentBalance - amount;

        transaction.update(walletDoc, {
          'currentBalance': newBalance,
          'lastUpdated': FieldValue.serverTimestamp(),
          'transactions': FieldValue.arrayUnion([
            {
              'type': transactionType,
              'amount': amount,
              'timestamp': FieldValue.serverTimestamp(),
            },
          ]),
        });
      });

      print('تم تحديث المحفظة بنجاح');
    } catch (e) {
      print('خطأ أثناء تحديث المحفظة: $e');
    }
  }

  // جلب تفاصيل المحفظة
  Stream<DocumentSnapshot<Map<String, dynamic>>> getWalletDetails(String userId) {
    return _firestore.collection('wallets').doc(userId).snapshots();
  }
}
