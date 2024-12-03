import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../main.dart';
import '../FarmerHome/farmerHome.dart';
import 'CustomerServiceScreen.dart';
import 'FAQscreen.dart';
import 'InfoScreen.dart';
import '../FarmerHome/projects_list.dart';
import 'FarmerTerms.dart';

class Farmerprofile extends StatefulWidget {
  const Farmerprofile({super.key});

  @override
  _FarmerprofileState createState() => _FarmerprofileState();
}

class _FarmerprofileState extends State<Farmerprofile> {
  int _selectedTabIndex = 0; // Default selected tab index
  String userName = ''; // To store the user's name

  @override
  void initState() {
    super.initState();
    _fetchUserName(); // Fetch user's name when the page loads
  }

  Future<void> _fetchUserName() async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      setState(() {
        userName =
            userDoc['name'] ?? 'اسم المستخدم'; // Default if name is not found
      });
    } catch (e) {
      print('Failed to fetch user name: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          _buildHeader(), // Profile header with user info
          Padding(
            padding: const EdgeInsets.only(top: 265, left: 20, right: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildProfileSettings(), // Profile settings section
                  const SizedBox(height: 15),
                  _buildLogoutButton(), // Logout button
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
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

          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Farmerprofile()),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProjectList()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FarmerHomePage()),
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
      ),
    );
  }

  // Profile header with avatar and user name
  Widget _buildHeader() {
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
                    userName, // Display fetched user name here
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

  // Profile settings section with options
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
              MaterialPageRoute(
                  builder: (context) => const CustomerServiceScreen()),
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

  // Widget for individual setting items
  Widget buildSettingsItem(
      BuildContext context, String title, IconData icon, VoidCallback onTap) {
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

  // Logout button
  Widget _buildLogoutButton() {
    return Container(
      width: 170,
      height: 40,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4B7960), Color(0xFF728F66), Color(0xFFA2AA6D)],
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
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Markazi Text'),
        ),
      ),
    );
  }

  // Show language change dialog
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

  // Show logout confirmation dialog
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
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B7960),
                  ),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildConfirmationButton(context, "الرجوع"),
                    _buildConfirmationButton(context, "تسجيل الخروج",
                        isLogout: true),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Show delete account confirmation dialog
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
                    _buildConfirmationButton(context, "حذف الحساب",
                        isDeleteAccount: true),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper method to build confirmation buttons for dialogs
  Widget _buildConfirmationButton(BuildContext context, String text,
      {bool isLogout = false, bool isDeleteAccount = false}) {
    return Container(
      width: 120, // Set a fixed width for the button
      height: 40, // Set a fixed height for the button
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
          if (isLogout) {
            _logoutUser();
          } else if (isDeleteAccount) {
            _deleteUserAccount();
          }
          Navigator.of(context).pop(); // Close the dialog
        },
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero, // Remove padding to respect fixed height
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12, // Adjust font size as needed
          ),
        ),
      ),
    );
  }

  // Method to log out the user
  Future<void> _logoutUser() async {
    try {
      await FirebaseAuth.instance.signOut(); // Sign out from Firebase
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const StartPage()), // Replace with your home page
        (route) => false,
      );
    } catch (e) {
      print('Error signing out: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('فشل تسجيل الخروج. حاول مرة أخرى.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Method to delete user account and all related data
  Future<void> _deleteUserAccount() async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;

      // Delete user document from Firestore
      await FirebaseFirestore.instance.collection('users').doc(userId).delete();

      // Delete all related data
      await _deleteRelatedData(userId);

      // Delete user from Firebase Auth
      await FirebaseAuth.instance.currentUser!.delete();

      // Navigate to the home page after deletion
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const StartPage()), // Replace with your home page
        (route) => false,
      );
    } catch (e) {
      print('Error deleting account: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('فشل حذف الحساب. حاول مرة أخرى.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Method to delete related data (wallets, investments, investment opportunities)
  Future<void> _deleteRelatedData(String userId) async {
    try {
      // Delete user-related wallets
      QuerySnapshot walletsSnapshot = await FirebaseFirestore.instance
          .collection('wallets')
          .where('userId', isEqualTo: userId)
          .get();

      for (var doc in walletsSnapshot.docs) {
        await doc.reference.delete();
      }

      // Delete user-related investments
      QuerySnapshot investmentsSnapshot = await FirebaseFirestore.instance
          .collection('investments')
          .where('userId', isEqualTo: userId)
          .get();

      for (var doc in investmentsSnapshot.docs) {
        await doc.reference.delete();
      }

      // Delete user-related investment opportunities
      QuerySnapshot investmentOpportunitiesSnapshot = await FirebaseFirestore
          .instance
          .collection('investmentOpportunities')
          .where('userId', isEqualTo: userId)
          .get();

      for (var doc in investmentOpportunitiesSnapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      print('Error deleting related data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('فشل حذف البيانات المرتبطة. حاول مرة أخرى.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
