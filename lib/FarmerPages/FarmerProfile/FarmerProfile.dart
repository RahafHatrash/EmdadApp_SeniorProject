import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emdad_cpit499/FarmerPages/FarmerProfile/FarmerTerms.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../main.dart';
import '../FarmerHome/farmerHome.dart';
import '../FarmerHome/projects_list.dart';
import 'CustomerServiceScreen.dart';
import 'FAQscreen.dart';
import 'InfoScreen.dart';

class Farmerprofile extends StatefulWidget {
  const Farmerprofile({super.key});

  @override
  _FarmerprofileState createState() => _FarmerprofileState();
}

class _FarmerprofileState extends State<Farmerprofile> {
  int _selectedTabIndex = 0; // الفئة الافتراضية هي "حسابي"
  String userName = ''; // لتخزين اسم المستخدم

  @override
  void initState() {
    super.initState();
    _fetchUserName(); // جلب اسم المستخدم عند تحميل الصفحة
  }

  // دالة لجلب اسم المستخدم من Firestore
  Future<void> _fetchUserName() async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      setState(() {
        userName = userDoc['name'] ?? 'اسم المستخدم'; // قيمة افتراضية إذا لم يتم العثور على الاسم
      });
    } catch (e) {
      print('فشل في جلب اسم المستخدم: $e');
    }
  }

  // دالة لحذف حساب المستخدم والبيانات المتعلقة به
  Future<void> _deleteUserAccount() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("لا يوجد مستخدم مسجّل دخول حاليًا.");
      }

      final userId = user.uid;

      // حذف وثيقة المستخدم من Firestore
      await FirebaseFirestore.instance.collection('users').doc(userId).delete();

      // حذف الاستثمارات المتعلقة بالمستخدم
      final investments = await FirebaseFirestore.instance.collection('investments').where('userId', isEqualTo: userId).get();
      for (var doc in investments.docs) {
        await doc.reference.delete();
      }

      // حذف فرص الاستثمار المتعلقة بالمستخدم
      final investmentOpportunities = await FirebaseFirestore.instance.collection('investmentOpportunities').where('userId', isEqualTo: userId).get();
      for (var doc in investmentOpportunities.docs) {
        await doc.reference.delete();
      }

      // حذف المستخدم من Firebase Auth
      await user.delete(); // هذه السطر يقوم بحذف المستخدم من Firebase Auth

      // إعادة التوجيه إلى صفحة البداية بعد الحذف الناجح
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => StartPage()),
            (route) => false,
      );
    } catch (e) {
      print('خطأ في حذف الحساب: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فشل في حذف الحساب، حاول مرة أخرى')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAF9),
      body: Stack(
        children: [
          _buildAppBar(), // رأس صفحة الملف الشخصي مع معلومات المستخدم
          Padding(
            padding: const EdgeInsets.only(top: 250, left: 20, right: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildProfileSettings(), // خيارات إعدادات الملف الشخصي
                  const SizedBox(height: 20),
                  _buildLogoutButton(), // زر تسجيل الخروج
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(), // شريط التنقل السفلي
    );
  }

  // رأس الصفحة مع أيقونة الملف الشخصي واسم المستخدم
  Widget _buildAppBar() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
      child: Container(
        height: 320,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF345E50), Color(0xFF49785E), Color(0xFFA8B475)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 70,
                      color: Color(0xFF345E50),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    userName, // عرض اسم المستخدم الذي تم جلبه هنا
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Markazi Text',
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // قائمة عناصر إعدادات الملف الشخصي
  Widget _buildProfileSettings() {
    return Container(
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
      child: Column(
        children: [
          buildSettingsItem(
            context,
            "تغيير اللغة",
            Icons.language,
                () => _showLanguageChangeDialog(context),
          ),
          buildSettingsItem(
            context,
            "تواصل معنا",
            Icons.contact_support,
                () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CustomerServiceScreen()),
            ),
          ),
          buildSettingsItem(
            context,
            "الأسئلة الشائعة",
            Icons.security,
                () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FAQscreen()),
            ),
          ),
          buildSettingsItem(
            context,
            "الشروط والأحكام",
            Icons.rule,
                () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const farmerTerms()),
            ),
          ),
          buildSettingsItem(
            context,
            "عن إمداد",
            Icons.info,
                () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const InfoScreen()),
            ),
          ),
          buildSettingsItem(
            context,
            "حذف الحساب",
            Icons.delete,
                () => _showDeleteAccountConfirmationDialog(context),
          ),
        ],
      ),
    );
  }

  // عنصر إعداد واحد مع أيقونة، عنوان، وإجراء onTap
  Widget buildSettingsItem(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 5.0),
      leading: Icon(icon, color: const Color(0xFF4B7960)),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          color: Color(0xFF4B7960),
          fontFamily: 'Markazi Text',
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xFF4B7960)),
      onTap: onTap,
    );
  }

  // زر تسجيل الخروج مع خلفية متدرجة
  Widget _buildLogoutButton() {
    return Container(
      width: 150,
      height: 40,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF4B7960),
            Color(0xFF728F66),
            Color(0xFFA2AA6D),
          ],
        ),
        borderRadius: BorderRadius.circular(50),
      ),
      child: ElevatedButton(
        onPressed: () => _showLogoutConfirmationDialog(context),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 1),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        child: const Text(
          "تسجيل الخروج",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Markazi Text',
          ),
        ),
      ),
    );
  }

  // شريط التنقل السفلي
  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: Colors.green.shade800,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      currentIndex: _selectedTabIndex,
      onTap: (index) {
        setState(() {
          _selectedTabIndex = index;
        });

        // الانتقال إلى شاشات مختلفة بناءً على الفهرس المحدد
        if (index == 0) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Farmerprofile()),
                (route) => false,
          );
        } else if (index == 1) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const ProjectList()),
                (route) => false,
          );
        } else if (index == 2) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const FarmerHomePage()),
                (route) => false,
          );
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'حسابي',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.nature),
          label: 'مشاريعي الزراعية',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'الرئيسية',
        ),
      ],
    );
  }

  // حوار تغيير اللغة
  void _showLanguageChangeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "تغيير اللغة",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B7960),
                  ),
                ),
                const Divider(),
                ListTile(
                  title: const Text("العربية", style: TextStyle(fontSize: 18)),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                const Divider(),
                ListTile(
                  title: const Text("English", style: TextStyle(fontSize: 18)),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // حوار تأكيد حذف الحساب
  void _showDeleteAccountConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "هل أنت متأكد من حذف الحساب؟",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B7960),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildConfirmationButton(context, "الرجوع"),
                    _buildConfirmationButton(
                        context, "حذف الحساب", isDeleteAccount: true),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // حوار تأكيد تسجيل الخروج
  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "هل أنت متأكد من تسجيل الخروج؟",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B7960),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildConfirmationButton(context, "الرجوع"),
                    _buildConfirmationButton(
                      context,
                      "تسجيل الخروج",
                      isLogout: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // دالة مساعدة لبناء أزرار التأكيد للحوار
  Widget _buildConfirmationButton(BuildContext context, String text,
      {bool isLogout = false, bool isDeleteAccount = false}) {
    return Container(
      width: 120,
      height: 40,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF4B7960),
            Color(0xFF728F66),
            Color(0xFFA2AA6D),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextButton(
        onPressed: () {
          Navigator.of(context).pop(); // إغلاق الحوار
          if (isLogout) {
            _logoutUser();
          } else if (isDeleteAccount) {
            _deleteUserAccount(); // استدعاء دالة حذف الحساب
          }
        },
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  // دالة لتسجيل خروج المستخدم
  Future<void> _logoutUser() async {
    try {
      await FirebaseAuth.instance.signOut(); // تسجيل الخروج من Firebase
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => StartPage()), // استبدل بصفحتك الرئيسية
            (route) => false,
      );
    } catch (e) {
      print('خطأ في تسجيل الخروج: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('فشل تسجيل الخروج. حاول مرة أخرى.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}