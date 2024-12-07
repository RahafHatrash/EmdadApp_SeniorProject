import 'package:flutter/material.dart';
import '../../custom_bottom_nav_bar.dart';
import '../InvestmentProccess/InvestOperation.dart';

class Opportunitydetails extends StatelessWidget {
  final String imageUrl;
  final String title;
  final Map<String, dynamic> farmData;
  final String FarmId;

  const Opportunitydetails({super.key,
    required this.imageUrl,
    required this.title,
    required this.farmData,
    required this.FarmId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9F8),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopImageWithOverlay(context),
            _buildMainDetailsContainer(context),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // Method for building the top image with overlay
  Widget _buildTopImageWithOverlay(BuildContext context) {
    return Stack(
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
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.3,
          color: Colors.black.withOpacity(0.1),
        ),
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
    );
  }

  // Method for building the main details container
  Widget _buildMainDetailsContainer(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
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
            _buildTitleAndButton(context),
            const SizedBox(height: 10),
            _buildProjectDetailsGrid(context),
            const SizedBox(height: 10),
            _buildFundingProgressSection(context),
          ],
        ),
      ),
    );
  }

  // Method for building title and investment button
  Widget _buildTitleAndButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (farmData['status'] != 'مكتملة') _buildInvestNowButton(context),
        Expanded(child: _buildProjectTitleAndLocation(context)),
      ],
    );
  }

  // Method for building the "Invest Now" button
  Widget _buildInvestNowButton(BuildContext context) {
    return Container(
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
                  FarmName: farmData['FarmName'],
                  FarmId: FarmId,
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
            style: TextStyle(color: Colors.white,fontSize: 15),
          ),
        ),
      ),
    );
  }

  // Method for building project title and location
  Widget _buildProjectTitleAndLocation(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (farmData['status'] == 'مكتملة' && farmData['profitDeposited'] == true)
              _buildStatusBadge(Colors.green, 'مكتملة'),
            if (farmData['status'] == 'مكتملة' && farmData['profitDeposited'] == false)
              _buildStatusBadge(const Color(0xffa1ad71), 'مكتملة'),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: screenWidth * 0.08,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF5B8263),
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
                size: 16, color: Color.fromARGB(255, 160, 165, 160)),
            const SizedBox(width: 2),
            Text(
              "saudi arabia, ${farmData['address'] ?? 'غير متوفر'}",
              style: TextStyle(
                fontSize: screenWidth * 0.033,
                color: Colors.grey,
              ),
              textAlign: TextAlign.right,
            ),
          ],
        ),
      ],
    );
  }

  // Method for building status badge
  Widget _buildStatusBadge(Color color, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Method for building project details grid
  Widget _buildProjectDetailsGrid(BuildContext context) {
    double targetAmount = farmData['targetAmount'] ?? 0.0;
    double currentInvestment = farmData['currentInvestment'] ?? 0.0;
    double remainingAmount = targetAmount - currentInvestment;
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.0,
      mainAxisSpacing: 5,
      crossAxisSpacing: 5,
      children: [
        _buildProjectDetailItem(Icons.timer, 'مدة الفرصة',
            farmData['opportunityDuration'] ?? 'غير متوفر'),
        _buildProjectDetailItem(Icons.grain, 'نوع المحصول',
            farmData['cropType'] ?? 'غير متوفر'),
        _buildProjectDetailItem(Icons.production_quantity_limits, 'معدل الإنتاج',
            farmData['productionRate'] ?? 'غير متوفر'),
        _buildProjectDetailItem(Icons.location_city, 'المنطقة',
            farmData['region'] ?? 'غير متوفر'),
        _buildProjectDetailItem(Icons.bar_chart, 'العائد المتوقع', '20%'),
        _buildProjectDetailItem(Icons.money, 'المبلغ المتبقي',
            '${remainingAmount.toStringAsFixed(2)} ريال'),
      ],

    );
  }

  // Method for building an individual project detail item
  Widget _buildProjectDetailItem(IconData icon, String title, String value) {
    return FarmProjectDetailItem(
      icon: icon,
      title: title,
      value: value,
    );
  }

  // Method for building funding progress section
  Widget _buildFundingProgressSection(BuildContext context) {
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    return // Funding progress section
      Column(
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
              borderRadius: BorderRadius.circular(50),
              child: LinearProgressIndicator(
                value: (farmData['currentInvestment'] ?? 0.0) /
                    (farmData['targetAmount'] ?? 1.0),
                minHeight: 10,
                backgroundColor: Colors.grey.shade200,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFFA8B475),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '(مقدار التمويل الذي تم جمعه مقارنة بالهدف الإجمالي للمشروع)',
            style: TextStyle(
              fontSize: screenWidth * 0.03,
              color: Colors.grey,
            ),
          ),
        ],
      );

  }
}
    Widget _buildBottomNavigationBar() {
    return CustomBottomNavBar(
      currentIndex: -1, // المؤشر الحالي للعنصر المختار
      onTap: (index) {
        // الإجراء عند اختيار عنصر
        print('Selected index: $index');
      },
    );
  }

// Widget to display individual project detail items in grid
class FarmProjectDetailItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const FarmProjectDetailItem({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12.0),
      margin: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        color: Colors.green.shade50, // اللون الأخضر الفاتح
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 25, color: const Color.fromARGB(255, 131, 176, 134)), // لون الأيقونة
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              color: Color.fromARGB(255, 57, 98, 32), // لون النص الأول
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 54, 88, 15), // لون النص الثاني
            ),
          ),
        ],
      ),
    );
  }
}