import 'package:flutter/material.dart';
import 'products_page.dart';

void main() => runApp(Status());

class Status extends StatelessWidget {
  const Status({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top Banner Image
              Image.asset(
                'images/banner1.png',
                width: double.infinity,
                fit: BoxFit.cover,
              ),

              SizedBox(height: 20),

              // 3D Modern VR Car Cleaning Image
              SizedBox(
                width: 300,
                height: 320,
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(20),
                // ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'images/banner2.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              SizedBox(height: 30),

              // Text Content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Order Processing',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Track your car wash progress and get real-time updates on your vehicle cleaning service.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 90,
      // padding: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
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
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.white,
          showUnselectedLabels: true,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: "Home",
              activeIcon: Icon(Icons.home, color: Colors.blue),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.description_outlined),
              label: "Account",
              activeIcon: Icon(Icons.description, color: Colors.blue),
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
              activeIcon: Icon(Icons.folder, color: Colors.blue),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: "Profile",
              activeIcon: Icon(Icons.person, color: Colors.blue),
            ),
          ],
          currentIndex: 0,
          onTap: (index) {
            switch (index) {
              case 0: // Home button
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ProductsPage()),
                );
                break;
              // Add other navigation cases if needed
            }
          },
        ),
      ),
    );
  }
}
