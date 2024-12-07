import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emdad_cpit499/FarmerPages/FarmerHome/FarmsList.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../FarmerProfile/FarmerProfile.dart';

class FarmerHomePage extends StatefulWidget {
  const FarmerHomePage({super.key});

  @override
  _FarmerHomePageState createState() => _FarmerHomePageState();
}

class _FarmerHomePageState extends State<FarmerHomePage> {
  int _selectedTabIndex = 2; // Stores selected tab index
  final PageController _pageController = PageController(); // Controls the page view
  int _currentPage = 0; // Tracks the current page in PageView
  final userId =
      FirebaseAuth.instance.currentUser!.uid; // Get current user's ID

  @override
  void initState() {
    super.initState();
    // Adds a listener to update the current page index
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
  }

  // Functions to retrieve counts of projects
  Stream<int> _getTotalProjectsCount() {
    return FirebaseFirestore.instance
        .collection('investmentOpportunities')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Stream<int> _getCompletedProjectsCount() {
    return FirebaseFirestore.instance
        .collection('investmentOpportunities')
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: 'مكتملة')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Stream<int> _getInProcessProjectsCount() {
    return FirebaseFirestore.instance
        .collection('investmentOpportunities')
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: 'تحت المعالجة')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  final List<Map<String, String>> farmCards = [
    {
      'imageUrl': 'assets/images/news1.png',
      'date': '23/03/1446',
      'text':
          '"البيئة": المملكة تسجل رقمًا قياسًا بإنتاج 558 مليون كجم من لحوم الدواجن خلال النصف الأول 2024م',
      'additionalText': 'قراءة المزيد',
    },
    {
      'imageUrl': 'assets/images/news2.png',
      'date': '24/03/1446',
      'text':
          '"البيئة": المملكة تسجل رقمًا قياسًا بإنتاج 558 مليون كجم من لحوم الدواجن خلال النصف الأول 2024م',
      'additionalText': 'قراءة المزيد',
    },
    {
      'imageUrl': 'assets/images/news3.png',
      'date': '24/03/1446',
      'text':
          '"البيئة": المملكة تسجل رقمًا قياسًا بإنتاج 558 مليون كجم من لحوم الدواجن خلال النصف الأول 2024م',
      'additionalText': 'قراءة المزيد',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(color: Colors.white),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.31,
                decoration: const BoxDecoration(
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
                      Image.asset(
                        'assets/images/Logo1.png',
                        height: 70,
                      ),
                      const SizedBox(height: 8),
                      Image.asset(
                        'assets/images/Logo2.png',
                        height: 50,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.56,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(2, 3),
                          ),
                        ],
                      ),
                      child: const TextField(
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
                const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'نظرة عامة عن مشاريعك الزراعية',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF48742C),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 250,
                      height: 0.6,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    StreamBuilder<int>(
                      stream: _getCompletedProjectsCount(),
                      builder: (context, snapshot) {
                        return FarmDetailItem(
                          icon: Icons.check_circle,
                          title: '${snapshot.data ?? 0} مشاريع زراعية',
                          value: 'المشاريع الزراعية \nالمكتملة الأستثمار',
                        );
                      },
                    ),
                    StreamBuilder<int>(
                      stream: _getInProcessProjectsCount(),
                      builder: (context, snapshot) {
                        return FarmDetailItem(
                          icon: Icons.sync,
                          title: '${snapshot.data ?? 0} مشاريع زراعية',
                          value: 'المشاريع الزراعية \nالمفتوحة للأستثمار',
                        );
                      },
                    ),
                    StreamBuilder<int>(
                      stream: _getTotalProjectsCount(),
                      builder: (context, snapshot) {
                        return FarmDetailItem(
                          icon: Icons.list,
                          title: '${snapshot.data ?? 0} مشروع زراعي',
                          value: 'إجمالي المشاريع \nالزراعية المطروحة',
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'آخر الاخبار والأحداث',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF48742C),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 150,
                      height: 0.6,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                  ],
                ),
                SizedBox(
                  height: 240, // Adjusted height for the PageView
                  child: PageView(
                    controller: _pageController,
                    children: farmCards.map((card) {
                      return buildFarmCard(
                        imageUrl: card['imageUrl']!,
                        date: card['date']!,
                        text: card['text']!,
                        additionalText: card['additionalText']!,
                      );
                    }).toList(),
                  ),
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(farmCards.length, (index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPage == index
                              ? Colors.green
                              : Colors.grey,
                        ),
                      );
                    }),
                  ),
                ),
              ],
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
              MaterialPageRoute(builder: (context) => const FarmsList()),
            );
          } else if (index == 2) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const FarmerHomePage()),
              (route) => route.isFirst,
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

  Widget buildFarmCard({
    required String imageUrl,
    required String date,
    required String text,
    required String additionalText,
  }) {
    return Container(
      margin: const EdgeInsets.all(12),
      width: 300, // Set desired width for the card
      height: 180, // Set desired height for the card
      decoration: BoxDecoration(
        color: const Color(0xFFE5EAE3),
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
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
            child: Image.asset(
              imageUrl,
              width: double.infinity,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                color: Color(0xFF89A06E),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(7.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  additionalText,
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF89A06E),
                  ),
                ),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF89A06E),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
      padding: const EdgeInsets.all(12), // Padding for content
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Resize based on content
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 30, color: Colors.green.shade800), // Icon size
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 10, // Font size
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            softWrap: true,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 10, // Font size
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
            softWrap: true,
          ),
        ],
      ),
    );
  }
}
