import 'package:emdad_cpit499/StartPages/resetpassword.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  Future<void> checkEmailExists() async {
    final email = _emailController.text.trim();
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final userType = querySnapshot.docs[0].data()['userType'];

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PasswordResetPage(email: email, userType: userType),
          ),
        );
      } else {
        setState(() {
          errorMessage = 'البريد الإلكتروني غير موجود';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'حدث خطأ أثناء التحقق، حاول مرة أخرى.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAF9),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 60), // Space before the logos
                Image.asset('assets/images/Logo1.png', height: 70),
                const SizedBox(height: 15),
                Image.asset('assets/images/Logo2.png', height: 50),
                const SizedBox(height: 50),
                Expanded(
                  child: SingleChildScrollView(
                    child: Center(
                      child: Container(
                        width: 360,
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
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 24.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ShaderMask(
                                shaderCallback: (bounds) => const LinearGradient(
                                  colors: [
                                    Color(0xFF4B7960),
                                    Color(0xFF728F66),
                                    Color(0xFFA2AA6D),
                                  ],
                                ).createShader(
                                  Rect.fromLTWH(0.0, 0.0, bounds.width, bounds.height),
                                ),
                                child: const Text(
                                  'نسيت كلمة المرور',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: 'Markazi Text',
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'من فضلك ادخل البريد الإلكتروني المسجل لدى منصة إمداد لاستعادة الرقم السري الخاص بك',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                  fontFamily: 'Markazi Text',
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 24),
                              TextField(
                                controller: _emailController,
                                decoration: const InputDecoration(
                                  labelText: 'ادخل بريدك الإلكتروني',
                                  labelStyle: TextStyle(
                                    fontFamily: 'Markazi Text',
                                    color: Colors.grey,
                                  ),
                                  suffixIcon: Icon(
                                    Icons.email,
                                    color: Color(0xFF4B7960),
                                  ),
                                  border: UnderlineInputBorder(borderSide: BorderSide.none),
                                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                  contentPadding: EdgeInsets.only(right: 40.0),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                cursorColor: const Color(0xFF4B7960),
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                  fontFamily: 'Markazi Text',
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                height: 1,
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
                              if (errorMessage != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    errorMessage!,
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 14,
                                      fontFamily: 'Markazi Text',
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 60,
            right: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_forward,
                color: Colors.black,
                size: 30,
              ),
            ),
          ),
          Positioned(
            bottom: 220,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                height: 35,
                width: 150,
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
                  onPressed: checkEmailExists,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    shadowColor: Colors.transparent,
                  ),
                  child: const Text(
                    'إرسال',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Markazi Text',
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}