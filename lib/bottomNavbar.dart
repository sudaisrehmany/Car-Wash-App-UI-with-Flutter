// lib/widgets/bottom_nav_bar.dart

import 'package:flutter/material.dart';
import 'home_page.dart';
import 'products_page.dart'; // Update with actual imports as needed
import 'transaction_history.dart'; // Update with actual imports
import 'profileScreen.dart'; // Update with actual imports
import 'qr_scanner.dart';

class AppColors {
  static const Color primaryDark = Color(0xFF042b3d);
  static const Color primaryRed = Color(0xFFbe1e2d);
  static const Color secondaryDark = Color(0xFF1c4966);
  static const Color accentBlue = Color(0xFF2c5f85);
  static const Color lightBlue = Color(0xFF3b7ba3);
}

class AppBottomNavBar extends StatefulWidget {
  final int initialIndex;

  const AppBottomNavBar({super.key, this.initialIndex = 0});

  @override
  _AppBottomNavBarState createState() => _AppBottomNavBarState();
}

class _AppBottomNavBarState extends State<AppBottomNavBar> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primaryRed,
          unselectedItemColor: Colors.white,
          showUnselectedLabels: true,
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: "Home",
              activeIcon: Icon(Icons.home, color: AppColors.primaryRed),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.description_outlined),
              label: "Account",
              activeIcon: Icon(Icons.description, color: AppColors.primaryRed),
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Icon(Icons.qr_code_scanner, size: 30),
              ),
              label: "SCAN NOW",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.folder_outlined),
              label: "Support",
              activeIcon: Icon(Icons.folder, color: AppColors.primaryRed),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: "Profile",
              activeIcon: Icon(Icons.person, color: AppColors.primaryRed),
            ),
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });

            switch (index) {
              case 0: // Home
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(currentIndex: index),
                  ),
                );
                break;
              case 1: // Account
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        TransactionHistoryScreen(currentIndex: 1),
                  ),
                );
                break;
              case 2: // Scan
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QRScannerPage()),
                );
                break;
              case 3: // Support
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(currentIndex: 3),
                  ),
                );
                break;
              case 4: // Profile
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(currentIndex: 4),
                  ),
                );
                break;
            }
          },
        ),
      ),
    );
  }
}
