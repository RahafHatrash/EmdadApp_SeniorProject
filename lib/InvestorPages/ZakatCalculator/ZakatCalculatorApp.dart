import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../custom_bottom_nav_bar.dart';

class ZakatCalculatorPage extends StatefulWidget {
  const ZakatCalculatorPage({super.key});

  @override
  _ZakatCalculatorPageState createState() => _ZakatCalculatorPageState();
}

class _ZakatCalculatorPageState extends State<ZakatCalculatorPage> {
  final TextEditingController _amountController = TextEditingController();
  double _zakatAmount = 0.0;
  bool _manualInput = true; // Manual input or Portfolio balance mode
  double nisab = 1749.3; // Nisab in currency (SAR)
  double investmentPortfolioBalance = 0.0; // Portfolio balance
  DateTime? PortfolioDepositDate; // Deposit date for Portfolio balance
  bool _showError = false; // Error message for manual input
  bool _PortfolioError = false; // Error message for Portfolio calculation
  int _currentIndex = 1;

  void _calculateZakat() async {
    if (_manualInput) {
      _calculateManualZakat();
    } else {
      await _calculatePortfolioZakat();
    }
  }

  // Manual Zakat Calculation
  void _calculateManualZakat() {
    final amount = double.tryParse(_amountController.text) ?? 0.0;

    setState(() {
      if (amount < nisab) {
        _showError = true;
        _zakatAmount = 0.0;
      } else {
        _showError = false;
        _zakatAmount = amount * 0.025;
      }
    });
  }

  Future<void> _calculatePortfolioZakat() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        final PortfolioDoc = await FirebaseFirestore.instance
            .collection('InvestmentPortfolio')
            .doc(userId)
            .get();

        if (PortfolioDoc.exists) {
          investmentPortfolioBalance = PortfolioDoc.data()?['currentBalance'] ?? 0.0;
        }
      }
      setState(() {
        if (investmentPortfolioBalance < nisab) {
          _PortfolioError = true;
          _zakatAmount = 0.0;
        } else {
          _PortfolioError = false;
          _zakatAmount = investmentPortfolioBalance * 0.025;
        }
      });
    } catch (e) {
      print("Error fetching Portfolio balance: $e");
      setState(() {
        _PortfolioError = true;
        _zakatAmount = 0.0;
      });
    }
  }

  void _onNavBarTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
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
            colors: [
              Color(0xFF345E50),
              Color(0xFF49785E),
              Color(0xFFA8B475),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 130.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'حاسبة الزكاة',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'احسب زكاتك على أموالك المستثمرة بسهولة \n وفقاً للضوابط الشرعية',
                      style: TextStyle(fontSize: 14, color: Colors.white70),
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

  Widget _buildStyledTextField(String labelText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _amountController,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            hintText: labelText,
            hintStyle: const TextStyle(color: Color(0xFFA09E9E)),
            border: InputBorder.none,
          ),
          style: const TextStyle(color: Color(0xFFA09E9E)),
        ),
        Container(
          height: 1,
          width: double.infinity,
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
          ),
        ),
        if (_showError)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              'المبلغ لم يتجاوز حد النصاب',
              style: TextStyle(
                color: Colors.red,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
            ),
          ),
      ],
    );
  }

  Widget _buildPortfolioSelector() {
    return Container(
      padding: const EdgeInsets.all(6),
      margin: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF345E50), Color(0xFFA8B475)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _manualInput = false;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 15),
              decoration: BoxDecoration(
                color: !_manualInput
                    ? const Color.fromARGB(92, 255, 255, 255)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'رصيد المحفظة',
                style: TextStyle(
                  fontSize: 15,
                  color: !_manualInput ? Colors.white : Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _manualInput = true;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
              decoration: BoxDecoration(
                color: _manualInput
                    ? const Color.fromARGB(92, 255, 255, 255)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'إدخال المبلغ يدوياً',
                style: TextStyle(
                  fontSize: 15,
                  color: _manualInput ? Colors.white : Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAF9),
      body: Stack(
        children: [
          _buildAppBar(),
          Padding(
            padding: const EdgeInsets.only(top: 220, left: 16, right: 16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
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
                      children: [
                        _buildPortfolioSelector(),
                        if (_manualInput)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  'أدخل المبلغ الذي ترغب بحساب الزكاة عليه',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color:
                                        Color.fromARGB(216, 53, 94, 79),
                                    fontWeight: FontWeight.w800,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                              const SizedBox(height: 10),
                              _buildStyledTextField('القيمة بالريال السعودي'),
                            ],
                          ),
                        if (!_manualInput)
                          const Text(
                            'سيتم حساب الزكاة بناءً على رصيد المحفظة الاستثماري',
                            style: TextStyle(
                              fontSize: 18,
                              color: Color.fromARGB(216, 53, 94, 79),
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        const SizedBox(height: 30),
                        GestureDetector(
                          onTap: _calculateZakat,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            padding: const EdgeInsets.symmetric(vertical: 1),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF345E50),
                                  Color(0xFFA8B475),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Center(
                              child: Text(
                                'حساب الزكاة',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          'مبلغ الزكاة الواجب دفعه: ${_zakatAmount.toStringAsFixed(2)} ريال سعودي',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'الزكاة هي 2.5% من المبلغ الذي يبلغ النصاب وحال عليه الحول، ويُعتبر النصاب ما يعادل 1749.3 ريال سعودي.',
                          style: TextStyle(fontSize: 15),
                          textAlign: TextAlign.center,
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
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavBarTapped,
      ),
    );
  }
}
