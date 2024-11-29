import 'package:flutter/material.dart';
import 'dart:async';
import '../../../custom_bottom_nav_bar.dart';

// Main class for Payment Info Page
class PaymentInfoPage extends StatefulWidget {
  @override
  _PaymentInfoPageState createState() => _PaymentInfoPageState();
}

class _PaymentInfoPageState extends State<PaymentInfoPage> {
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _cvcController = TextEditingController();
  String _selectedExpirationDate = '01/24';

  // Function to process payment
  void _processPayment() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoadingScreen()),
    );

    Timer(Duration(seconds: 5), () {
      bool paymentSuccess = DateTime.now().second % 2 == 0;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              paymentSuccess ? SuccessScreen() : FailureScreen(),
        ),
      );
    });
  }

  // Method to build styled text fields
  Widget _buildStyledTextField(
      String labelText, TextEditingController controller,
      {bool isNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        TextField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            hintText: labelText,
            hintStyle: const TextStyle(color: Color(0xFFA09E9E)),
            border: InputBorder.none,
          ),
          style: const TextStyle(color: Color(0xFFA09E9E)),
        ),
        Container(
          height: 2,
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
        SizedBox(height: 20),
      ],
    );
  }

  // Method to build dropdown field for expiration date
  Widget _buildDropdownField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'تاريخ الإنتهاء',
          style: TextStyle(fontSize: 18, color: Color(0xFFA09E9E)),
        ),
        SizedBox(height: 10),
        DropdownButtonFormField<String>(
          value: _selectedExpirationDate,
          items: <String>['01/24', '02/24', '03/24', '04/24', '05/24']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: const TextStyle(color: Color(0xFFA09E9E)),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedExpirationDate = newValue!;
            });
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        Container(
          height: 2,
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
        SizedBox(height: 20),
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
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: double.infinity,
                  decoration: BoxDecoration(
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
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 40),
                  Text(
                    'عملية الدفع',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'لإكمال عملية الشحن، يرجى إدخال بيانات بطاقة الدفع الخاصة بك.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
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
                        _buildStyledTextField(
                            'رقم البطاقة', _cardNumberController,
                            isNumber: true),
                        _buildStyledTextField(
                            'اسم المستخدم', _userNameController),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 27), // Adjust top padding
                                child: _buildStyledTextField(
                                    'رمز التحقق (CVC)', _cvcController,
                                    isNumber: true),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: _buildDropdownField(),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: _processPayment,
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFF345E50),
                                  Color(0xFFA8B475),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                'التالي',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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
        ],
      ),
    );
  }
}

// Loading screen during payment processing
class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: double.infinity,
                  decoration: BoxDecoration(
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
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: EdgeInsets.all(100.0),
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
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFF335D4F)),
                    strokeWidth: 6.0,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'جارٍ التحقق من عملية الشحن، يرجى الانتظار لحظات قليلة...',
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 2,
        onTap: (index) {
          // You can add navigation logic here
        },
      ),
    );
  }
}

// Success screen after successful payment
class SuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: double.infinity,
                  decoration: BoxDecoration(
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
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: EdgeInsets.all(40.0),
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
                  Image.asset(
                    'assets /images/correct.png',
                    height: 100,
                    width: 100,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'تمت عملية السحب بنجاح',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4B7960)),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'تم تحويل المبلغ إلى حسابك بنجاح. نشكرك على استخدامك لخدمتنا',
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF4B7960),
                          Color(0xFF728F66),
                          Color(0xFFA2AA6D)
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        foregroundColor: Colors.white,
                      ),
                      child: Text("العودة للصفحة الرئيسية"),
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

// Failure screen after unsuccessful payment
class FailureScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: double.infinity,
                  decoration: BoxDecoration(
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
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Center(
            child: Container(
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
                  Icon(Icons.error, color: Colors.red, size: 100),
                  SizedBox(height: 20),
                  Text(
                    'فشلت عملية الدفع',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4B7960)),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'حدث خطأ أثناء عملية الدفع. يرجى المحاولة مرة أخرى أو التواصل مع الدعم الفني للمساعدة.',
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text("العودة للصفحة الرئيسية"),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text("حاول مرة أخرى"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 2,
        onTap: (index) {
          // You can add navigation logic here
        },
      ),
    );
  }
}
