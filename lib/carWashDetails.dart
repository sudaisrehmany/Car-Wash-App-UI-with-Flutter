import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'products_page.dart';
import 'paymentInProgress.dart';
import 'bottomNavbar.dart';
import 'credit_card_payment.dart';
import 'manageVehicle.dart'; // Import ManageVehicle

class AppColors {
  static const Color primaryDark = Color(0xFF042b3d);
  static const Color primaryRed = Color(0xFFbe1e2d);
  static const Color secondaryDark = Color(0xFF1c4966);
  static const Color accentBlue = Color(0xFF2c5f85);
  static const Color lightBlue = Color(0xFF3b7ba3);
}

void main() {
  runApp(CarWashDetails(
    productName: 'CAR WASH',
    productDescription:
        'Sudais Rehmani Car wash service. Normal Car wash with estimate time 30-45 mins.',
    productPrice: 12.0,
    productImage: 'images/banner1.png',
  ));
}

class CarWashDetails extends StatefulWidget {
  final String? productName;
  final String? productDescription;
  final double? productPrice;
  final String? productImage;

  const CarWashDetails({
    super.key,
    this.productName,
    this.productDescription,
    this.productPrice,
    this.productImage,
  });

  @override
  _CarWashDetailsState createState() => _CarWashDetailsState();
}

class _CarWashDetailsState extends State<CarWashDetails>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }

  void _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunch(launchUri.toString())) {
      await launch(launchUri.toString());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not make phone call')),
      );
    }
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text(_isFavorite ? 'Added to Favorites' : 'Removed from Favorites'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   // title: Text(
      //   //   widget.productName ?? 'Car Wash Details',
      //   //   style: TextStyle(color: Colors.white),
      //   // ),
      //   backgroundColor: AppColors.primaryDark,
      //   iconTheme: IconThemeData(color: Colors.white),
      // ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 250.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: widget.productImage != null
                    ? Image.asset(
                        widget.productImage!,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        color: AppColors.primaryDark,
                        child: Center(
                          child: Icon(
                            Icons.local_car_wash,
                            size: 100,
                            color: Colors.white,
                          ),
                        ),
                      ),
              ),
            ),
          ];
        },
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.productName ?? 'Car Wash Service',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryDark,
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            widget.productPrice != null
                                ? 'RM ${widget.productPrice!.toStringAsFixed(2)}'
                                : 'Price not available',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryRed,
                            ),
                          ),
                          // SizedBox(width: 10),
                          RatingBar.builder(
                            initialRating: 4.5,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 20,
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {},
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.productDescription ??
                        'Comprehensive car wash service',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Icon(Icons.location_on, color: AppColors.primaryRed),
                  SizedBox(width: 8),
                  Text(
                    'Google Maps Current Location',
                    style: TextStyle(color: AppColors.secondaryDark),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Open: Mon-Sun, 11am-11pm | 5 km away',
                style: TextStyle(color: AppColors.accentBlue),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _roundedIconButton(Icons.web, 'Website',
                      () => _launchURL('https://example.com')),
                  _roundedIconButton(Icons.message, 'Message', () {}),
                  _roundedIconButton(
                      Icons.call, 'Call', () => _makePhoneCall('+1234567890')),
                  _roundedIconButton(Icons.share, 'Share', () {}),
                ],
              ),
            ),
            TabBar(
              controller: _tabController,
              labelColor: AppColors.primaryDark,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppColors.primaryRed,
              tabs: [
                Tab(text: 'About'),
                Tab(text: 'Service'),
                Tab(text: 'Gallery'),
                Tab(text: 'Reviews'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildAboutTab(),
                  _buildServiceTab(),
                  _buildGalleryTab(),
                  _buildReviewsTab(),
                ],
              ),
            ),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Implement Redeem functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Redeem feature coming soon!')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryDark,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: Size(100, 50),
                    ),
                    child: Text(
                      'Redeem',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ManageVehicle()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryRed,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: Size(150, 50),
                    ),
                    child: Text('Buy Now',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(width: 16),
                  IconButton(
                    onPressed: _toggleFavorite,
                    icon: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: AppColors.primaryRed,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            AppBottomNavBar()
          ],
        ),
      ),
    );
  }

  Widget _roundedIconButton(
      IconData icon, String label, VoidCallback onPressed) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
            padding: EdgeInsets.all(15),
            backgroundColor: AppColors.lightBlue,
          ),
          child: Icon(icon, color: Colors.white),
        ),
        SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildAboutTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About Our Car Wash',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryDark,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'We provide top-quality car wash services with attention to detail. Our experienced team ensures your vehicle gets the best care possible. From exterior cleaning to interior detailing, we cover all your car maintenance needs.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Our Services',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryDark,
            ),
          ),
          SizedBox(height: 8),
          _serviceItem('Basic Wash', 'Exterior cleaning and drying', 'RM 12'),
          _serviceItem('Premium Wash', 'Exterior + Interior cleaning', 'RM 25'),
          _serviceItem('Deluxe Wash', 'Full detailing service', 'RM 50'),
        ],
      ),
    );
  }

  Widget _serviceItem(String title, String description, String price) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.secondaryDark,
          ),
        ),
        subtitle: Text(description),
        trailing: Text(
          price,
          style: TextStyle(
            color: AppColors.primaryRed,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildGalleryTab() {
    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/banner1.png'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
        );
      },
    );
  }

  Widget _buildReviewsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.rate_review_outlined,
            size: 80,
            color: AppColors.accentBlue,
          ),
          SizedBox(height: 16),
          Text(
            'No Reviews Now',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryDark,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Be the first to leave a review!',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement review submission functionality
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Review submission coming soon')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Write a Review',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class PaymentMethodSelectionDialog extends StatefulWidget {
  final double amount;

  const PaymentMethodSelectionDialog({super.key, this.amount = 12.0});

  @override
  _PaymentMethodSelectionDialogState createState() =>
      _PaymentMethodSelectionDialogState();
}

class _PaymentMethodSelectionDialogState
    extends State<PaymentMethodSelectionDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Select Payment Method',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryDark,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.credit_card, color: AppColors.primaryRed),
            title: Text('Credit Card'),
            subtitle: Text('Pay securely online'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreditCardPaymentScreen(
                    amount: widget.amount,
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.money, color: AppColors.primaryRed),
            title: Text('Cash Payment'),
            subtitle: Text('Pay at the service location'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentInProgress(
                    amount: widget.amount,
                    paymentMethod: 'Car Wash Service',
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
