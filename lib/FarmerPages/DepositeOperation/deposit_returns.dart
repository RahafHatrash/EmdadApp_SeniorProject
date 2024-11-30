import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DepositReturnsScreen extends StatefulWidget {
  final String documentId;

  const DepositReturnsScreen({required this.documentId, Key? key})
      : super(key: key);

  @override
  _DepositReturnsScreenState createState() => _DepositReturnsScreenState();
}

class _DepositReturnsScreenState extends State<DepositReturnsScreen> {
  final TextEditingController amountController = TextEditingController();
  String? selectedAccount; // For selected bank account

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAF9),
      body: Stack(
        children: [
          // Top gradient background with a rounded border at the bottom
          Container(
            height: 320,
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
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 145.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
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
                          'يرجى إدخال قيمة العائد مع اختيار حسابك\n المناسب لإتمام العملية',
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
            padding: const EdgeInsets.only(top: 200, left: 16, right: 16),
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
                        const SizedBox(height: 40),
                        _buildLabel('أدخل عائد المزرعة'),
                        const SizedBox(height: 5),
                        _buildAmountInput(),
                        _buildDivider(),
                        const SizedBox(height: 40),
                        _buildLabel('اختر حسابك'),
                        const SizedBox(height: 15),
                        _buildAccountOption(
                          "SA846... البنك السعودي للاستثمار",
                          "SA03 8000 0000 6080 1016 7519",
                        ),
                        const SizedBox(height: 40),
                        _buildDepositButton(), // Button to execute deposit and update status
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

  // Label widget
  Widget _buildLabel(String text) {
    return Container(
      alignment: Alignment.centerRight,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFF345E50),
        ),
      ),
    );
  }

  // Amount input field
  Widget _buildAmountInput() {
    return TextField(
      controller: amountController,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.right,
      decoration: const InputDecoration(
        hintText: 'القيمة بالريال السعودي',
        hintStyle: TextStyle(color: Color(0xFFA09E9E)),
        border: InputBorder.none,
      ),
      style: const TextStyle(color: Color(0xFFA09E9E)),
    );
  }

  // Divider widget
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

  // Bank account selection widget
  Widget _buildAccountOption(String accountName, String accountNumber) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAccount = accountName; // Set the selected account
        });
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selectedAccount == accountName
                ? Color(0xFF4B7960)
                : Colors.grey.shade300,
          ),
          boxShadow: [
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
              color: Color(0xFF4B7960),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(accountName,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87)),
                  Text(accountNumber,
                      style: TextStyle(fontSize: 14, color: Colors.black54)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Deposit button widget
  Widget _buildDepositButton() {
    return Center(
      child: Container(
        width: 150,
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
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  // Method to deposit returns and update status
  Future<void> _depositReturns() async {
    final amount =
    double.tryParse(amountController.text); // قيمة العائد المدخلة
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إدخال قيمة صحيحة للعوائد')),
      );
      return;
    }

    if (selectedAccount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى اختيار حساب بنكي')),
      );
      return;
    }

    try {
      // التأكيد على العملية
      final confirmation = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('تأكيد الإيداع'),
          content:
          Text('هل أنت متأكد من إيداع مبلغ $amount ر.س للحساب المختار؟'),
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

      // 1. تحديث حالة المشروع إلى مكتمل
      await FirebaseFirestore.instance
          .collection('investmentOpportunities')
          .doc(widget.documentId)
          .update({
        'status': 'مكتملة', // Update status to completed
        'totalEarnings': amount,
      });

      // باقي الكود يبقى كما هو لتوزيع العوائد

      // Execute the batch updates
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
            Text('تم إيداع العوائد ونقل المشروع إلى القائمة المكتملة')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ أثناء توزيع العوائد: $e')),
      );
    }
  }
}