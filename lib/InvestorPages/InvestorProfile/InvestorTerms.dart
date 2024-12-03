import 'package:flutter/material.dart';

// Main class for the Terms Screen
class investorTerms extends StatelessWidget {
  const investorTerms({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAF9), // Light background color
      body: Stack(
        children: [
          // Gradient background header with rounded corners
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 320,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF345E50),
                    Color(0xFF49785E),
                    Color(0xFFA8B475),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Stack(
                children: [
                  // Back button positioned in the header
                  Positioned(
                    top: 50,
                    right: 16,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_forward,
                          color: Colors.white, size: 30),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  // Title "الشروط والأحكام" centered in the header
                  const Positioned(
                    top: 80,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text(
                        'الشروط والأحكام',
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Markazi Text',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Main content section with terms and conditions
          Padding(
            padding: const EdgeInsets.only(
                top: 150), // Positioning content below the header
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // White container with introductory text and terms
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(33),
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
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Introduction to terms and conditions
                        const Text(
                          'عزيزي المستثمر، إمداد هي منصة إلكترونية تهدف إلى جمع أموال مجموعة من المستثمرين "عملاء المنصة" لغرض تمويل صناديق الاستثمار الزراعية المرخصة... لاستكمال عملية التسجيل يتطلب موافقتك على الشروط والأحكام جميعاً، وهي كالتالي:',
                          style: TextStyle(fontSize: 15),
                          textAlign: TextAlign.right,
                        ),
                        const SizedBox(height: 20),

                        // Section for user rights
                        _buildContentSection(
                          title: 'أولاً: حقوقك',
                          content: [
                            '1. الاطلاع على كافة المعلومات عن الفرص الاستثمارية المنشورة في المنصة.',
                            '2. من حقك الحصول على تقييم الأداء للفرصة الاستثمارية بشكل دوري.',
                            '3. منصة إمداد تلتزم بكافة المتطلبات التي تتعلق بحماية البيانات الشخصية.',
                            '4. يمكنك معرفة جميع الاستثمارات، وحالتها ونسبة التقدم.',
                            '5. سيتم إشعارك بأي تغيير جوهري في مجلس الإدارة أو شروط وأحكام الصندوق.',
                            '6. في حال عدم اكتمال الحد الأدنى للطرح في المدة المحددة فسيتم إرجاع كامل مبلغ الاستثمار.'
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Section for user obligations
                        _buildContentSection(
                          title: 'ثانياً: إلتزاماتك',
                          content: [
                            '1. يجب عليك قراءة شروط وأحكام الفرصة المطروحة قبل اتخاذ قرارك الاستثماري.',
                            '2. تتقاضى منصة إمداد رسوم اشتراك لا تتجاوز 1٪ من قيمة استثمار الفرد.',
                            '3. قد تتقاضى منصة إمداد بعض العمولات الإضافية من مدراء الصناديق.',
                            '4. الشعارات و العلامات التجارية الموجودة في المنصة مسجلة و محمية بموجب القانون.',
                            '5. يتعين عليك معرفة أنه بمجرد دفع مبلغ الاستثمار من خلال المنصة.',
                            '6. منصة إمداد لها الحق في تعديل هذه الشروط والأحكام وتحديثها بشكل دوري.',
                            '7. أنت مسؤول عن جميع المعلومات والأنشطة التي تتم عبر المنصة.',
                            '8. يتعين عليك معرفة أنه بتسجيلك في المنصة فإنك تعطي المنصة صلاحية فتح حساب افتراضي.',
                            '9. يتعين عليك الاطلاع والموافقة على كل من سياسة الخصوصية و سياسة الإفصاح.'
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build content sections with a title and list of items
  Widget _buildContentSection({
    required String title,
    required List<String> content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Section title with gradient background
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF4B7960),
                Color(0xFF728F66),
                Color(0xFFA2AA6D),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Markazi Text',
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        // List of terms within the section
        for (var item in content) ...[
          Text(
            item,
            style: const TextStyle(fontSize: 15),
            textAlign: TextAlign.right,
            textDirection:
                TextDirection.rtl, // Align text to the right for numbers
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}
