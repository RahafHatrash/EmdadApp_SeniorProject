import 'package:emdad_cpit499/InvestorPages/InvestorProfile/InvestorTerms.dart';
import 'package:flutter/material.dart';
import 'FarmerPages/DepositeOperation/card_info.dart';
import 'FarmerPages/DepositeOperation/payment_process.dart';
import 'FarmerPages/FarmerHome/farmerHome.dart';
import 'FarmerPages/FarmerHome/projects_list.dart';
import 'FarmerPages/FarmerProfile/CustomerServiceScreen.dart';
import 'FarmerPages/FarmerProfile/FAQscreen.dart';
import 'FarmerPages/FarmerProfile/InfoScreen.dart';
import 'FarmerPages/FarmerProfile/FarmerProfile.dart';
import 'FarmerPages/FarmerProfile/FarmerTerms.dart';
import 'InvestorPages/InvestorHome/InvestorHome.dart';
import 'StartPages/Loginpage.dart';
import 'StartPages/forgetpassword.dart';
import 'StartPages/signup.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Markazi Text', // Global font family
      ),
      initialRoute: '/', // Set initial route
      routes: {
        '/': (context) => StartPage(),
        '/farmer': (context) => FarmerHomePage(),
        '/login': (context) => const LoginPage(),
        '/forgetpassword': (context) => const ForgotPasswordScreen(),
        '/signup': (context) => const SignupPage(),
        '/investorPage': (context) => InvestorHome(),

        // Farmer-related routes
        '/home': (context) => const FarmerHomePage(),
        '/FarmerProfile': (context) => const Farmerprofile(),
        '/ProjectList': (context) => const ProjectList(),
        '/account': (context) => const InfoScreen(),
        '/customer_service': (context) => const CustomerServiceScreen(),
        '/FAQ': (context) => const FAQscreen(),
        '/farmerterms': (context) => const farmerTerms(),
        '/investorterms': (context) => const investorTerms(),

        // Payment-related routes
        '/card_info': (context) => const CardInfoScreen(),
        '/payment-process': (context) => PaymentStatusPage(),
      },
    );
  }
}

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              "assets/images/FirstBg.png",
              fit: BoxFit.cover,
            ),
          ),
          // White Rounded Container
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  // Small line at the top
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  SizedBox(height: 30),
                  // Buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Column(
                      children: [
                        CustomButton(
                          text: 'تسجيل الدخول',
                          onPressed: () {
                            Navigator.pushNamed(context, '/login');
                          },
                        ),
                        SizedBox(height: 15),
                        CustomButton(
                          text: ' تسجيل',
                          onPressed: () {
                            Navigator.pushNamed(context, '/signup');
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  // Divider with text
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Colors.grey[400],
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'أو التسجيل مع',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Markazi Text',
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.grey[400],
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Social login buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Image.asset(
                          "assets/icons/googleIcon.png",
                          width: 24,
                          height: 24,
                        ),
                        onPressed: () {
                          // Google login logic
                        },
                      ),
                      IconButton(
                        icon: Image.asset(
                          "assets/icons/appleIcon.png",
                          width: 24,
                          height: 24,
                        ),
                        onPressed: () {
                          // Apple login logic
                        },
                      ),
                      IconButton(
                        icon: Image.asset(
                          'assets/icons/phoneIcon.png',
                          width: 24,
                          height: 24,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/phoneVerification');
                        },
                      ),
                    ],
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

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF335D4F), Color(0xFFA8B475)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Markazi Text',
          ),
        ),
      ),
    );
  }
}
