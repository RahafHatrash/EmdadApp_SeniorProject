import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../custom_bottom_nav_bar.dart';
import 'FarmDetails.dart';

class AllInvestments extends StatefulWidget {
  const AllInvestments({super.key});

  @override
  _AllInvestmentsState createState() => _AllInvestmentsState();
}

class _AllInvestmentsState extends State<AllInvestments> {
  int currentPage = 0;
  final int itemsPerPage = 5;
  int _selectedTab = 1; // 0 = Completed, 1 = Incomplete

  List<Map<String, dynamic>> completedInvestments = [];
  List<Map<String, dynamic>> incompleteInvestments = [];
  late Future<void> _investmentsFuture;

  @override
  void initState() {
    super.initState();
    _investmentsFuture = _fetchInvestments();
  }

  Future<void> _fetchInvestments() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('investmentOpportunities')
          .get();

      for (var doc in snapshot.docs) {
        Map<String, dynamic> investment = doc.data();
        investment['id'] = doc.id;

        if (investment['status'] == 'مكتملة') {
          completedInvestments.add(investment);
        } else if (investment['status'] == 'غير مكتملة' ||
            investment['status'] == 'تحت المعالجة') {
          incompleteInvestments.add(investment);
        }
      }
    } catch (e) {
      print("Error fetching investments: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9F8),
      body: FutureBuilder(
        future: _investmentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('حدث خطأ في تحميل البيانات'));
          }
          return _buildContent();
        },
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: -1,
        onTap: (index) {
          setState(() {
            // Add logic for page navigation if needed
          });
        },
      ),
    );
  }

  Widget _buildContent() {
    return Stack(
      children: [
        _buildAppBar(),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.24,
          left: 0,
          right: 0,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.32),
              Expanded(child: _buildInvestmentList()),
              _buildPaginationControls(),
            ],
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.25,
          left: 0,
          right: 0,
          child: Center(child: _buildSegmentedControl()),
        ),
        Positioned(
          top: 50,
          right: 15,
          child: IconButton(
            icon:
            const Icon(Icons.arrow_forward, color: Colors.white, size: 30),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.28,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF335D4F), Color(0xFFA8B475)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: const Center(
          child: Padding(
            padding: EdgeInsets.only(top: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'الفرص الاستثمارية',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  ',يمكنك هنا متابعة جميع الفرص الاستثمارية\n.ومراجعة التفاصيل المتعلقة بها',
                  style: TextStyle(fontSize: 12, color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSegmentedControl() {
    return Container(
      padding: const EdgeInsets.all(6),
      margin: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF335D4F), Color(0xFFA8B475)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTab(title: 'مكتملة', index: 0),
          _buildTab(title: 'غير مكتملة', index: 1),
        ],
      ),
    );
  }

  Widget _buildTab({required String title, required int index}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = index;
          currentPage = 0;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 30),
        decoration: BoxDecoration(
          color: _selectedTab == index
              ? const Color.fromARGB(92, 255, 255, 255)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: _selectedTab == index
                ? const Color.fromARGB(221, 255, 255, 255)
                : Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildInvestmentList() {
    List<Map<String, dynamic>> selectedInvestments =
    _selectedTab == 0 ? completedInvestments : incompleteInvestments;

    int start = currentPage * itemsPerPage;
    int end = start + itemsPerPage;
    List<Map<String, dynamic>> paginatedInvestments =
    selectedInvestments.sublist(
      start,
      end > selectedInvestments.length ? selectedInvestments.length : end,
    );

    if (paginatedInvestments.isEmpty) {
      return const Center(child: Text('.لا توجد فُرص استثمارية يتم عرضها'));
    }

    return ListView.builder(
      itemCount: paginatedInvestments.length,
      itemBuilder: (context, index) {
        final investment = paginatedInvestments[index];
        return _buildInvestmentOption(investment);
      },
    );
  }

  Widget _buildInvestmentOption(Map<String, dynamic> investment) {
    double targetAmount = investment['targetAmount'] ?? 0.0;
    double currentInvestment = investment['currentInvestment'] ?? 0.0;
    double remainingAmount = targetAmount - currentInvestment;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: investment['imageUrl'] != null
                ? Image.asset(
              investment['imageUrl'],
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            )
                : const Icon(Icons.broken_image, size: 80),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  investment['projectName'] ?? 'اسم غير متوفر',
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF345E50),
                  ),
                ),
                const SizedBox(height: 8),

                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FarmDetails(
                            imageUrl: investment['imageUrl'] ??
                                'assets/images/default.png',
                            title: investment['projectName'] ?? 'اسم غير متوفر',
                            farmData: investment,
                            projectId: investment['id'],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF335D4F), Color(0xFFA8B475)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 6.0, horizontal: 15.0),
                      child: const Text(
                        'التفاصيل',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaginationControls() {
    List<Map<String, dynamic>> selectedInvestments =
    _selectedTab == 0 ? completedInvestments : incompleteInvestments;
    int totalPages = (selectedInvestments.length / itemsPerPage).ceil();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (currentPage > 0)
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              setState(() {
                currentPage--;
              });
            },
          ),
        Text(
          '${currentPage + 1} / $totalPages',
          style: const TextStyle(fontSize: 12),
        ),
        if (currentPage < totalPages - 1)
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () {
              setState(() {
                currentPage++;
              });
            },
          ),
      ],
    );
  }
}
