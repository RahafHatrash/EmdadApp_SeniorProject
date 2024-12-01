import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:math'; // Import for random number generation
import '../../InvestorPages/InvestmentProccess/InvestVerification.dart';
import '../FarmerHome/farmerHome.dart';

class AddProject extends StatefulWidget {
  const AddProject({super.key});

  @override
  _AddProjectFormScreenState createState() => _AddProjectFormScreenState();
}

class _AddProjectFormScreenState extends State<AddProject> {
  final TextEditingController projectNameController = TextEditingController();
  final TextEditingController regionController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cropTypeController = TextEditingController();
  final TextEditingController totalAreaController = TextEditingController();
  final TextEditingController opportunityDurationController = TextEditingController();
  final TextEditingController productionRateController = TextEditingController();
  final TextEditingController targetAmountController = TextEditingController();

  final ScrollController _scrollController = ScrollController();
  final List<int> usedImages = []; // List to track used images
  final Random random = Random(); // Random number generator

  Future<void> _addProjectToDatabase() async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final projectRef = FirebaseFirestore.instance.collection('investmentOpportunities').doc();

      // Randomly select an image number
      int imageNumber;
      do {
        imageNumber = random.nextInt(11) + 1; // Random number between 1 and 11
      } while (usedImages.contains(imageNumber) && usedImages.length < 11);

      // Add the image to the used list
      usedImages.add(imageNumber);
      String imagePath = 'assets/farm/$imageNumber.png';

      await projectRef.set({
        'id': projectRef.id,
        'projectName': projectNameController.text,
        "userId": userId,
        'region': regionController.text,
        'address': addressController.text,
        'cropType': cropTypeController.text,
        'totalArea': totalAreaController.text,
        'opportunityDuration': opportunityDurationController.text,
        'productionRate': productionRateController.text,
        'targetAmount': double.parse(targetAmountController.text),
        'currentAmount': 0.0,
        'imageUrl': imagePath,
        'status': 'تحت المعالجة',
        'profitDeposited': false,
        'timestamp': FieldValue.serverTimestamp(),
      });

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FarmerHomePage()),
      );
    } catch (e) {
      print('Error adding project: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فشل في إضافة المشروع، حاول مرة أخرى')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAF9),
        body: Stack(
          children: [
            _buildAppBar(),
            Padding(
              padding: const EdgeInsets.only(top: 200, left: 20, right: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end, // Align children to the right
                  children: [
                    Container(
                      height: 500,
                      padding: const EdgeInsets.all(24.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 5,
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end, // Right align
                          children: [
                            _buildTextField(projectNameController, 'اسم المشروع'),
                            _buildTextField(regionController, 'المنطقة'),
                            _buildTextField(addressController, 'العنوان'),
                            _buildTextField(cropTypeController, 'نوع المحصول'),
                            _buildTextField(totalAreaController, 'المساحة الكلية (بالأمتار أو الهكتار)'),
                            _buildTextField(opportunityDurationController, 'مدة الفرصة'),
                            _buildTextField(productionRateController, 'معدل الإنتاج'),
                            _buildTextField(targetAmountController, 'المبلغ المطلوب لتحقيق الهدف'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: Container(
                        width: 200,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.0),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF4B7960),
                              Color(0xFF728F66),
                              Color(0xFFA2AA6D),
                            ],
                          ),
                        ),
                        child: ElevatedButton(
                          onPressed: _addProjectToDatabase,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                          ),
                          child: const Text(
                            'إضافة المزرعة',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
      child: Container(
        height: 320,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF345E50), Color(0xFF49785E), Color(0xFFA8B475)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 50,
              right: 15,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 150.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      'بيانات الفرصة الزراعية',
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'يرجى ملء جميع التفاصيل المتعلقة بمزرعتك.',
                      style: TextStyle(fontSize: 15, color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText) {
    final FocusNode focusNode = FocusNode();

    return StatefulBuilder(
      builder: (context, setState) {
        focusNode.addListener(() {
          setState(() {});
        });

        return Column(
          crossAxisAlignment: CrossAxisAlignment.end, // Align text fields to the right
          children: [
            TextField(
              controller: controller,
              focusNode: focusNode,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontSize: focusNode.hasFocus ? 14 : 16,
              ),
              decoration: InputDecoration(
                labelText: labelText,
                labelStyle: TextStyle(
                  color: focusNode.hasFocus ? Colors.grey : const Color(0xFFA09E9E),
                ),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
              ),
            ),
            Container(
              height: 1,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF4B7960),
                    Color(0xFF728F66),
                    Color(0xFFA2AA6D),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        );
      },
    );
  }
}