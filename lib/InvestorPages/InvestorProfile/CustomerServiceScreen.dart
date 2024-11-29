import 'package:flutter/material.dart';

// Main class for the Customer Service Screen
class CustomerServiceScreen extends StatelessWidget {
  const CustomerServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAF9), // Light background color
      body: Stack(
        children: [
          // Gradient background header
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
                  // Back button to navigate to the previous screen
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
                  // Title "خدمة العملاء" centered on the header
                  const Positioned(
                    top: 60,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text(
                        'خدمة العملاء',
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
          // Main content area for chat messages and input field
          Positioned.fill(
            top: 120,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  // Container for displaying chat messages
                  Expanded(
                    child: Container(
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
                      padding: const EdgeInsets.all(16),
                      child: ListView(
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.green.shade100,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "اهلا بكم في إمداد",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "كيف نقدر نخدمكم؟",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Additional messages can be added here
                        ],
                      ),
                    ),
                  ),
                  // Input area with text field and send button
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        // Text field for user to type their message
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'اكتب هنا...',
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 16),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade200,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Send button with gradient background
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF4B7960),
                                Color(0xFF728F66),
                                Color(0xFFA2AA6D),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.send, color: Colors.white),
                            onPressed: () {
                              // Implement send message functionality here
                            },
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
