import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../custom_bottom_nav_bar.dart';
import 'WithdrawOperation/withdraw.dart';
import 'FundsOperation/add_funds_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  _PortfolioPageState createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  String? userId;

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      createInvestmentPortfolio(userId!);
    }
  }

  Future<void> createInvestmentPortfolio(String userId) async {
    try {
      final PortfolioDoc = FirebaseFirestore.instance.collection('InvestmentPortfolio').doc(userId);

      final snapshot = await PortfolioDoc.get();
      if (!snapshot.exists) {
        await PortfolioDoc.set({
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

  Future<void> updatePortfolio(String userId, double amount, String transactionType) async {
    try {
      final PortfolioDoc = FirebaseFirestore.instance.collection('InvestmentPortfolio').doc(userId);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(PortfolioDoc);

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

        transaction.update(PortfolioDoc, {
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

  Stream<DocumentSnapshot<Map<String, dynamic>>> getPortfolioDetails(String userId) {
    return FirebaseFirestore.instance.collection('InvestmentPortfolio').doc(userId).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: getPortfolioDetails(userId!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data?.data() == null) {
            return const Center(child: Text('لا توجد بيانات للمحفظة'));
          }

          final data = snapshot.data!.data();
          final balance = data?['currentBalance'] ?? 0.0;
          final transactions = List.from(data?['transactions'] ?? []);

          return Stack(
            children: [
              Positioned.fill(
                top: MediaQuery.of(context).size.height * 0.35,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: Container(
                    color: const Color(0xFFF9FAF9),
                  ),
                ),
              ),
              Column(
                children: [
                  _buildHeader(balance),
                  Expanded(child: _buildTransactionList(transactions)),
                ],
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 3,
        onTap: (index) {
          // Handle bottom nav tap
        },
      ),
    );
  }

  Widget _buildHeader(double balance) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(40),
        bottomRight: Radius.circular(40),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.31,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF345E50), Color(0xFF49785E), Color(0xFFA8B475)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 60),
            const Text(
              'محفظتي الأستثمارية',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'الرصيد الحالي',
              style: TextStyle(fontSize: 18, color: Colors.white70),
            ),
            Text(
              'ريال ${balance.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildButton("إضافة أموال", Icons.add, _navigateToAddFundsPage),
                const SizedBox(width: 10),
                _buildButton("سحب", Icons.arrow_downward, _navigateToWithdrawPage),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionList(List transactions) {
    if (transactions.isEmpty) {
      return const Center(
        child: Text(
          'لا يوجد أي عمليات على محفظتك',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return Container(
      height: 550,
      width: 400,
      color: const Color(0xFFF9FAF9),
      child: SingleChildScrollView(
        child: Column(
          children: transactions.map((transaction) {
            String transactionType;
            IconData transactionIcon;
            Color transactionColor;

            switch (transaction['type']) {
              case 'add_funds':
                transactionType = 'شحن رصيد';
                transactionIcon = Icons.add_circle;
                transactionColor = Colors.green;
                break;
              case 'withdrawal':
                transactionType = 'سحب';
                transactionIcon = Icons.remove_circle;
                transactionColor = Colors.red;
                break;
              case 'investmentOperation':
                transactionType = 'عملية للاستثمار';
                transactionIcon = Icons.trending_down;
                transactionColor = Colors.orange;
                break;
              case 'returnDeposit':
                transactionType = 'إيداع أرباح';
                transactionIcon = Icons.account_balance_wallet;
                transactionColor = Colors.blue;
                break;
              default:
                transactionType = 'عملية غير معروفة';
                transactionIcon = Icons.help_outline;
                transactionColor = Colors.grey;
            }

            final amount = transaction['amount'] ?? 0.0;
            final timestamp = transaction['timestamp'] != null
                ? (transaction['timestamp'] as Timestamp).toDate()
                : DateTime.now();

            return Column(
              children: [
                ListTile(
                  leading: Icon(
                    transactionIcon,
                    color: transactionColor,
                  ),
                  title: Text('$transactionType: ${amount.toStringAsFixed(2)} ريال'),
                  subtitle: Text('التاريخ: ${timestamp.toLocal()}'),
                ),
                Divider(
                  color: Colors.grey.withOpacity(0.5),
                  height: 1,
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildButton(String label, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(label, style: const TextStyle(fontSize: 14)),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF335D4F),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  void _navigateToAddFundsPage() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const AddFundsPage()),
    );
  }

  void _navigateToWithdrawPage() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const WithdrawPage()),
    );
  }
}