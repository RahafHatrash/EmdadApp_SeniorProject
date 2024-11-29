import 'package:flutter/material.dart';
import 'dart:async';

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
        SnackBar(
          content: Text('يرجى ملء جميع الحقول المطلوبة.'),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoadingScreen()),
    );

    Timer(Duration(seconds: 3), () {
      bool additionSuccess = DateTime.now().second % 2 == 0;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
          additionSuccess ? SuccessScreen() : FailureScreen(),
        ),
      );
    });
  }

  Widget _buildStyledTextField(String labelText, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: labelText,
            hintStyle: const TextStyle(color: Color(0xFFA09E9E)),
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
        SizedBox(height: 25),
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
            'لإضافة حساب بنكي جديد، يرجى إدخال المعلومات المطلوبة أدناه',
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 200),
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
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
                        SizedBox(height: 30),
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
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        child: Container(
          height: 320,
          width: double.infinity,
          decoration: BoxDecoration(
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
                top: 50,
                right: 15,
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
                  padding: const EdgeInsets.only(bottom: 140.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        subtitle,
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
                boxShadow: [
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
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF335D4F)),
                    strokeWidth: 6.0,
                  ),
                  SizedBox(height: 20),
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
                boxShadow: [
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
                  SizedBox(height: 20),
                  Text(
                    'تمت إضافة الحساب بنجاح',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF335D4F),
                    ),
                  ),
                  SizedBox(height: 30),
                  GradientButton(
                    text: "العودة للصفحة الرئيسية",
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
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

class FailureScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          buildBackgroundWithAppBar(
            context,
            'فشلت عملية الإضافة',
            'حدث خطأ أثناء إضافة الحساب. حاول مرة أخرى.',
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
                boxShadow: [
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
                  Image.asset('assets/images/failure.png', height: 100, width: 100),
                  SizedBox(height: 20),
                  Text(
                    'فشلت عملية إضافة الحساب',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF335D4F),
                    ),
                  ),
                  SizedBox(height: 30),
                  GradientButton(
                    text: "العودة للصفحة الرئيسية",
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                  ),
                  SizedBox(height: 10),
                  GradientButton(
                    text: "حاول مرة أخرى",
                    onPressed: () {
                      Navigator.pop(context);
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

  GradientButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        padding: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF335D4F), Color(0xFFA8B475)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}