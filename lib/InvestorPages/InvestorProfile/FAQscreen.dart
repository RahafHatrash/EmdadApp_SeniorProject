import 'package:flutter/material.dart';

// Main class for the FAQ screen
class FAQscreen extends StatelessWidget {
  // List of frequently asked questions for investors
  final List<String> questions = const [
    "كيف يمكنني الاستثمار في المشاريع الزراعية؟",
    "ما هي عوائد الاستثمار المتوقعة؟",
    "كيف يمكنني متابعة تقدم المشاريع التي استثمرت فيها؟",
    "ما هي المخاطر المرتبطة بالاستثمار في المشاريع الزراعية؟",
    "كيف يمكنني سحب أرباحي؟",
    "كيف يمكنني التواصل مع دعم العملاء؟",
  ];

  // Corresponding answers for each question
  final List<String> answers = const [
    "يمكنك الاستثمار في المشاريع الزراعية من خلال اختيار المشروع المناسب في التطبيق وتحديد المبلغ الذي ترغب في استثماره.",
    "عوائد الاستثمار تختلف حسب المشروع، ولكن يمكنك توقع عوائد تتراوح بين 10% إلى 25% سنويًا حسب نوع المشروع وظروف السوق.",
    "لمتابعة تقدم المشاريع، يمكنك زيارة قسم 'استثماراتي' في التطبيق، حيث ستجد تحديثات دورية حول حالة المشاريع واستثماراتك.",
    "المخاطر تشمل تقلبات السوق، الظروف المناخية غير المتوقعة، وإدارة المشروع. من المهم أن تكون على دراية بهذه المخاطر قبل الاستثمار.",
    "يمكنك سحب أرباحك من خلال قسم 'المحفظة' في التطبيق، حيث يمكنك اختيار المبلغ الذي ترغب في سحبه وإدخال تفاصيل حسابك المصرفي.",
    "يمكنك التواصل مع دعم العملاء من خلال قسم دعم العملاء في التطبيق. يمكنك إرسال رسالة أو استفسار، وسنقوم بالرد عليك في أقرب وقت ممكن",
  ];

  const FAQscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAF9), // Light background color
      body: Stack(
        children: [
          // Large gradient header with rounded bottom corners
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 150,
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
                  // Back button to navigate back to the previous screen
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
                  // Centered title "الأسئلة الشائعة"
                  const Positioned(
                    top: 70,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text(
                        "الأسئلة الشائعة",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Markazi Text',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // FAQ content with questions and expandable answers below the header
          Positioned.fill(
            top: 110,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 3,
                    child: ExpansionTile(
                      // Display each question as the title
                      title: Text(
                        questions[index],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4B7960),
                          fontFamily: 'Markazi Text',
                        ),
                      ),
                      // Display the corresponding answer when expanded
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            answers[index],
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              fontFamily: 'Markazi Text',
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
