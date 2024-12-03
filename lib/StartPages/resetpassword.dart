import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PasswordResetPage extends StatefulWidget {
  final String email;
  final String userType;

  const PasswordResetPage({super.key, required this.email, required this.userType});

  @override
  _PasswordResetPageState createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  String? errorMessage;
  bool _isLoading = false; // Track loading state

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  void _resetPassword() async {
    if (_isLoading) return; // Prevent multiple submissions
    setState(() {
      _isLoading = true; // Start loading
    });

    if (_newPasswordController.text == _confirmPasswordController.text) {
      final newPassword = _newPasswordController.text.trim();

      try {
        // Get the current user
        User? user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          // Prompt for re-authentication
          String password = await _promptForPassword();

          if (password.isEmpty) {
            setState(() {
              errorMessage = 'كلمة المرور الحالية مطلوبة.';
            });
            setState(() {
              _isLoading = false; // Stop loading
            });
            return; // Exit if no password was entered
          }

          // Re-authenticate the user
          AuthCredential credential = EmailAuthProvider.credential(
            email: user.email!,
            password: password,
          );

          await user.reauthenticateWithCredential(credential);
          // Update the user's password
          await user.updatePassword(newPassword);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم تحديث كلمة المرور بنجاح')),
          );

          // Navigate based on userType
          if (widget.userType == 'مزارع') {
            Navigator.pushReplacementNamed(context, '/farmer');
          } else if (widget.userType == 'مستثمر') {
            Navigator.pushReplacementNamed(context, '/investorPage');
          }
        } else {
          setState(() {
            errorMessage = 'المستخدم غير مسجل. حاول تسجيل الدخول.';
          });
        }
      } catch (e) {
        print("Error updating password: $e"); // Debugging line
        setState(() {
          errorMessage = 'حدث خطأ. حاول مرة أخرى.';
        });
      }
    } else {
      setState(() {
        errorMessage = 'كلمتا المرور غير متطابقتين';
      });
    }

    setState(() {
      _isLoading = false; // Stop loading
    });
  }

  Future<String> _promptForPassword() async {
    String password = "";

    await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        TextEditingController passwordController = TextEditingController();
        return AlertDialog(
          title: const Text('إعادة المصادقة'),
          content: TextField(
            controller: passwordController,
            decoration: const InputDecoration(hintText: "ادخل كلمة المرور الحالية"),
            obscureText: true,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                password = passwordController.text.trim();
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );

    return password;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background color
          Container(
            color: Colors.white, // Set background color to white
          ),
          // Main content
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0), // Adjust padding for logos
                child: Column(
                  children: [
                    // Back arrow
                    Padding(
                      padding: const EdgeInsets.only(right: 15, top: 5),
                      child: Align(
                        alignment: Alignment.topRight,
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
                    ),
                    // Add logos at the top
                    Image.asset('assets/images/Logo1.png', height: 70),
                    const SizedBox(height: 15), // Space between logos
                    Image.asset('assets/images/Logo2.png', height: 50),
                    const SizedBox(height: 50), // Space below logos
                    Container(
                      width: 352,
                      height: 350,
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
                              ).createShader(
                                Rect.fromLTWH(0.0, 0.0, bounds.width, bounds.height),
                              ),
                              child: const Text(
                                'كلمة المرور الجديدة',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: 'Markazi Text',
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Align(
                              alignment: Alignment.centerRight,
                              child: SizedBox(
                                width: 300,
                                child: TextFormField(
                                  controller: _newPasswordController,
                                  obscureText: true,
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontFamily: 'Markazi Text',
                                  ),
                                  decoration: const InputDecoration(
                                    labelText: 'ادخل كلمة المرور الجديدة',
                                    labelStyle: TextStyle(
                                      fontFamily: 'Markazi Text',
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                    suffixIcon: Icon(Icons.lock,
                                        color: Color(0xFF4B7960)),
                                    border: UnderlineInputBorder(
                                        borderSide: BorderSide.none),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide.none),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide.none),
                                  ),
                                ),
                              ),
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
                            const SizedBox(height: 16),
                            Align(
                              alignment: Alignment.centerRight,
                              child: SizedBox(
                                width: 300,
                                child: TextFormField(
                                  controller: _confirmPasswordController,
                                  obscureText: true,
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontFamily: 'Markazi Text',
                                  ),
                                  decoration: const InputDecoration(
                                    labelText: 'تأكيد كلمة المرور',
                                    labelStyle: TextStyle(
                                      fontFamily: 'Markazi Text',
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                    suffixIcon: Icon(Icons.lock,
                                        color: Color(0xFF4B7960)),
                                    border: UnderlineInputBorder(
                                        borderSide: BorderSide.none),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide.none),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide.none),
                                  ),
                                ),
                              ),
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
                            const SizedBox(height: 24),
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
                        onPressed: _isLoading ? null : _resetPassword, // Disable button if loading
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          shadowColor: Colors.transparent,
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                            : const Text(
                          'إعادة تعيين',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Markazi Text',
                          ),
                        ),
                      ),
                    ),
                    if (errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(
                          errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}