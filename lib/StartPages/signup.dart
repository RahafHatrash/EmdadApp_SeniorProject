import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emdad_cpit499/StartPages/phoneVerification.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'Loginpage.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

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
  String? _selectedRole;
  final List<String> _roles = ['مزارع', 'مستثمر'];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAF9),
      resizeToAvoidBottomInset: false,
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
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg2.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 170),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 350,
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
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
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
                              Rect.fromLTWH(
                                  0.0, 0.0, bounds.width, bounds.height),
                            ),
                            child: const Text(
                              'حساب جديد',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Markazi Text',
                              ),
                            ),
                          ),
                          buildInputField(
                            controller: _nameController,
                            label: 'الاسم الأول والأخير',
                            icon: Icons.person,
                          ),
                          buildGradientLine(),
                          buildInputField(
                            controller: _emailController,
                            label: 'البريد الإلكتروني',
                            icon: Icons.email,
                          ),
                          buildGradientLine(),
                          buildInputField(
                            controller: _phoneController,
                            label: 'رقم الجوال',
                            icon: Icons.phone,
                          ),
                          buildGradientLine(),
                          buildInputField(
                            controller: _passwordController,
                            label: 'كلمة المرور',
                            icon: Icons.lock,
                            isPassword: true,
                          ),
                          buildGradientLine(),
                          buildInputField(
                            controller: _confirmPasswordController,
                            label: 'تأكيد كلمة المرور',
                            icon: Icons.lock_outline,
                            isPassword: true,
                          ),
                          buildGradientLine(),
                          SizedBox(
                            height: 50,
                            child: DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                labelText: 'هل أنت مزارع أم مستثمر؟',
                                alignLabelWithHint: true,
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide.none),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide.none),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide.none),
                              ),
                              value: _selectedRole,
                              items: _roles.map((String role) {
                                return DropdownMenuItem<String>(
                                  value: role,
                                  child: Text(role,
                                      textAlign: TextAlign.right,
                                      style: const TextStyle(
                                          fontFamily: 'Markazi Text')),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedRole = newValue;
                                });
                              },
                              style: const TextStyle(
                                  color: Color(0xFF4B7960),
                                  fontFamily: 'Markazi Text'),
                            ),
                          ),
                          const SizedBox(height: 1),
                          buildGradientLine(),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                children: [
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
                      onPressed: () async {
                        if (_validateInputs()) {
                          // Inside the onPressed method where you create the user
                          try {
                            UserCredential userCredential = await FirebaseAuth
                                .instance
                                .createUserWithEmailAndPassword(
                              email: _emailController.text.trim(),
                              password: _passwordController.text.trim(),
                            );

                            String userId = userCredential.user!.uid;

                            // Navigate to PhoneVerification with user data
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PhoneVerification(
                                  userId: userId,
                                  name: _nameController.text.trim(),
                                  email: _emailController.text.trim(),
                                  phone: _phoneController.text.trim(),
                                  userType: _selectedRole!,
                                ),
                              ),
                            );
                          } on FirebaseAuthException catch (e) {
                            String message;
                            switch (e.code) {
                              case 'weak-password':
                                message = 'كلمة المرور ضعيفة جداً';
                                break;
                              case 'email-already-in-use':
                                message = 'البريد الإلكتروني مستخدم بالفعل';
                                break;
                              default:
                                message = 'خطأ في إنشاء الحساب: ${e.message}';
                            }
                            _showAlert(message);
                          } catch (e) {
                            _showAlert('خطأ غير متوقع: $e');
                          }
                        }
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
                        'إنشاء حساب',
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
                            builder: (context) => const LoginPage()),
                      );
                    },
                    child: const Text(
                      'يوجد لديك حساب؟ تسجيل الدخول',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
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

  bool _validateInputs() {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();
    String phone = _phoneController.text.trim();

    if (email.isEmpty || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      _showAlert('يرجى إدخال بريد إلكتروني صحيح');
      return false;
    }

    if (phone.isEmpty || phone.length < 10) {
      _showAlert('يرجى إدخال رقم جوال صحيح');
      return false;
    }

    if (password.isEmpty || password.length < 6) {
      _showAlert('يجب أن تتكون كلمة المرور من 6 أحرف على الأقل');
      return false;
    }

    if (password != confirmPassword) {
      _showAlert('كلمة المرور وتأكيد كلمة المرور غير متطابقتين');
      return false;
    }

    if (_selectedRole == null) {
      _showAlert('يرجى اختيار نوع المستخدم');
      return false;
    }

    return true;
  }

  void _showAlert(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('خطأ'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('موافق'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
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
