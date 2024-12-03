import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emdad_cpit499/StartPages/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SignScreen();
  }
}

class SignScreen extends StatefulWidget {
  const SignScreen({super.key});

  @override
  _SignScreenState createState() => _SignScreenState();
}

class _SignScreenState extends State<SignScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  Future<void> _signInWithRole() async {
    setState(() {
      _errorMessage = null; // Clear previous error messages
    });

    String email = _emailController.text.trim();

    // Check if the email contains Arabic characters
    if (email.contains(RegExp(r'[\u0600-\u06FF]'))) {
      _showErrorDialog(
          'يرجى إدخال عنوان بريد إلكتروني صحيح (لا يسمح بالعربية)');
      return;
    }

    // Check if the email is badly formatted
    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email)) {
      _showErrorDialog('يرجى إدخال بريد إلكتروني صحيح');
      return;
    }

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: _passwordController.text.trim(),
      );

      User? user = userCredential.user;

      if (user == null) {
        _showErrorDialog('المستخدم غير موجود');
        return;
      }

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        String userType = userDoc['userType'];

        if (userType == 'مزارع') {
          Navigator.pushReplacementNamed(context, '/farmer');
        } else if (userType == 'مستثمر') {
          Navigator.pushReplacementNamed(context, '/investorPage');
        }
      } else {
        _showErrorDialog('المستخدم غير موجود في قاعدة البيانات');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        _showErrorDialog('يوجد خطأ في الايميل المدخل أو كلمة المرور');
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(message, textAlign: TextAlign.right),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('حسناً', textAlign: TextAlign.right),
            ),
          ],
        );
      },
    );
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
                              blurRadius: 7,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(26.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ShaderMask(
                                shaderCallback: (bounds) =>
                                    const LinearGradient(
                                  colors: [
                                    Color(0xFF4B7960),
                                    Color(0xFF728F66),
                                    Color(0xFFA2AA6D),
                                  ],
                                ).createShader(
                                  Rect.fromLTWH(
                                      0.0, 0.0, bounds.width, bounds.height),
                                ),
                                child: const Text(
                                  'تسجيل الدخول',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: 'Markazi Text',
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              buildInputField(
                                controller: _emailController,
                                label: 'البريد الإلكتروني',
                                icon: Icons.email,
                              ),
                              buildGradientLine(),
                              buildInputField(
                                controller: _passwordController,
                                label: 'كلمة المرور',
                                icon: Icons.lock,
                                isPassword: true,
                              ),
                              buildGradientLine(),
                              if (_errorMessage != null)
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    _errorMessage!,
                                    style: const TextStyle(
                                        color: Colors.red, fontSize: 16),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              const SizedBox(height: 10),
                              Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, '/forgetpassword');
                                  },
                                  child: const Text(
                                    'نسيت كلمة المرور؟',
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontFamily: 'Markazi Text',
                                    ),
                                  ),
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
            bottom: 150,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                children: [
                  Container(
                    height: 40,
                    width: 170,
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
                      onPressed: _signInWithRole,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        shadowColor: Colors.transparent,
                      ),
                      child: const Text(
                        'تسجيل الدخول',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Markazi Text',
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignupPage()),
                      );
                    },
                    child: const Text(
                      'ليس لديك حساب؟ إنشاء حساب',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Markazi Text',
                      ),
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

  Widget buildInputField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    bool isPassword = false,
  }) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            obscureText: isPassword,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            decoration: InputDecoration(
              labelText: label,
              alignLabelWithHint: true,
              border: const UnderlineInputBorder(borderSide: BorderSide.none),
              enabledBorder:
                  const UnderlineInputBorder(borderSide: BorderSide.none),
              focusedBorder:
                  const UnderlineInputBorder(borderSide: BorderSide.none),
            ),
            cursorColor: const Color(0xFF4B7960),
            style: const TextStyle(fontFamily: 'Markazi Text'),
          ),
        ),
        const SizedBox(width: 1),
        Icon(icon, color: const Color(0xFF4B7960)),
      ],
    );
  }

  Widget buildGradientLine() {
    return Container(
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
    );
  }
}
