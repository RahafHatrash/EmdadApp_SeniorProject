import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage; // This will store error messages to display on screen

  Future<void> _signInWithRole() async {
    setState(() {
      _errorMessage = null; // Clear any previous error messages
    });

    try {
      // Attempt to sign in with Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      User? user = userCredential.user;

      // Check if user exists
      if (user == null) {
        setState(() {
          _errorMessage = 'المستخدم غير موجود';
        });
        return;
      }

      // Check the Firestore document for userType
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        String userType = userDoc['userType'];

        // Redirect based on userType
        if (userType == 'مزارع') {
          Navigator.pushReplacementNamed(context, '/farmer');
        } else if (userType == 'مستثمر') {
          Navigator.pushReplacementNamed(context, '/investorPage');
        }
      }

    } on FirebaseAuthException catch (e) {
      // Update the error message based on FirebaseAuthException codes
      setState(() {
        if (e.code == 'wrong-password') {
          _errorMessage = 'كلمة المرور غير صحيحة';
        } else if (e.code == 'user-not-found') {
          _errorMessage = 'المستخدم غير موجود';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAF9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9FAF9),
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
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
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        height: MediaQuery.of(context).size.height - 140,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg2.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 160.0),
            child: Column(
              children: [
                Container(
                  width: 352,
                  height: 380,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
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
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [
                              Color(0xFF4B7960),
                              Color(0xFF728F66),
                              Color(0xFFA2AA6D),
                            ],
                          ).createShader(Rect.fromLTWH(0.0, 0.0, bounds.width, bounds.height)),
                          child: const Text(
                            'تسجيل الدخول',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'Markazi Text',
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _emailController,
                                textAlign: TextAlign.right,
                                textDirection: TextDirection.rtl,
                                decoration: InputDecoration(
                                  labelText: 'أدخل بريدك الإلكتروني',
                                  alignLabelWithHint: true,
                                  border: UnderlineInputBorder(borderSide: BorderSide.none),
                                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                cursorColor: const Color(0xFF4B7960),
                                style: const TextStyle(fontFamily: 'Markazi Text'),
                              ),
                            ),
                            const SizedBox(width: 1),
                            Icon(Icons.email, color: Color(0xFF4B7960)),
                          ],
                        ),
                        const SizedBox(height: 1),
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
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _passwordController,
                                obscureText: true,
                                textAlign: TextAlign.right,
                                textDirection: TextDirection.rtl,
                                decoration: InputDecoration(
                                  labelText: 'أدخل كلمة مرور الخاصة بك',
                                  alignLabelWithHint: true,
                                  border: UnderlineInputBorder(borderSide: BorderSide.none),
                                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                ),
                                cursorColor: const Color(0xFF4B7960),
                                style: const TextStyle(fontFamily: 'Markazi Text'),
                              ),
                            ),
                            const SizedBox(width: 1),
                            Icon(Icons.lock, color: Color(0xFF4B7960)),
                          ],
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
                        const SizedBox(height: 10),
                        // Display the error message below the input fields
                        if (_errorMessage != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              _errorMessage!,
                              style: TextStyle(color: Colors.red, fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/forgetpassword');
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
                const SizedBox(height: 40),
                Container(
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
                    onPressed: () {
                      _signInWithRole();
                    },
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
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  child: const Text(
                    'ليس لديك حساب؟ إنشاء حساب',
                    style: TextStyle(
                      color: Colors.black54,
                      fontFamily: 'Markazi Text',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}