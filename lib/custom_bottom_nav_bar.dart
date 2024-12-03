import 'package:flutter/material.dart';
import 'InvestorPages/InvestorHome/Myinvestments.dart';
import 'InvestorPages/InvestorHome/InvestorHome.dart';
import 'InvestorPages/InvestorProfile/InvestorProfile.dart';
import 'InvestorPages/InvestorWallet/WalletPage.dart';
import 'InvestorPages/ZakatCalculator/ZakatCalculatorApp.dart';

class CustomBottomNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  _CustomBottomNavBarState createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  void _onItemTapped(int index) {
    // Navigate to the corresponding page based on the selected index
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const InvestorProfile()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ZakatCalculatorPage()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MyInvestments()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WalletPage()),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const InvestorHome()),
        );
        break;
      default:
        widget.onTap(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor:
          widget.currentIndex == -1 ? Colors.grey : Colors.green.shade700,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      currentIndex: widget.currentIndex == -1 ? 0 : widget.currentIndex,
      onTap: (index) {
        widget.onTap(index);
        _onItemTapped(index);
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'حسابي',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calculate),
          label: 'حاسبة الزكاة',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.trending_up),
          label: 'استثماراتي',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_balance_wallet),
          label: 'محفظتي',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'الرئيسية',
        ),
      ],
    );
  }
}
