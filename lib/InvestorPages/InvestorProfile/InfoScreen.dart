import 'package:flutter/material.dart';

// Main class for the Info Screen
class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAF9), // Light background color
      body: Stack(
        children: [
          // Large gradient background header with rounded bottom corners
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 320,
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
                  // Back button positioned at the top right of the header
                  Positioned(
                    top: 50,
                    right: 16,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_forward,
                          color: Colors.white, size: 30),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  // Title "عن إمداد" centered in the header
                  const Positioned(
                    top: 60,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text(
                        'عن إمداد',
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Markazi Text',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Main content area below the header
          Padding(
            padding: const EdgeInsets.only(
                top: 150), // Positions content below the header
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // White container with detailed information about إمداد
                  Container(
                    height: 500, // Increased height for a larger content area
                    padding: const EdgeInsets.all(24.0),
                    margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(33),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 5,
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Section title
                        Text(
                          'عن إمداد',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4B7960),
                            fontFamily: 'Markazi Text',
                          ),
                          textAlign: TextAlign.right,
                        ),
                        SizedBox(height: 10),
                        // First paragraph
                        Text(
                          'إمداد هي منصة تقدم خدمات متنوعة في مجالات الاستثمار والتطوير الزراعي، بهدف تمكين المستثمرين من المشاركة في الفرص الزراعية بطريقة مبتكرة وآمنة.',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.right,
                        ),
                        SizedBox(height: 10),
                        // Second paragraph
                        Text(
                          'من خلال إمداد، يمكنك الحصول على معلومات مفصلة حول المشاريع، وحالتها، وأداءها الدوري، كما نقدم خدمات لدعم المستثمرين وتوفير الأدوات اللازمة لاتخاذ قرارات استثمارية مستنيرة.',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.right,
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
