import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'AddBankAccountFarmer.dart';

class DepositReturnsScreen extends StatefulWidget {
  final String documentId;

  const DepositReturnsScreen({required this.documentId, super.key});

  @override
  _DepositReturnsScreenState createState() => _DepositReturnsScreenState();
}

class _DepositReturnsScreenState extends State<DepositReturnsScreen> {
  final TextEditingController amountController = TextEditingController();
  String? selectedAccount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAF9),
      body: Stack(
        children: [
          // Gradient background
          Container(
            height: 320,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF345E50),
                  Color(0xFF49785E),
                  Color(0xFFA8B475)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 50,
                  right: 15,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 140.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'إيداع عوائد المزرعة',
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'يرجى إدخال قيمة العائد مع اختيار الحساب البنكي\n المناسب لإتمام العملية',
                          style: TextStyle(fontSize: 15, color: Colors.white70),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 210, left: 16, right: 16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 5,
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        _buildLabel('أدخل عائد المزرعة'),
                        const SizedBox(height: 5),
                        _buildAmountInput(),
                        _buildDivider(),
                        const SizedBox(height: 50),
                        _buildLabel('اختر حسابك البنكي '),
                        const SizedBox(height: 10),
                        _buildAccountOption("SA846... البنك السعودي للاستثمار",
                            "SA03 8000 0000 6080 1016 7519"),
                        const SizedBox(height: 10),
                        _buildAccountOption("SA123... بنك الرياض",
                            "SA03 8000 0000 1234 5678 9012"),
                        const SizedBox(height: 30), // Reduced space
                        _buildDepositButton(),
                        _buildAddAccountButton(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Container(
      alignment: Alignment.centerRight,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF345E50),
        ),
      ),
    );
  }

  Widget _buildAmountInput() {
    return TextField(
      controller: amountController,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.right,
      decoration: const InputDecoration(
        hintText: 'القيمة بالريال السعودي',
        hintStyle: TextStyle(color: Color(0xFFA09E9E), fontSize: 12),
        border: InputBorder.none,
      ),
      style: const TextStyle(color: Color(0xFFA09E9E)),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4B7960), Color(0xFF728F66), Color(0xFFA2AA6D)],
        ),
      ),
    );
  }

  Widget _buildDepositButton() {
    return Center(
      child: Container(
        width: 200,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0),
          gradient: const LinearGradient(
            colors: [Color(0xFF4B7960), Color(0xFF728F66), Color(0xFFA2AA6D)],
          ),
        ),
        child: ElevatedButton(
          onPressed: () => _depositReturns(),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
            ),
          ),
          child: const Text(
            'إيداع العوائد',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddAccountButton() {
    return Center(
      child: TextButton(
        onPressed: () {
          // Navigate to the Add Bank Account Page
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const AddBankAccountFarmer()),
          );
        },
        child: const Text(
          'أضف حساب جديد +',
          style: TextStyle(
            color: Colors.blueAccent, // لون النص
            fontSize: 15, // حجم النص
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Future<void> _depositReturns() async {
    final amount = double.tryParse(amountController.text);

    // Check if the amount is valid
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إدخال مبلغ العائد')),
      );
      return;
    }

    // Check if an account is selected
    if (selectedAccount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى اختيار حساب بنكي')),
      );
      return;
    }

    try {
      // Confirmation dialog
      final confirmation = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('تأكيد الإيداع'),
          content:
              Text('هل أنت متأكد من إيداع مبلغ $amount ر.س لجميع المستثمرين؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('تأكيد'),
            ),
          ],
        ),
      );

      if (confirmation != true) return;

      // Update status and profitDeposited field
      await FirebaseFirestore.instance
          .collection('investmentOpportunities')
          .doc(widget.documentId)
          .update({
        'status': 'مكتملة',
        'totalReturns': amount,
        'profitDeposited': true, // Set profitDeposited to true
      });

      // Fetch all investments related to the FarmProject
      final investmentsSnapshot = await FirebaseFirestore.instance
          .collection('investments')
          .where('FarmId', isEqualTo: widget.documentId)
          .get();

      if (investmentsSnapshot.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('لا يوجد مستثمرين مرتبطين بهذا المشروع')),
        );
        return;
      }

      // Calculate total investments and update Portfolio
      final totalInvestment = investmentsSnapshot.docs.fold<double>(
        0.0,
        (sum, doc) => sum + (doc.data()['investmentAmount'] as num).toDouble(),
      );

      final WriteBatch batch = FirebaseFirestore.instance.batch();

      for (var investmentDoc in investmentsSnapshot.docs) {
        final investmentData = investmentDoc.data();
        final userId = investmentData['userId'];
        final investmentAmount =
            (investmentData['investmentAmount'] as num).toDouble();

        // Calculate return share
        final double returnShare =
            (investmentAmount / totalInvestment) * amount;

        // Update investor Portfolio
        final PortfolioRef =
            FirebaseFirestore.instance.collection('InvestmentPortfolio').doc(userId);
        batch.update(PortfolioRef, {
          'currentBalance': FieldValue.increment(returnShare),
          'transactions': FieldValue.arrayUnion([
            {
              'type': 'returnDeposit',
              'FarmId': widget.documentId,
              'amount': returnShare,
              'timestamp': DateTime.now(),
            },
          ]),
        });

        // Create return history record
        final returnsHistoryRef =
            investmentDoc.reference.collection('returnsHistory').doc();
        batch.set(returnsHistoryRef, {
          'amount': returnShare,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }

      // Commit batch updates
      await batch.commit();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('تم إيداع العوائد وتوزيعها على المستثمرين بنجاح')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ أثناء توزيع العوائد: $e')),
      );
    }
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
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87)),
                  Text(accountNumber,
                      style:
                          const TextStyle(fontSize: 15, color: Colors.black54)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
