import 'package:flutter/material.dart';

class CardInfoScreen extends StatelessWidget {
  const CardInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAF9), // Set background color for the screen
      body: Stack(
        children: [
          // Top gradient background for header
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
                // Back button positioned at the top right
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
                // Header text aligned to the bottom center
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 145.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'عملية الدفع', // Main title
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'لإكمال عملية الدفع، يرجى إدخال بيانات بطاقة الدفع\n الخاصة بك بشكل دقيق.',
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

          // Main content section with white background
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
                        const SizedBox(height: 10),
                        _buildTextField('رقم البطاقة'), // Card number field
                        const SizedBox(height: 20),
                        _buildTextField('اسم المستخدم'), // User name field
                        const SizedBox(height: 20),
                        // Row for CVC and expiration date fields
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  const SizedBox(height: 8),
                                  _buildTextField('رمز التحقق (CVC)'), // CVC field
                                ],
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: _buildDropdownField(
                                'تاريخ الإنتهاء',
                                _buildYearsList(), // Expiration date dropdown
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        _buildNextButton(context), // Button to proceed
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

  // Reusable method to build a text field with an underline gradient
  Widget _buildTextField(String labelText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            hintText: labelText,
            hintStyle: const TextStyle(color: Color(0xFFA09E9E)),
            border: InputBorder.none,
          ),
          style: const TextStyle(color: Color(0xFFA09E9E)),
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
      ],
    );
  }

  // Dropdown field for selecting expiration date
  Widget _buildDropdownField(String labelText, List<String> items) {
    String? selectedValue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          value: selectedValue,
          onChanged: (String? newValue) {
            selectedValue = newValue;
          },
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: const TextStyle(color: Color(0xFFA09E9E)),
                textAlign: TextAlign.right,
              ),
            );
          }).toList(),
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: const TextStyle(color: Color(0xFFA09E9E)),
            border: InputBorder.none,
          ),
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
      ],
    );
  }

  // Builds a list of years for the expiration date dropdown
  List<String> _buildYearsList() {
    final currentYear = DateTime.now().year;
    return List<String>.generate(
      20, // Generates the next 20 years
          (index) => (currentYear + index).toString(),
    );
  }

  // Button to navigate to the payment process screen
  Widget _buildNextButton(BuildContext context) {
    return Center(
      child: Container(
        width: 200,
        height: 40,
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
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/payment-process'); // Navigates to payment process
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
            ),
          ),
          child: const Text(
            'التالي', // Button text
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
}
