import 'package:flutter/material.dart';

import '../FarmerHome/farmerHome.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAF9), // Set the background color
      body: Stack(
        children: [
          _buildAppBar(), // Custom app bar with gradient background
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 200), // Position the content lower on the screen
                _buildContainer(context), // Custom container with success message and button
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Custom App Bar Widget with gradient background and centered title
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
        child: Stack(
          children: [
            // Center-aligned title text
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 150.0),
                child: const Text(
                  'تأكيد عملية إضافة\nالمزرعة',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Custom container that shows success message and a button to navigate to the home page
  Widget _buildContainer(BuildContext context) {
    return Container(
      height: 500, // Container height for layout consistency
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 60), // Space before the icon
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF4B7960),
                    Color(0xFF728F66),
                    Color(0xFFA2AA6D),
                  ],
                ),
              ),
              padding: const EdgeInsets.all(20.0),
              child: const Icon(
                Icons.done,
                color: Colors.white,
                size: 120,
              ),
            ),
            const SizedBox(height: 30), // Space between icon and text
            const Text(
              'تم إضافة مزرعتك\n بنجاح',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFF527D62),
                fontFamily: 'Markazi Text',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50), // Space before the button
            // Button to navigate back to the home page
            Container(
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
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FarmerHomePage(),
                    ),
                  );
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
                  'الصفحة الرئيسية',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
