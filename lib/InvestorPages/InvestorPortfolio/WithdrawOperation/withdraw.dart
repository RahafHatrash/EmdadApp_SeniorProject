import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../AddBankAccountPage.dart';

class WithdrawPage extends StatefulWidget {
  const WithdrawPage({super.key});

  @override
  _WithdrawPageState createState() => _WithdrawPageState();
}

class _WithdrawPageState extends State<WithdrawPage> {
  final TextEditingController _withdrawAmountController =
      TextEditingController();
  String? selectedAccount;

  Future<void> withdrawFundsFromPortfolio(double amount) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      final PortfolioDoc =
          FirebaseFirestore.instance.collection('InvestmentPortfolio').doc(userId);
      final timestamp = FieldValue.serverTimestamp();

      final PortfolioSnapshot = await PortfolioDoc.get();
      final currentBalance = PortfolioSnapshot.data()?['currentBalance'] ?? 0.0;

      if (currentBalance < amount) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('رصيد المحفظة غير كافي'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      await PortfolioDoc.update({
        'currentBalance': FieldValue.increment(-amount),
        'lastUpdated': timestamp,
        'transactions': FieldValue.arrayUnion([
          {
            'type': 'withdrawal',
            'amount': amount,
            'timestamp': DateTime.now(),
          }
        ]),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم سحب الأموال بنجاح من المحفظة'),
          backgroundColor: Colors.green,
        ),
      );

      _withdrawAmountController.clear();
      Navigator.pop(context);
    } catch (e) {
      print('حدث خطأ أثناء سحب الأموال: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('حدث خطأ أثناء سحب الأموال'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildStyledTextField(
      String labelText, TextEditingController controller) {
    FocusNode focusNode = FocusNode();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            labelText,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color.fromARGB(216, 53, 94, 79),
            ),
          ),
        ),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            hintText: focusNode.hasFocus ? null : 'القيمة بالريال السعودي',
            hintStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
            border: InputBorder.none,
            prefixText: 'ر.س ',
          ),
          style: const TextStyle(
            color: Color.fromARGB(216, 53, 94, 79),
          ),
          focusNode: focusNode,
        ),
        Container(
          height: 1,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF345E50), Color(0xFF49785E), Color(0xFFA8B475)],
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  void _handleWithdrawButton(BuildContext context) async {
    final amountText = _withdrawAmountController.text;
    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى إدخال مبلغ السحب'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (selectedAccount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى اختيار حساب بنكي'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    await withdrawFundsFromPortfolio(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.36,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF345E50),
                        Color(0xFF49785E),
                        Color(0xFFA8B475),
                      ],
                    ),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 85),
                      Text(
                        'سحب من المحفظة',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'اختر الحساب البنكي وأدخل المبلغ الذي تريد سحبه',
                        style: TextStyle(fontSize: 15, color: Colors.white70),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(child: Container(color: Colors.white)),
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.23,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Amount input field comes first
                  _buildStyledTextField(
                    'ادخل المبلغ المراد سحبه',
                    _withdrawAmountController,
                  ),
                  const SizedBox(height: 30),
                  // Bank account selection comes after the amount input
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'اختر حسابك البنكي',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color.fromARGB(216, 53, 94, 79),
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildAccountOption(
                    "SA846... البنك السعودي للاستثمار",
                    "SA03 8000 0000 6080 1016 7519",
                  ),
                  const SizedBox(height: 50),
                  Center(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _handleWithdrawButton(context);
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF345E50),
                                  Color(0xFFA8B475),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Center(
                              child: Text(
                                'سحب مبلغ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const AddBankAccountPage(),
                                ),
                              );
                            },
                            child: const Text(
                              'أضف حساب جديد +',
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
    );
  }

  Widget _buildAccountOption(String accountName, String accountNumber) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAccount = accountName;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selectedAccount == accountName
                ? const Color(0xFF4B7960)
                : Colors.grey.shade300,
          ),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))
          ],
        ),
        child: Row(
          children: [
            Icon(
              selectedAccount == accountName
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: const Color(0xFF4B7960),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(accountName,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87)),
                  Text(accountNumber,
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black54)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
