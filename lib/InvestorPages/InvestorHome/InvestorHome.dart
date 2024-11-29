import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../custom_bottom_nav_bar.dart';
import 'Allinvestments.dart';
import 'FarmDetails.dart';
import 'Myinvestments.dart';

class InvestorHome extends StatefulWidget {
  @override
  _InvestorHomeState createState() => _InvestorHomeState();
}

class _InvestorHomeState extends State<InvestorHome> {
  int _currentPage = 4;
  final PageController _pageController = PageController(viewportFraction: 0.85);

  // Method to fetch the top 3 completed investments from Firestore
  Future<List<Map<String, dynamic>>> fetchTopCompletedInvestments() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('investmentOpportunities')
        .where('status',
        isEqualTo: 'تحت المعالجة') // Filter for completed investments
        .limit(4) // Limit to 4 items
        .get();

    // Convert documents to a list of maps, including document ID
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id; // Add document ID to the data
      return data;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(color: Color(0xFFF9FAF9)),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.35,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF335D4F), Color(0xFFA8B475)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Center(
                child: Column(
                  children: [
                    Image.asset('assets/images/Logo1.png', height: 70),
                    SizedBox(height: 15),
                    Image.asset('assets/images/Logo2.png', height: 50),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.58,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(2, 3),
                        ),
                      ],
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon:
                        Icon(Icons.search, color: Colors.grey, size: 20),
                        hintText: 'ابحث',
                        border: InputBorder.none,
                        contentPadding:
                        EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.40,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AllInvestments()),
                    );
                  },
                  child: Text(
                    'شاهد المزيد',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF355E4F),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                Text(
                  'الفرص الاستثمارية',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(216, 53, 94, 79),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.46,
          left: 0,
          right: 0,
          child: Container(
            height: 340, // Set your desired height for the white box here
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchTopCompletedInvestments(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('لا يوجد أي فرصة مطروحة بعد.'));
                }

                List<Map<String, dynamic>> investments = snapshot.data!;

                return PageView(
                  controller: _pageController,
                  children: investments.map((investment) {
                    return InvestmentCard(
                      imageUrl:
                      investment['imageUrl'] ?? 'assets/images/default.png',
                      title: investment['projectName'] ?? 'Unknown Project',
                      status: investment['status'] ?? 'Unknown',
                      duration: investment['opportunityDuration'] ?? 'Unknown',
                      returnRate: '20%',
                      coverage: investment['totalArea'] ?? 'N/A',
                      onDetailsPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FarmDetails(
                              imageUrl: investment['imageUrl'] ?? 'assets/images/default.png',
                              title: investment['projectName'] ?? 'اسم غير متوفر',
                              farmData: investment,
                              projectId: investment['id'],
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ),
      ]),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentPage,
        onTap: (index) {
          setState(() {
            _currentPage = index;
            if (index == 2) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyInvestments()));
            } else if (index == 4) {
              _pageController.jumpToPage(0);
            }
          });
        },
      ),
    );
  }
}

// Widget for displaying individual investment opportunities as cards
class InvestmentCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String status;
  final String duration;
  final String returnRate;
  final String coverage;
  final VoidCallback onDetailsPressed;

  const InvestmentCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.status,
    required this.duration,
    required this.returnRate,
    required this.coverage,
    required this.onDetailsPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: Card(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Card image section
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.asset(
                  imageUrl,
                  fit: BoxFit.cover,
                  height: 140,
                  width: double.infinity,
                ),
              ),

              // Investment details
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(218, 73, 120, 94),
                      ),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 5),

                    // Details button
                    ElevatedButton(
                      onPressed: onDetailsPressed,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child: SizedBox(
                        width: 130,
                        height: 40,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF345E50), Color(0xFFA8B475)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              'تفاصيل المزرعة',
                              style:
                              TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Divider(),

                    // Investment stats like status, duration, return rate, and coverage
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _InvestmentStat(title: 'حالة الفرصة', value: status),
                        _InvestmentStat(title: 'مدة الفرصة', value: duration),
                        _InvestmentStat(title: ' العائد المتوقع', value: returnRate),

                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Helper widget for displaying individual investment stats
class _InvestmentStat extends StatelessWidget {
  final String title;
  final String value;

  const _InvestmentStat({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 14, color: Color(0xFF49785E)),
        ),
        Text(
          value,
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF89A06E)),
        ),
      ],
    );
  }
}
