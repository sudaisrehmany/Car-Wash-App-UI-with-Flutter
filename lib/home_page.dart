import 'package:carwash_app/ManageVehicle.dart';
import 'package:carwash_app/profileScreen.dart';
import 'package:flutter/material.dart';
import 'bottomNavbar.dart';
import 'products_page.dart';
import 'transaction_history.dart';

void main() => runApp(HomePage());

class AppColors {
  static const Color primaryDark = Color(0xFF042b3d);
  static const Color primaryRed = Color(0xFFbe1e2d);
  static const Color secondaryDark = Color(0xFF1c4966);
  static const Color accentBlue = Color(0xFF2c5f85);
  static const Color lightBlue = Color(0xFF3b7ba3);
}

class NotificationModel {
  final String title;
  final String message;
  final DateTime date;
  final bool isRead;

  NotificationModel({
    required this.title,
    required this.message,
    required this.date,
    this.isRead = false,
  });
}

class QuickLinkModel {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  QuickLinkModel({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
}

class HomePage extends StatefulWidget {
  final int currentIndex;

  const HomePage({super.key, this.currentIndex = 0});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<NotificationModel> notifications = [
    NotificationModel(
      title: "Service Reminder",
      message: "Your car wash is scheduled for tomorrow",
      date: DateTime.now().subtract(Duration(days: 1)),
      isRead: false,
    ),
    NotificationModel(
      title: "Promotion",
      message: "50% off on barber services this weekend",
      date: DateTime.now().subtract(Duration(days: 2)),
      isRead: true,
    ),
  ];

  final List<Map<String, dynamic>> categories = [
    {"icon": Icons.local_car_wash, "title": "Car Wash"},
    {"icon": Icons.cut, "title": "Barber"},
    {"icon": Icons.local_laundry_service, "title": "Laundry"},
    {"icon": Icons.cleaning_services, "title": "Cleaning"},
  ];

  List<QuickLinkModel> quickLinks = [];
  List<Map<String, dynamic>> _allProducts = [];

  @override
  void initState() {
    super.initState();
    // Initialize quick links with example actions
    quickLinks = [
      QuickLinkModel(
        icon: Icons.receipt_long,
        title: "Transaction",
        subtitle: "Manage transactions",
        onTap: () => _showQuickLinkDialog("Transaction Management"),
      ),
      QuickLinkModel(
        icon: Icons.directions_car_outlined,
        title: "Vehicle",
        subtitle: "Manage vehicles",
        onTap: () => _showQuickLinkDialog("Vehicle Management"),
      ),
      QuickLinkModel(
        icon: Icons.cut_outlined,
        title: "Barber",
        subtitle: "Book services",
        onTap: () => _showQuickLinkDialog("Barber Services"),
      ),
    ];
    _allProducts = [
      {
        "image": "images/product1.jpg",
        "name": "Car Wash",
        "description": "Get your car washed and cleaned",
        "price": "RM 20.00",
        "discount": "10",
      },
      {
        "image": "images/product2.jpg",
        "name": "Barber Service",
        "description": "Get a haircut and shave",
        "price": "RM 30.00",
        "discount": "20",
      },
      {
        "image": "images/product3.jpg",
        "name": "Laundry Service",
        "description": "Get your clothes washed and cleaned",
        "price": "RM 15.00",
        "discount": "5",
      },
      {
        "image": "images/product4.png",
        "name": "Cleaning Service",
        "description": "Get your house cleaned",
        "price": "RM 50.00",
        "discount": "10",
      },
      {
        "image": "images/product1.jpg",
        "name": "Car Wash and Barber",
        "description": "Get your car washed and a haircut",
        "price": "RM 40.00",
        "discount": "15",
      },
      {
        "image": "images/product2.jpg",
        "name": "Laundry and Cleaning",
        "description": "Get your clothes washed and your house cleaned",
        "price": "RM 60.00",
        "discount": "20",
      },
    ];
  }

  void _showQuickLinkDialog(String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text("Functionality coming soon!"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close"),
          ),
        ],
      ),
    );
  }

  void _showNotificationPopup(BuildContext context) {
    final RenderBox notificationIcon = context.findRenderObject() as RenderBox;
    final position = notificationIcon.localToGlobal(Offset.zero);

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Stack(
          children: [
            Positioned(
              top: position.dy + notificationIcon.size.height,
              right: MediaQuery.of(context).size.width -
                  position.dx -
                  notificationIcon.size.width,
              child: Card(
                elevation: 4,
                child: Container(
                  width: 350,
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: notifications
                        .where((n) => !n.isRead)
                        .map((notification) => ListTile(
                              title: Text(notification.title),
                              subtitle: Text(notification.message),
                              trailing: Text(
                                "${notification.date.day}/${notification.date.month}/${notification.date.year}",
                                style: TextStyle(fontSize: 12),
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showFilterPopup(BuildContext context) {
    final RenderBox filterIcon = context.findRenderObject() as RenderBox;
    final position = filterIcon.localToGlobal(Offset.zero);

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Stack(
          children: [
            Positioned(
              top: position.dy + filterIcon.size.height,
              right: MediaQuery.of(context).size.width -
                  position.dx -
                  filterIcon.size.width,
              child: Card(
                elevation: 4,
                child: Container(
                  width: 250,
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFilterOption("Location"),
                      _buildFilterOption("Service"),
                      _buildFilterOption("Price"),
                      _buildFilterOption("Rating"),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showCategoriesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("All Categories"),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: categories.map((category) {
              return ListTile(
                leading: Icon(category['icon'], color: AppColors.primaryRed),
                title: Text(category['title']),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to specific category page
                },
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close"),
          ),
        ],
      ),
    );
  }

  void _showSpecialOffersDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Special Offers"),
        content: Text("No special offers right now"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close"),
          ),
        ],
      ),
    );
  }

  // Side Navigation Drawer Method
  Widget _buildSideNavigationDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        color: AppColors.primaryDark,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Profile Header
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: AppColors.secondaryDark,
              ),
              accountName: Text(
                'John Doe',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: Text(
                'john.doe@example.com',
                style: TextStyle(
                  color: Colors.white70,
                ),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('images/profile.jpg'),
              ),
            ),

            // Navigation Items
            _buildDrawerItem(
              icon: Icons.home,
              title: 'Home',
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(currentIndex: 0),
                  ),
                );
              },
            ),
            _buildDrawerItem(
              icon: Icons.local_car_wash,
              title: 'Services',
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductsPage(currentIndex: 0),
                  ),
                );
              },
            ),
            _buildDrawerItem(
              icon: Icons.book,
              title: 'My Bookings',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TransactionHistoryScreen(),
                  ),
                );
              },
            ),
            _buildDrawerItem(
              icon: Icons.favorite,
              title: 'Favorites',
              onTap: () {
                // TODO: Implement Favorites Screen
              },
            ),
            _buildDrawerItem(
              icon: Icons.history,
              title: 'History',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TransactionHistoryScreen(),
                  ),
                );
              },
            ),
            _buildDrawerItem(
              icon: Icons.shopping_cart,
              title: 'Orders',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TransactionHistoryScreen(),
                  ),
                );
              },
            ),
            _buildDrawerItem(
              icon: Icons.person,
              title: 'Profile',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(currentIndex: 4),
                  ),
                );
              },
            ),
            _buildDrawerItem(
              icon: Icons.verified_user,
              title: 'Rewards',
              onTap: () {
                // TODO: Implement Rewards Screen
              },
            ),
            _buildDrawerItem(
              icon: Icons.car_rental,
              title: 'Availiable Cars',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ManageVehicle(),
                  ),
                );
              },
            ),
            _buildDrawerItem(
              icon: Icons.settings,
              title: 'Settings',
              onTap: () {
                // TODO: Implement Settings Screen
              },
            ),
            _buildDrawerItem(
              icon: Icons.local_offer,
              title: 'Special Offers',
              onTap: () {
                // TODO: Implement Special Offers Screen
              },
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build drawer items
  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.white,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      onTap: onTap,
      horizontalTitleGap: 10,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Count unread notifications
    int unreadNotifications = notifications.where((n) => !n.isRead).length;

    return Scaffold(
      drawer: _buildSideNavigationDrawer(context),
      bottomNavigationBar: AppBottomNavBar(),
      body: SafeArea(child: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(16),
        
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _topPart(unreadNotifications),
            CardWidget(),
            SizedBox(height: 20,),
            _specialOfferPart(),
            SizedBox(height: 10,),
            BannerImage(),
            SizedBox(height: 20,),
            QuickWidget(),
            SizedBox(height: 10,),
            QuickWidgetScroll(quickLinks: quickLinks),
            SizedBox(height: 20,),
            _categoryTextPart(),
            SizedBox(height: 20,),
            _categoryScrollPart(),
            SizedBox(height: 40,),
            PopularText(),
            SizedBox(height: 10,),
            _productList(),
            SizedBox(height: 20,),

          ],
        ),
        ),
      )),
      
    );
  }

































  GridView _productList() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.6,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _allProducts.length,
      itemBuilder: (context, index) {
        var product = _allProducts[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductsPage(),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Image.asset(
                    product['image'],
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product['name'],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryDark,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            product['price'],
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryRed,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryRed.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${product['discount']} OFF',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.primaryRed,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  SingleChildScrollView _categoryScrollPart() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          return Padding(
            padding: EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: _showCategoriesDialog,
              child: Chip(
                avatar: Icon(category['icon'], color: AppColors.primaryRed),
                label: Text(category['title']),
                backgroundColor: Colors.grey[200],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Row _categoryTextPart() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Categories",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryDark,
          ),
        ),
        GestureDetector(
          onTap: _showCategoriesDialog,
          child: Text(
            "See All",
            style: TextStyle(
              fontSize: 14,
              color: AppColors.primaryRed,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Row _specialOfferPart() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "#SpecialOffer",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryDark,
          ),
        ),
        GestureDetector(
          onTap: _showSpecialOffersDialog,
          child: Text(
            "View All",
            style: TextStyle(
              fontSize: 14,
              color: AppColors.primaryRed,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  SizedBox CardWidget() {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: AppColors.secondaryDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Builder(
                    builder: (context) => IconButton(
                      icon: Icon(Icons.menu, color: Colors.white),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                  ),
                  Text(
                    "Home",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage('images/profile.jpg'),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "RM 230.00",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryDark,
                    ),
                    child: Text(
                      "Top up Now >",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              Text(
                "Jan 2025",
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column _topPart(int unreadNotifications) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Hello Sudais Rehmani (100 Points)",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryDark,
              ),
            ),
            Builder(
              builder: (context) => Stack(
                children: [
                  IconButton(
                    icon:
                        Icon(Icons.notifications, color: AppColors.primaryRed),
                    onPressed: () => _showNotificationPopup(context),
                  ),
                  if (unreadNotifications > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '$unreadNotifications',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        Text(
          "Welcome to Sudais Rehmani Management System",
          style: TextStyle(fontSize: 14, color: Colors.black54),
        ),
        Divider(color: AppColors.primaryDark.withOpacity(0.3)),
      ],
    );
  }

  Widget _buildFilterOption(String title) {
    return ListTile(
      title: Text(title),
      trailing: Icon(Icons.chevron_right),
      onTap: () {
        Navigator.pop(context);
        // TODO: Implement specific filter logic
      },
    );
  }
}

class PopularText extends StatelessWidget {
  const PopularText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Popular Services",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryDark,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductsPage(),
              ),
            );
          },
          child: Text(
            "Get More",
            style: TextStyle(
              fontSize: 14,
              color: AppColors.primaryRed,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class QuickWidgetScroll extends StatelessWidget {
  const QuickWidgetScroll({
    super.key,
    required this.quickLinks,
  });

  final List<QuickLinkModel> quickLinks;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: quickLinks.map((link) {
          return Padding(
            padding: EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: link.onTap,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      link.icon,
                      size: 20,
                      color: AppColors.primaryRed,
                    ),
                    SizedBox(width: 8),
                    Text(
                      link.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class QuickWidget extends StatelessWidget {
  const QuickWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      "Quick Links",
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.primaryDark,
      ),
    );
  }
}

class BannerImage extends StatelessWidget {
  const BannerImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 150,
      child: Image.asset(
        'images/banner1.png',
        fit: BoxFit.cover,
      ),
    );
  }
}

class QuickLinkItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const QuickLinkItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F8F1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFE3F2FD),
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              size: 24,
              color: Colors.blue,
            ),
          ),
          SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
