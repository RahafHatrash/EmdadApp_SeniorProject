import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../custom_bottom_nav_bar.dart';
import '../InvestorWallet/FundsOperation/add_funds_page.dart';
import 'InvestVerification.dart'; // Make sure to import your custom bottom nav bar

class Investoperation extends StatefulWidget {
  final String projectName; // اسم المشروع الذي سيتم تمريره
  final String projectId; // إضافة projectId كمعامل جديد

  const Investoperation({
    super.key,
    required this.projectName,
    required this.projectId, // التأكد من تمريره
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

  Future<bool> _processInvestment() async {
    try {
      // التحقق من المشروع أولاً
      final isEligible = await _fetchProjectDetails();
      if (!isEligible) return false; // المشروع غير مؤهل للاستثمار

      if (totalInvestment > walletBalance) {
        _showFailureMessage('رصيد المحفظة غير كافٍ');
        return false; // الرصيد غير كافٍ
      }

      final walletDoc =
          FirebaseFirestore.instance.collection('wallets').doc(userId);
      final investmentsCollection =
          FirebaseFirestore.instance.collection('investments');
      final projectDoc = FirebaseFirestore.instance
          .collection('investmentOpportunities')
          .doc(widget.projectId);

      // تحديث المحفظة
      await walletDoc.update({
        'currentBalance': FieldValue.increment(-totalInvestment),
        'transactions': FieldValue.arrayUnion([
          {
            'type': 'investmentWithdrawal',
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

      // التحقق من اكتمال المشروع
      final projectSnapshot = await projectDoc.get();
      final projectData = projectSnapshot.data();
      final targetAmount = projectData?['targetAmount'] ?? 0.0;
      final currentInvestment = projectData?['currentInvestment'] ?? 0.0;

      if (currentInvestment >= targetAmount) {
        await projectDoc.update({'status': 'مكتملة'});
      }

      return true; // العملية ناجحة
    } catch (e) {
      _showFailureMessage('حدث خطأ أثناء عملية الاستثمار: $e');
      return false; // العملية فشلت
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
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          _buildAppBar(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(), // إضافة مساحة فارغة فوق البوكس
                SizedBox(
                  height: 350, // ارتفاع البوكس الأبيض
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.white, // خلفية بيضاء
                      borderRadius: BorderRadius.circular(40), // زوايا مستديرة
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26, // لون الظل
                          blurRadius: 6.0, // تمويه الظل
                          offset: Offset(0, 2), // موقع الظل
                        ),
                      ],
                    ),
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
                          'إجمالي مبلغ الاستثمار: ${totalInvestment.toStringAsFixed(2)} ر.س',
                          style: const TextStyle(fontSize: 14),
                        ),

                        const SizedBox(height: 20),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () async {
                            // التحقق وتنفيذ الاستثمار
                            final isEligible = await _processInvestment();

                            // الانتقال إلى صفحة التحقق فقط إذا كانت العملية ناجحة
                            if (isEligible) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const InvestVerification(), // الانتقال لصفحة InvestVerification
                                ),
                              );
                            }
                          },
                          child: Container(
                            height: 35,
                            width: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.0),
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF4B7960),
                                  Color(0xFF728F66),
                                  Color(0xFFA2AA6D),
                                ],
                              ),
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              'استثمر',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(
                            height: 15), // مسافة صغيرة بين الزر والنص
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    const AddFundsPage(), // انتقال إلى صفحة AddFundsPage
                              ),
                            );
                          },
                          child: const Text(
                            ' شحن رصيد المحفظة +',
                            style: TextStyle(
                              color: Colors.blue, // لون النص
                              fontSize: 13, // حجم النص
                              // إضافة خط تحت النص
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
          Positioned(
            top: 50,
            right: 15,
            child: IconButton(
              icon: const Icon(Icons.arrow_forward,
                  color: Colors.white, size: 30),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: -1, // Update the index based on the current page
        onTap: (index) {
          // Handle navigation based on the selected index
          // Example: Navigator.of(context).pushNamed('/pageName');
        },
      ),
    );
  }

  Widget _buildAppBar() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
      child: Container(
        height: 320,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF345E50), Color(0xFF49785E), Color(0xFFA8B475)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 150),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'استثمر الان',
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'يمكنك هنا متابعة جميع استثماراتك في الفُرص الزراعية,\n ومراجعة التفاصيل المتعلقة بها.',
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
