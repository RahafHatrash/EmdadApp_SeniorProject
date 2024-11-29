import 'package:flutter/material.dart';

class FAQscreen extends StatelessWidget {
  // List of frequently asked questions
  final List<String> questions = const [
    "كيف يمكنني إنشاء حساب جديد؟",
    "ما هي سياسة الخصوصية الخاصة بالتطبيق؟",
    "كيف يمكنني تحديث معلومات الحساب؟",
    "كيف أنشر فرصة زراعية جديدة على التطبيق؟",
    "ما هي أنواع المشاريع الزراعية التي يمكنني عرضها؟",
    "كيف يمكنني التواصل مع دعم العملاء؟",
  ];

  // Corresponding answers for each question
  final List<String> answers = const [
    "لإنشاء حساب جديد، انقر فوق 'إنشاء حساب' واتبع التعليمات.",
    "سياسة الخصوصية الخاصة بالتطبيق تضمن حماية معلوماتك الشخصية.",
    "لتحديث معلومات الحساب، انتقل إلى قسم 'حسابك' وقم بتحديث التفاصيل.",
    "يمكنك نشر فرصة جديدة من خلال الدخول إلى قسم إضافة فرصة زراعية، حيث يمكنك ملء المعلومات الأساسية عن المشروع مثل نوع المحصول، الموقع، مدة المشروع، والعائد المتوقع.",
    "يمكنك عرض أي مشروع زراعي يتضمن زراعة المحاصيل، تربية الحيوانات، أو أي نشاط زراعي آخر. تأكد من تقديم تفاصيل دقيقة حول المشروع لجذب المستثمرين.",
    "يمكنك التواصل مع دعم العملاء من خلال قسم دعم العملاء في التطبيق. يمكنك إرسال رسالة أو استفسار، وسنقوم بالرد عليك في أقرب وقت ممكن.",
  ];

  const FAQscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAF9),
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
                      icon: const Icon(Icons.arrow_forward, color: Colors.white, size: 30),
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
