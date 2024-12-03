import 'package:flutter/material.dart';
import 'dart:async';

import 'WalletPage.dart';

/*class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bank Account Addition',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: AddBankAccountPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}*/

class AddBankAccountPage extends StatefulWidget {
  const AddBankAccountPage({super.key});

  @override
  _AddBankAccountPageState createState() => _AddBankAccountPageState();
}

class _AddBankAccountPageState extends State<AddBankAccountPage> {
  final TextEditingController _ibanController = TextEditingController();
  final TextEditingController _accountHolderController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();

  void _processAccountAddition() {
    // Validate input fields
    if (_ibanController.text.isEmpty ||
        _accountHolderController.text.isEmpty ||
        _bankNameController.text.isEmpty) {
      // Show an error message if any field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى ملء جميع الحقول المطلوبة.'),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoadingScreen()),
    );

    Timer(const Duration(seconds: 3), () {
      bool additionSuccess = DateTime.now().second % 2 == 0;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
          additionSuccess ? SuccessScreen() : SuccessScreen(),
        ),
      );
    });
  }

  Widget _buildStyledTextField(String labelText, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: labelText,
            hintStyle: const TextStyle(color: Color(0xFFA09E9E),fontSize: 14),
            border: InputBorder.none,
          ),
          style: const TextStyle(color: Color(0xFFA09E9E)),
          textAlign: TextAlign.right,
        ),
        Container(
          height: 1,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF4B7960),
                Color(0xFF728F66),
                Color(0xFFA2AA6D),
              ],
            ),
          ),
        ),
        const SizedBox(height: 25),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          buildBackgroundWithAppBar(
            context,
            'إضافة حساب بنكي',
            'لإضافة حساب بنكي جديد، يرجى إدخال المعلومات\n المطلوبة أدناه',
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 230),
                  Container(
                    padding: const EdgeInsets.all(20.0),
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
                        _buildStyledTextField('رقم الآيبان', _ibanController),
                        _buildStyledTextField('اسم العميل المطابق للحساب البنكي', _accountHolderController),
                        _buildStyledTextField('اسم البنك', _bankNameController),
                        const SizedBox(height: 30),
                        Center( // Centering the button
                          child: GradientButton(
                            text: 'إضافة الحساب',
                            onPressed: _processAccountAddition,
                          ),
                        ),
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
}

Widget buildBackgroundWithAppBar(BuildContext context, String title, String subtitle) {
  return Column(
    children: [
      ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        child: Container(
          height: 350,
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
          child: Stack(
            children: [
              Positioned(
                top: 60,
                right: 20,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 160.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        subtitle,
                        style: const TextStyle(fontSize: 14, color: Colors.white70),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
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
  );
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          buildBackgroundWithAppBar(
            context,
            'جاري التحميل',
            'جار التحقق من عملية إضافة الحساب...',
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 400,
              width: MediaQuery.of(context).size.width * 0.9,
              padding: const EdgeInsets.all(100.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF335D4F)),
                    strokeWidth: 6.0,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'يرجى الانتظار لحظات قليلة',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          buildBackgroundWithAppBar(
            context,
            'تمت إضافة الحساب',
            'تمت إضافة الحساب بنجاح. يمكنك العودة للصفحة الرئيسية.',
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 400,
              width: MediaQuery.of(context).size.width * 0.9,
              padding: const EdgeInsets.all(40.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/correct.png', height: 100, width: 100),
                  const SizedBox(height: 20),
                  const Text(
                    'تمت إضافة الحساب بنجاح',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF335D4F),
                    ),
                  ),
                  const SizedBox(height: 30),
                  GradientButton(
                    text: "العودة للصفحة الرئيسية",
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const WalletPage()), // Replace with your actual wallet page widget
                            (route) => false, // Removes all the previous routes
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const GradientButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        padding: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF335D4F), Color(0xFFA8B475)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}