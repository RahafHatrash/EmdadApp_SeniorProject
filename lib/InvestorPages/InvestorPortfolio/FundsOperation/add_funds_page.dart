import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../AddBankAccountPage.dart';

class AddFundsPage extends StatefulWidget {
  const AddFundsPage({super.key});

  @override
  _AddFundsPageState createState() => _AddFundsPageState();
}

class _AddFundsPageState extends State<AddFundsPage> {
  final TextEditingController _amountController = TextEditingController();
  String? selectedAccount;

  Future<void> addFundsToPortfolio(double amount, String type) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      final PortfolioDoc =
          FirebaseFirestore.instance.collection('InvestmentPortfolio').doc(userId);
      final timestamp = FieldValue.serverTimestamp();
      await PortfolioDoc.update({
        'currentBalance': FieldValue.increment(amount),
        'lastUpdated': timestamp,
        'transactions': FieldValue.arrayUnion([
          {
            'type': type,
            'amount': amount,
            'timestamp': DateTime.now(),
          }
        ]),
      });
      print('تمت إضافة الأموال وتسجيل العملية بنجاح');
    } catch (e) {
      print('حدث خطأ أثناء إضافة الأموال: $e');
    }
  }

  void _showSuccessMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تمت إضافة الأموال بنجاح إلى المحفظة'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _handleNextButton(BuildContext context) async {
    final amountText = _amountController.text;
    final amount = double.tryParse(amountText);

    // Check if the amount is valid
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى إدخال مبلغ الشحن'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    // Check if an account is selected
    if (selectedAccount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى اختيار حساب بنكي'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    const operationType = "add_funds";
    await addFundsToPortfolio(amount, operationType);
    _showSuccessMessage(context);
    _amountController.clear();
    Navigator.pop(context);
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
              fontSize: 13,
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
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 85),
                      Text(
                        'اشحن محفظتك',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'اختر الحساب البنكي وأدخل المبلغ الذي تريد إضافته',
                        style: TextStyle(fontSize: 14, color: Colors.white70),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.25,
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
                  // Amount field comes first
                  _buildStyledTextField(
                    'ادخل مبلغ الشحن',
                    _amountController,
                  ),
                  const SizedBox(height: 30),
                  // Bank account selection
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
                  const SizedBox(height: 30),
                  Center(
                    child: GestureDetector(
                      onTap: () => _handleNextButton(context),
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
                            'التالي',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
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
                            builder: (context) => const AddBankAccountPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'أضف حساب جديد +',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
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
