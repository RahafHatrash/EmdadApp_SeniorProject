import 'package:flutter/material.dart';

class farmerTerms extends StatelessWidget {
  const farmerTerms({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAF9),
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
                      icon: const Icon(Icons.arrow_forward, color: Colors.white, size: 30),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  // Title "الشروط والأحكام" centered in the header
                  const Positioned(
                    top: 60,
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
            padding: const EdgeInsets.only(top: 130), // Positioning content below the header
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
                        // Introductory text for the farmer
                        const Text(
                          'عزيزي المزارع، منصة إمداد هي منصة إلكترونية تهدف إلى جمع أموال مجموعة من المستثمرين لتمويل المشاريع الزراعية وتقديم الدعم المالي للمزارعين، وتلتزم إمداد بتوفير بيئة آمنة للمزارعين والمستثمرين على حد سواء. لاستكمال عملية التسجيل، يتطلب موافقتك على الشروط والأحكام، وهي كالتالي:',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.right,
                        ),
                        const SizedBox(height: 20),

// Section for farmer's rights
                        _buildContentSection(
                          title: 'أولاً: حقوقك',
                          content: [
                            '1. يحق لك الحصول على التمويل اللازم لتنفيذ مشروعك الزراعي عبر المنصة وفقاً للشروط المتفق عليها.',
                            '2. يحق لك متابعة تقدم المشروع والمبالغ التي تم جمعها والمرحلة الحالية من التمويل من خلال لوحة التحكم الخاصة بك.',
                            '3. منصة إمداد تلتزم بحماية بياناتك الشخصية وفق سياسة الخصوصية المعلنة على المنصة.',
                            '4. ستتمكن من التواصل مع فريق دعم المنصة في حال وجود استفسارات أو مشكلات تتعلق بعملية التمويل أو المشروع.',
                            '5. سيتم إشعارك بأي تغييرات جوهرية أو قرارات تؤثر على شروط التمويل، كما ستتاح لك إمكانية الاطلاع على التحديثات عبر لوحة التحكم.',
                          ],
                        ),
                        const SizedBox(height: 20),

// Section for farmer's obligations
                        _buildContentSection(
                          title: 'ثانياً: إلتزاماتك',
                          content: [
                            '1. يجب عليك تقديم جميع المعلومات والوثائق الصحيحة والدقيقة المتعلقة بمشروعك الزراعي للحصول على التمويل.',
                            '2. الالتزام بإدارة المشروع بالشكل الذي يحقق الأهداف المتفق عليها مع المستثمرين، ويضمن تحقيق الإنتاج والجودة.',
                            '3. منصة إمداد تتقاضى رسومًا بسيطة مقابل خدماتها، ويتم توضيح جميع الرسوم قبل إتمام عملية التمويل.',
                            '4. يجب عليك متابعة المشروع وتقديم تقارير دورية عن سير العمل والمشكلات التي قد تواجهها.',
                            '5. يتعين عليك الالتزام بقوانين ولوائح الزراعة المعتمدة في المملكة لضمان سلامة المشروع واستدامته.',
                            '6. يجب أن تدرك أن المنصة لها الحق في تعديل هذه الشروط والأحكام وتحديثها دوريًا، لذا يُنصح بمراجعتها بانتظام.',
                            '7. في حالة وجود أي تحديث أو تغيير يؤثر على التمويل أو إدارة المشروع، يجب عليك إخطار المنصة فوراً عبر القنوات المتاحة.',
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
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl, // Align text to the right for numbers
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}
