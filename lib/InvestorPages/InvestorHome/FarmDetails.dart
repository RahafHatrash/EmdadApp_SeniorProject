import 'package:flutter/material.dart';
import '../../custom_bottom_nav_bar.dart';
import '../InvestmentProccess/InvestOperation.dart';

class FarmDetails extends StatelessWidget {
  final String imageUrl;
  final String title;
  final Map<String, dynamic> farmData;
  final String projectId;

  FarmDetails({
    required this.imageUrl,
    required this.title,
    required this.farmData,
    required this.projectId,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9F8),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top image with overlay and back button
            Stack(
              children: [
                Image.asset(
                  imageUrl,
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.3,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.broken_image, size: 50);
                  },
                ),
                // Dark overlay on image
                Container(
                  width: double.infinity,
                  height: screenHeight * 0.3,
                  color: Colors.black.withOpacity(0.1),
                ),
                // Back button
                Positioned(
                  top: 50,
                  right: 15,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_forward,
                        color: Colors.white, size: 30),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),

            // Main details container
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
              child: Container(
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
                    // Investment button and title with location
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // زر استثمر الآن (يظهر فقط إذا لم يكن المشروع مكتملًا)
                        if (farmData['status'] != 'مكتملة')
                          Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF345E50), Color(0xFFA8B475)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: SizedBox(
                              height: 30,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Investoperation(
                                        projectName: farmData['projectName'],
                                        projectId: projectId,
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  padding: const EdgeInsets.symmetric(horizontal: 25),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                ),
                                child: const Text(
                                  'استثمر الآن',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        // عنوان المشروع وحالة المشروع
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  if (farmData['status'] == 'مكتملة' && farmData['profitDeposited'] == true)
                                    Container(
                                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Text(
                                        'مكتملة',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  else if (farmData['status'] == 'مكتملة' && farmData['profitDeposited'] == false)
                                    Container(
                                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                      decoration: BoxDecoration(
                                        color: Color(0xffa1ad71),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Text(
                                        'مكتملة',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  const SizedBox(width: 10),
                                  // اسم المشروع
                                  Flexible(
                                    child: Text(
                                      title,
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.06,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF345E50),
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.location_on,
                                      size: 16,
                                      color: Color.fromARGB(255, 160, 165, 160)),
                                  const SizedBox(width: 2),
                                  Text(
                                    "saudi arabia, "+farmData['address'] ?? 'غير متوفر',
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.035,
                                      color: Colors.grey,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Project details grid
                    SizedBox(
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
                              icon: Icons.timer,
                              title: 'مدة الفرصة',
                              value: farmData['opportunityDuration'] ?? 'غير متوفر'),
                          ProjectDetailItem(
                              icon: Icons.grain,
                              title: 'نوع المحصول',
                              value: farmData['cropType'] ?? 'غير متوفر'),
                          ProjectDetailItem(
                              icon: Icons.production_quantity_limits,
                              title: 'معدل الإنتاج',
                              value: farmData['productionRate'] ?? 'غير متوفر'),
                          ProjectDetailItem(
                              icon: Icons.location_city,
                              title: 'المنطقة',
                              value: farmData['region'] ?? 'غير متوفر'),
                          ProjectDetailItem(
                              icon: Icons.bar_chart,
                              title: ' العائد المتوقع',
                              value:  '20%'),

                          ProjectDetailItem(
                            icon: Icons.money,
                            title: 'المبلغ المطلوب',
                            value: farmData['targetAmount'] != null
                                ? '${farmData['targetAmount']} ريال'
                                : 'غير متوفر',
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Funding progress section
                    Column(
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
                        Container(
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.15),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50), // Match the container's border radius
                            child: LinearProgressIndicator(
                              value: (farmData['currentInvestment'] ?? 0.0) /
                                  (farmData['targetAmount'] ?? 1.0),
                              minHeight: 10,
                              backgroundColor: Colors.grey.shade200,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  Color(0xFFA8B475)), // Your specified color
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),
                        Text(
                          '(مقدار التمويل الذي تم جمعه مقارنة بالهدف الإجمالي للمشروع)',
                          style: TextStyle(
                            fontSize: screenWidth * 0.035,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom navigation bar
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          // Add navigation logic if needed
        },
      ),
    );
  }
}

// Widget to display individual project detail items in grid
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
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12.0),
      margin: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 25, color: const Color.fromARGB(255, 131, 176, 134)),
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
