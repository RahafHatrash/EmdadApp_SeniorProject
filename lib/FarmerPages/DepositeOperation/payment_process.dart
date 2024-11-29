import 'package:flutter/material.dart';
import '../FarmerHome/farmerHome.dart';

class PaymentStatusPage extends StatefulWidget {
  @override
  _PaymentStatusPageState createState() => _PaymentStatusPageState();
}

class _PaymentStatusPageState extends State<PaymentStatusPage> {
  bool isLoading = true; // Indicates loading state
  bool? isSuccess; // Determines if payment was successful

  @override
  void initState() {
    super.initState();
    _simulatePaymentProcess(); // Simulate payment process on init
  }

  Future<void> _simulatePaymentProcess() async {
    // Simulate a delay to mimic payment processing
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      isLoading = false;
      isSuccess = true; // Set to true to simulate a successful payment
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Screen background color
      body: Stack(
        children: [
          // Top gradient background for header
          Container(
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
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
          ),
          // Centered content box displaying payment status
          Center(
            child: _buildConstantBox(context),
          ),
        ],
      ),
    );
  }

  // Content box with white background and rounded corners
  Widget _buildConstantBox(BuildContext context) {
    return Container(
      height: 500,
      width: 350,
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
      child: Center(
        child: isLoading
            ? CircularProgressIndicator() // Loading indicator while processing
            : _buildStatusContent(), // Display status after processing
      ),
    );
  }

  // Displays the content based on payment status
  Widget _buildStatusContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStatusIcon(), // Icon to indicate success or failure
        const SizedBox(height: 30),
        _buildStatusMessage(), // Message indicating success or failure
        const SizedBox(height: 20),
        _buildAdditionalText(), // Additional information text
        const SizedBox(height: 50),
        _buildHomeButton(), // Button to go to home page
        if (isSuccess == false) ...[
          const SizedBox(height: 10),
          _buildRetryButton(), // Retry button if payment failed
        ],
      ],
    );
  }

  // Icon indicating payment status (success or failure)
  Widget _buildStatusIcon() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: isSuccess == true
              ? [Color(0xFF4B7960), Color(0xFF728F66), Color(0xFFA2AA6D)]
              : [Color(0xFFD32F2F), Color(0xFFE57373), Color(0xFFFFCDD2)],
        ),
      ),
      padding: const EdgeInsets.all(20.0),
      child: Icon(
        isSuccess == true ? Icons.done : Icons.error,
        color: Colors.white,
        size: 120,
      ),
    );
  }

  // Message displayed for success or failure of payment
  Widget _buildStatusMessage() {
    return Text(
      isSuccess == true ? 'عملية الدفع مكتملة' : 'عملية الدفع فشلت',
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: isSuccess == true ? Color(0xFF527D62) : Color(0xFFD32F2F),
        fontFamily: 'Markazi Text',
      ),
      textAlign: TextAlign.center,
    );
  }

  // Additional text to provide more information based on payment outcome
  Widget _buildAdditionalText() {
    return Text(
      isSuccess == true
          ? 'تم إيداع العوائد بنجاح، وسيتم توزيع العوائد على المستثمرين قريباً. نشكركم على ثقتكم بنا.'
          : 'حدث خطأ أثناء عملية الدفع. يرجى المحاولة مرة أخرى أو الاتصال بالدعم.',
      style: const TextStyle(
        fontSize: 20,
        color: Color(0xFF527D62),
        fontFamily: 'Markazi Text',
      ),
      textAlign: TextAlign.center,
    );
  }

  // Button to navigate back to the home page
  Widget _buildHomeButton() {
    return Container(
      width: 190,
      height: 35,
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
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => FarmerHomePage(),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
        ),
        child: const Text(
          'الصفحة الرئيسية',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // Retry button for failed payment attempt
  Widget _buildRetryButton() {
    return Container(
      width: 190,
      height: 35,
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
        onPressed: () {
          setState(() {
            isLoading = true;
            _simulatePaymentProcess(); // Retry the payment process
          });
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
        ),
        child: const Text(
          'حاول مرة اخرى',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
