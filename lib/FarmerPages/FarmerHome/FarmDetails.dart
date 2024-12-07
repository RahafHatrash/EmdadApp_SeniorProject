import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../FarmerProfile/FarmerProfile.dart';
import 'farmerHome.dart';

class FarmDetails extends StatefulWidget {
  final String documentId; // معرف المستند في Firestore

  const FarmDetails({super.key, required this.documentId});

  @override
  _FarmDetailsScreenState createState() => _FarmDetailsScreenState();
}

class _FarmDetailsScreenState extends State<FarmDetails> {
  int _selectedBottomTabIndex =
      1; // Default selected tab (Agricultural Projects)

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
                  return const Center(
                      child: Text('لم يتم العثور على بيانات المشروع.'));
                }
                var FarmData = snapshot.data!.data() as Map<String, dynamic>;
                return farmDetails(FarmData: FarmData);
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
      backgroundColor: const Color(0xFFF8F9F8),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'حسابي'),
        BottomNavigationBarItem(
            icon: Icon(Icons.nature), label: 'المشاريع الزراعية'),
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
      ],
      currentIndex: _selectedBottomTabIndex,
      selectedItemColor: const Color(0xFF4B7960),
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        if (index == 0) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const Farmerprofile()));
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

class farmDetails extends StatelessWidget {
  final Map<String, dynamic> FarmData;

  const farmDetails({super.key, required this.FarmData});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    String imageUrl = FarmData['imageUrl'] ?? 'assets/images/12.png';

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
            icon:
                const Icon(Icons.arrow_forward, color: Colors.white, size: 30),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 15.0, vertical: 290.0),
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
          _buildFarmDetailsGrid(),
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
              FarmData['FarmName'] ?? 'مشروع زراعي',
              style: TextStyle(
                fontSize: screenWidth * 0.08,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF5B8263),
              ),
              textAlign: TextAlign.right,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.location_on, size: 15, color: Colors.grey),
                const SizedBox(width: 2),
                Text(
                  "saudi arabia, " + FarmData['region'] ?? 'غير معروف',
                  style: TextStyle(
                      fontSize: screenWidth * 0.03, color: Colors.grey),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFarmDetailsGrid() {
    double targetAmount = FarmData['targetAmount'] ?? 0.0;
    double currentInvestment = FarmData['currentInvestment'] ?? 0.0;
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
          FarmDetailItem(
              icon: Icons.grain,
              title: 'نوع المحصول',
              value: FarmData['cropType'] ?? 'غير محدد'),
          FarmDetailItem(
              icon: Icons.production_quantity_limits,
              title: 'معدل الإنتاج',
              value: FarmData['productionRate'] + "٪" ?? 'غير محدد'),
          FarmDetailItem(
              icon: Icons.bar_chart,
              title: 'المبلغ المتبقي',
              value: '${remainingAmount.toStringAsFixed(2)} ر.س'),
          FarmDetailItem(
              icon: Icons.grain,
              title: 'المساحة الكلية',
              value: FarmData['totalArea'] + "متر" ?? 'غير محدد'),
          FarmDetailItem(
              icon: Icons.grain,
              title: 'حالة الفرصة',
              value: FarmData['status'] ?? 'غير معروف'),
          FarmDetailItem(
              icon: Icons.grain,
              title: 'مدة الفرصة',
              value: FarmData['opportunityDuration'] ?? 'غير محدد'),
        ],
      ),
    );
  }

  Widget _buildFundingInformation(double screenWidth) {
    double targetAmount = FarmData['targetAmount'] ?? 0.0;
    double currentInvestment = FarmData['currentInvestment'] ?? 0.0;
    double fundingProgress = currentInvestment / targetAmount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'نسبة التمويل',
          style: TextStyle(
            fontSize: screenWidth * 0.05,
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
          style: TextStyle(fontSize: screenWidth * 0.03, color: Colors.grey),
        ),
      ],
    );
  }
}

class FarmDetailItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const FarmDetailItem({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

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
              fontSize: 13,
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
