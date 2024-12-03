import 'package:flutter/material.dart';
import '../../custom_bottom_nav_bar.dart';

class investedFarmDetails extends StatelessWidget {
  final String imageUrl;
  final String title;
  final Map<String, dynamic> farmData;
  final String projectId;

  const investedFarmDetails({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.farmData,
    required this.projectId,
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
            const SizedBox(height: 30),
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
        Expanded(child: _buildProjectTitleAndLocation(context)),
      ],
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
            if (farmData['status'] == 'مكتملة' &&
                farmData['profitDeposited'] == true)
              _buildStatusBadge(Colors.green, 'مكتملة'),
            if (farmData['status'] == 'مكتملة' &&
                farmData['profitDeposited'] == false)
              _buildStatusBadge(const Color(0xffa1ad71), 'تحت المعالجة'),
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
              "saudi arabia, ${farmData['region'] ?? 'غير متوفر'}",
              style: TextStyle(
                fontSize: screenWidth * 0.03,
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

  Widget _buildProjectDetailsGrid(BuildContext context) {
    double targetAmount = farmData['targetAmount'] ?? 0.0;
    double currentInvestment = farmData['currentInvestment'] ?? 0.0;
    double remainingAmount = targetAmount - currentInvestment;

    // إزالة النصوص غير الرقمية وتحويل القيم
    double investmentAmount = double.tryParse(farmData['investmentAmount']
                ?.toString()
                .replaceAll(RegExp(r'[^0-9.]'), '') ??
            '0') ??
        0.0;
    double actualReturns = double.tryParse(farmData['actualReturns']
                ?.toString()
                .replaceAll(RegExp(r'[^0-9.]'), '') ??
            '0') ??
        0.0;

    // الربح أو الخسارة الافتراضية
    String profitOrLoss = 'غير متوفر';

    if (investmentAmount > 0 && actualReturns > 0.0) {
      if (actualReturns > investmentAmount) {
        // حساب نسبة الربح
        double profitPercentage =
            ((actualReturns - investmentAmount) / investmentAmount) * 100;
        profitOrLoss = '+ ${profitPercentage.toStringAsFixed(2)}%';
      } else if (actualReturns < investmentAmount) {
        // حساب نسبة الخسارة
        double lossPercentage =
            ((investmentAmount - actualReturns) / investmentAmount) * 100;
        profitOrLoss = '- ${lossPercentage.toStringAsFixed(2)}%';
      } else {
        profitOrLoss = 'لا ربح ولا خسارة';
      }
    }

    // عرض النص "بإنتظار الايداع" إذا كانت العوائد المحققة تساوي 0
    String actualReturnsText = actualReturns == 0.0
        ? 'بإنتظار الايداع'
        : '${actualReturns.toStringAsFixed(2)} رس';

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
        _buildProjectDetailItem(Icons.analytics, 'الربح والخسارة',
            actualReturns == 0.0 ? 'غير متوفر' : profitOrLoss),
        _buildProjectDetailItem(Icons.bar_chart, 'العائد المتوقع',
            farmData['expectedReturns'] ?? 'غير متوفر'),
        _buildProjectDetailItem(Icons.monetization_on, 'مبلغ الاستثمار',
            farmData['investmentAmount'] ?? 'بانتظار الايداع'),
        _buildProjectDetailItem(
            Icons.trending_up, 'العائد المحقق', actualReturnsText),
        _buildProjectDetailItem(Icons.money, 'المبلغ المتبقي',
            '${remainingAmount.toStringAsFixed(2)} رس'),
      ],
    );
  }

  // Method for building an individual project detail item
  Widget _buildProjectDetailItem(IconData icon, String title, String value) {
    return ProjectDetailItem(
      icon: icon,
      title: title,
      value: value,
    );
  }

  // Method for building funding progress section
  Widget _buildFundingProgressSection(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
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
class ProjectDetailItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const ProjectDetailItem({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 12.0),
      margin: const EdgeInsets.all(0.7),
      decoration: BoxDecoration(
        color: Colors.green.shade50, // اللون الأخضر الفاتح
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon,
              size: 25,
              color: const Color.fromARGB(255, 131, 176, 134)), // لون الأيقونة
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              color: Color.fromARGB(255, 57, 98, 32), // لون النص الأول
            ),
          ),
          const SizedBox(height: 12),
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
