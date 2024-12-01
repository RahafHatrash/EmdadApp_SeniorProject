import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../FarmerProfile/FarmerProfile.dart';
import 'farmerHome.dart';

class ProjectDetailsScreen extends StatefulWidget {
  final String documentId; // معرف المستند في Firestore

  const ProjectDetailsScreen({super.key, required this.documentId});

  @override
  _ProjectDetailsScreenState createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  int _selectedBottomTabIndex = 1; // Default selected tab (Agricultural Projects)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9F8),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('investmentOpportunities')
                  .doc(widget.documentId)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Center(child: Text('لم يتم العثور على بيانات المشروع.'));
                }
                var projectData = snapshot.data!.data() as Map<String, dynamic>;
                return ProjectDetails(projectData: projectData);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  // Bottom navigation bar with three tabs
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
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const FarmerProfile()));
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
}

class ProjectDetails extends StatelessWidget {
  final Map<String, dynamic> projectData;

  const ProjectDetails({required this.projectData});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    String imageUrl = projectData['imageUrl'] ?? 'assets/images/12.png';

    return Stack(
      children: [
        // Background farm image
        Image.asset(
          imageUrl,
          width: double.infinity,
          height: screenHeight * 0.3,
          fit: BoxFit.cover,
        ),
        Container(
          width: double.infinity,
          height: screenHeight * 0.3,
          color: Colors.black.withOpacity(0.1),
        ),
        Positioned(
          top: 50,
          right: 10,
          child: IconButton(
            icon: const Icon(Icons.arrow_forward, color: Colors.white, size: 30),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 270.0),
          child: _buildDetailsContainer(context),
        ),
      ],
    );
  }

  Widget _buildDetailsContainer(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 7,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(screenWidth),
          const SizedBox(height: 10),
          _buildProjectDetailsGrid(),
          const SizedBox(height: 10),
          _buildFundingInformation(screenWidth),
        ],
      ),
    );
  }

  Widget _buildHeader(double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              projectData['projectName'] ?? 'مشروع زراعي',
              style: TextStyle(
                fontSize: screenWidth * 0.06,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF345E50),
              ),
              textAlign: TextAlign.right,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 2),
                Text(
                  "saudi arabia, "+ projectData['region'] ?? 'غير معروف',
                  style: TextStyle(fontSize: screenWidth * 0.035, color: Colors.grey),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProjectDetailsGrid() {
    double targetAmount = projectData['targetAmount'] ?? 0.0;
    double currentInvestment = projectData['currentInvestment'] ?? 0.0;
    double remainingAmount = targetAmount - currentInvestment;

    return SizedBox(
      height: 280,
      child: GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 1.0,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
        children: [
          ProjectDetailItem(
              icon: Icons.grain,
              title: 'نوع المحصول',
              value: projectData['cropType'] ?? 'غير محدد'),
          ProjectDetailItem(
              icon: Icons.production_quantity_limits,
              title: 'معدل الإنتاج',
              value: projectData['productionRate']+"٪" ?? 'غير محدد'),
          ProjectDetailItem(
              icon: Icons.bar_chart,
              title: 'المبلغ المتبقي',
              value: '${remainingAmount.toStringAsFixed(2)} ر.س'),
          ProjectDetailItem(
              icon: Icons.grain,
              title: 'المساحة الكلية',
              value: projectData['totalArea']+"متر" ?? 'غير محدد'),
          ProjectDetailItem(
              icon: Icons.grain,
              title: 'حالة الفرصة',
              value: projectData['status'] ?? 'غير معروف'),
          ProjectDetailItem(
              icon: Icons.grain,
              title: 'مدة الفرصة',
              value: projectData['opportunityDuration'] ?? 'غير محدد'),


        ],
      ),
    );
  }

  Widget _buildFundingInformation(double screenWidth) {
    double targetAmount = projectData['targetAmount'] ?? 0.0;
    double currentInvestment = projectData['currentInvestment'] ?? 0.0;
    double fundingProgress = currentInvestment / targetAmount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'نسبة التمويل',
          style: TextStyle(
            fontSize: screenWidth * 0.045,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF5B8263),
          ),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: fundingProgress.clamp(0.0, 1.0),
          minHeight: 5,
          backgroundColor: Colors.grey.withOpacity(0.2),
          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF335D4F)),
        ),
        const SizedBox(height: 8),
        Text(
          'المبلغ المستثمر: ${currentInvestment.toStringAsFixed(2)} ر.س من اصل ${targetAmount.toStringAsFixed(2)} ر.س',
          style: TextStyle(fontSize: screenWidth * 0.035, color: Colors.grey),
        ),
      ],
    );
  }
}

class ProjectDetailItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const ProjectDetailItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12.0),
      margin: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: const Color.fromARGB(255, 131, 176, 134)),
          const SizedBox(height: 0),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Color.fromARGB(255, 57, 98, 32),
            ),
          ),
          const SizedBox(height: 1),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 54, 88, 15),
            ),
          ),
        ],
      ),
    );
  }
}

