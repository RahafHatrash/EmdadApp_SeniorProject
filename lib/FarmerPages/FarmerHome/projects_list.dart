import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emdad_cpit499/FarmerPages/FarmerHome/projectDetails.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../DepositeOperation/deposit_returns.dart';
import '../FarmAdding/add_project.dart';
import '../FarmerProfile/FarmerProfile.dart';
import 'farmerHome.dart';

class ProjectList extends StatefulWidget {
  const ProjectList({super.key});

  @override
  _ProjectListState createState() => _ProjectListState();
}

class _ProjectListState extends State<ProjectList> {
  int _selectedTopTabIndex = 0; // Initial tab index
  int _selectedBottomTabIndex = 1; // Default selected bottom navigation tab
  final String? userId = FirebaseAuth.instance.currentUser?.uid; // الحصول على userId للمستخدم الحالي

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAF9),
      body: Stack(
        children: [
          _buildAppBar(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 200),
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.64,
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 70),
                          Expanded(
                            child: Scrollbar(
                              thickness: 5.0,
                              radius: Radius.circular(20),
                              child: SingleChildScrollView(
                                child: _buildProjectList(),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          _buildAddProjectButton(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 220,
            left: 0,
            right: 0,
            child: Center(child: _buildSegmentedControl()),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  // Define _buildAppBar method within _ProjectListState
  Widget _buildAppBar() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
      child: Container(
        height: 320,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF345E50), Color(0xFF49785E), Color(0xFFA8B475)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 150.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'المشاريع الزراعية',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'يمكنك هنا متابعة حالة كل فرصة، ومراجعة التفاصيل المتعلقة بها، وتحديث المعلومات.',
                    style: TextStyle(fontSize: 15, color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget to build the project list from Firestore based on user ID and status
  Widget _buildProjectList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('investmentOpportunities')
          .where('userId', isEqualTo: userId) // تصفية بناءً على userId
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("لا يوجد لديك أي مشروع زراعي"));
        }

        // تقسيم المشاريع حسب الحالة
        final projects = snapshot.data!.docs.where((doc) {
          final projectData = doc.data() as Map<String, dynamic>;
          return _selectedTopTabIndex == 0
              ? projectData['status'] == 'تحت المعالجة'
              : projectData['status'] == 'مكتملة';
        }).toList();

        return Column(
          children: projects.map((document) {
            final projectData = document.data() as Map<String, dynamic>;
            final documentId = document.id;

            return _buildProjectItem(
              imagePath: projectData['imageUrl'] ?? 'assets /images/farm1.png',
              title: projectData['projectName'] ?? 'مشروع زراعي',
              documentId: documentId,
            );
          }).toList(),
        );
      },
    );
  }

// باقي الكود يبقى بدون تعديل
// ...


// Widget for each project item
  // Widget for each project item
// Widget for each project item
  Widget _buildProjectItem({required String imagePath, required String title, required String documentId}) {
    // Check if the project status is 'In Process'
    final bool isInProcess = _selectedTopTabIndex == 0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.12),
              spreadRadius: 3,
              blurRadius: 4,
              offset: const Offset(0, 2), // تحديد اتجاه الظل
            ),
          ],
        ),
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(imagePath, width: 60, height: 60, fit: BoxFit.cover),
            ),
            const SizedBox(width: 15.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        color: Color(0xFF345E50), fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProjectDetailsScreen(documentId: documentId),
                            ),
                          );
                        },
                        child: const Text(
                          "...المزيد",
                          style: TextStyle(color: Color(0xFF345E50)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      if (isInProcess) _buildDepositButton(documentId),// Show the button only if in process
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  // Button for depositing returns
  // Button for depositing returns
  Widget _buildDepositButton(String documentId) {
    return Container(
      width: 90,
      height: 20,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF4B7960),
            Color(0xFF728F66),
            Color(0xFFA2AA6D),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DepositReturnsScreen(documentId: documentId),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        child: const Text(
          "إيداع الأرباح",
          style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }


  // Segmented control for toggling between "In Process" and "Completed" projects
  Widget _buildSegmentedControl() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF345E50), Color(0xFFA8B475)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTabButton('تحت المعالجة', 0),
          _buildTabButton('مكتملة', 1),
        ],
      ),
    );
  }

  // Tab button to switch between project states
  Widget _buildTabButton(String label, int index) {
    return GestureDetector(
      onTap: () => setState(() => _selectedTopTabIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
        decoration: BoxDecoration(
          color: _selectedTopTabIndex == index ? Colors.white54 : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15,
            color: _selectedTopTabIndex == index ? Color(0xFF345E50) : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Bottom navigation bar for different pages
  BottomNavigationBar _buildBottomNavigation() {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'حسابي'),
        BottomNavigationBarItem(icon: Icon(Icons.nature), label: 'المشاريع الزراعية'),
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
      ],
      currentIndex: _selectedBottomTabIndex,
      selectedItemColor: const Color(0xFF4B7960),
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        if (index == 0) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const Farmerprofile()));
        } else if (index == 1) {
          setState(() => _selectedBottomTabIndex = index);
        } else if (index == 2) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const FarmerHomePage()),
                (route) => route.isFirst,
          );
        }
      },
    );
  }

  // Button to add a new project
  Widget _buildAddProjectButton() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF4B7960), Color(0xFFA8B475)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(50),
        ),
        child: SizedBox(
          height: 35,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddProject()),
              );
            },
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
              "أضف مشروع",
              style: TextStyle(
                fontFamily: 'Markazi Text',
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
