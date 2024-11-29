import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Investoperation extends StatefulWidget {
  final String projectName; // اسم المشروع الذي سيتم تمريره
  final String projectId; // إضافة projectId كمعامل جديد

  const Investoperation({
    super.key,
    required this.projectName,
    required this.projectId,
  });

  @override
  State<StatefulWidget> createState() => _InvestmentPageState();
}

class _InvestmentPageState extends State<Investoperation> {
  static const double unitPrice = 1000.0; // Fixed price per unit
  int unitCount = 1; // Default unit count
  double walletBalance = 0.0; // Wallet balance
  String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

  double get totalInvestment => unitCount * unitPrice;

  @override
  void initState() {
    super.initState();
    _fetchWalletBalance();
  }

  Future<void> _fetchWalletBalance() async {
    try {
      final walletDoc =
          FirebaseFirestore.instance.collection('wallets').doc(userId);
      final snapshot = await walletDoc.get();

      if (snapshot.exists) {
        setState(() {
          walletBalance = snapshot.data()?['currentBalance'] ?? 0.0;
        });
      }
    } catch (e) {
      print('Error fetching wallet balance: $e');
    }
  }

  Future<bool> _fetchProjectDetails() async {
    try {
      final projectDoc = await FirebaseFirestore.instance
          .collection('investmentOpportunities')
          .doc(widget.projectId)
          .get();

      if (projectDoc.exists) {
        final data = projectDoc.data();
        final targetAmount = data?['targetAmount'] ?? 0.0;
        final currentInvestment = data?['currentInvestment'] ?? 0.0;

        // حساب المبلغ المتبقي
        final remainingAmount = targetAmount - currentInvestment;

        // التحقق إذا كان المشروع مكتملًا
        if (remainingAmount <= 0) {
          _showFailureMessage('المشروع مكتمل بالفعل، لا يمكنك الاستثمار فيه.');
          return false;
        }

        // التحقق إذا كان مبلغ الاستثمار أكبر من المبلغ المتبقي
        if (totalInvestment > remainingAmount) {
          _showFailureMessage(
              'المبلغ الذي تحاول استثماره (${totalInvestment.toStringAsFixed(2)} ر.س) أكبر من المبلغ المتبقي (${remainingAmount.toStringAsFixed(2)} ر.س).');
          return false;
        }

        return true; // المشروع مفتوح للاستثمار
      } else {
        _showFailureMessage('المشروع غير موجود.');
        return false;
      }
    } catch (e) {
      print('Error fetching project details: $e');
      _showFailureMessage('حدث خطأ أثناء جلب بيانات المشروع.');
      return false;
    }
  }

  Future<void> _processInvestment() async {
    try {
      // التحقق من المشروع أولاً
      final isEligible = await _fetchProjectDetails();
      if (!isEligible) return;

      if (totalInvestment > walletBalance) {
        _showFailureMessage('رصيد المحفظة غير كافٍ');
        return;
      }

      final walletDoc =
          FirebaseFirestore.instance.collection('wallets').doc(userId);
      final investmentsCollection =
          FirebaseFirestore.instance.collection('investments');
      final projectDoc = FirebaseFirestore.instance
          .collection('investmentOpportunities')
          .doc(widget.projectId);

      // جلب الرصيد الحالي
      final walletSnapshot = await walletDoc.get();
      final currentBalance = walletSnapshot.data()?['currentBalance'] ?? 0.0;

      if (currentBalance < totalInvestment) {
        _showFailureMessage('رصيد المحفظة غير كافٍ');
        return;
      }

      // جلب بيانات المشروع وتحقق من المبلغ المتبقي
      final projectSnapshot = await projectDoc.get();
      final projectData = projectSnapshot.data();
      final targetAmount = projectData?['targetAmount'] ?? 0.0;
      final currentInvestment = projectData?['currentInvestment'] ?? 0.0;

      if (currentInvestment + totalInvestment > targetAmount) {
        _showFailureMessage(
          'المشروع وصل إلى الحد الأقصى للاستثمار ولا يمكن الاستثمار فيه.',
        );
        return;
      }

      // تحديث المحفظة
      await walletDoc.update({
        'currentBalance': FieldValue.increment(-totalInvestment),
        'transactions': FieldValue.arrayUnion([
          {
            'type': 'investmentWithdrawal', // نوع العملية
            'projectName': widget.projectName,
            'amount': totalInvestment,
            'investmentDate': DateTime.now(),
            'returnAmount': 0,
          }
        ]),
      });

      // إضافة عملية الاستثمار
      await investmentsCollection.add({
        'userId': userId,
        'projectId': widget.projectId,
        'investmentAmount': totalInvestment,
        'investmentDate': FieldValue.serverTimestamp(),
        'projectName': widget.projectName,
        'expectedReturns': totalInvestment * 0.2,
      });

      // تحديث الاستثمار الحالي في المشروع
      await projectDoc.update({
        'currentInvestment': FieldValue.increment(totalInvestment),
      });

      _showSuccessMessage('تم استثمار المبلغ بنجاح!');
    } catch (e) {
      _showFailureMessage('حدث خطأ أثناء عملية الاستثمار: $e');
    }
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.of(context).pop();
  }

  void _showFailureMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF345E50), Color(0xFFA8B475)],
                  ),
                ),
                child: Center(
                  child: Text(
                    'استثمر في ${widget.projectName}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(
                          'رصيد المحفظة: ${walletBalance.toStringAsFixed(2)} ر.س'),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              setState(() {
                                if (unitCount > 1) unitCount--;
                              });
                            },
                          ),
                          Text('$unitCount وحدة',
                              style: const TextStyle(fontSize: 18)),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                unitCount++;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'إجمالي الاستثمار: ${totalInvestment.toStringAsFixed(2)} ر.س',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _processInvestment,
                        child: const Text('استثمر'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 50,
            left: 15,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, size: 30, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}
