import 'package:flutter/material.dart';

class LanguageChangeScreen extends StatelessWidget {
  const LanguageChangeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar with a title
      appBar: AppBar(
        title: const Text("تغيير اللغة"), // Screen title in Arabic
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Option to switch to Arabic
            ListTile(
              title: const Text(
                "العربية",
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                // Logic to switch to Arabic
              },
            ),
            const Divider(), // Divider between language options
            // Option to switch to English
            ListTile(
              title: const Text(
                "English",
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                // Logic to switch to English
              },
            ),
          ],
        ),
      ),
    );
  }
}
