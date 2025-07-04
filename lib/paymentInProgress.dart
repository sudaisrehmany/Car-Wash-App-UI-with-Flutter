import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'credit_card_payment.dart';
import 'paymentSuccess.dart';
import 'products_page.dart';

class AppColors {
  static const Color primaryDark = Color(0xFF042b3d);
  static const Color primaryRed = Color(0xFFbe1e2d);
  static const Color secondaryDark = Color(0xFF1c4966);
  static const Color accentBlue = Color(0xFF2c5f85);
  static const Color lightBlue = Color(0xFF3b7ba3);
}

class PaymentInProgress extends StatefulWidget {
  final double amount;
  final String paymentMethod;
  final String carModel;
  final String numberPlate;

  const PaymentInProgress({
    Key? key,
    this.amount = 0.0,
    required this.paymentMethod,
    this.carModel = '',
    this.numberPlate = '',
  }) : super(key: key);

  @override
  _PaymentInProgressState createState() => _PaymentInProgressState();
}

class _PaymentInProgressState extends State<PaymentInProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _carAnimation;

  @override
  void initState() {
    super.initState();

    // Animation controller for car movement
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: false);

    // Slide animation from left to right
    _carAnimation = Tween<Offset>(
      begin: Offset(-1.5, 0), // Start off-screen to the left
      end: Offset(1.5, 0), // End off-screen to the right
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Auto-navigate to PaymentSuccess after 5 seconds
    Future.delayed(Duration(seconds: 5), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentSuccess(
              amount: widget.amount,
              paymentMethod: widget.paymentMethod,
              carModel: widget.carModel,
              numberPlate: widget.numberPlate,
            ),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Centered Logo
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Image.asset(
                'images/logo1.png', // Assuming you have a logo image
                width: 150,
                height: 150,
                color: Colors.white,
              ),
            ),

            // Payment Progress Text
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
              child: Text(
                'Processing Payment',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // Animated Car Image
            SlideTransition(
              position: _carAnimation,
              child: Image.asset(
                'images/carmodel.png',
                width: 250,
                height: 150,
                fit: BoxFit.contain,
              ),
            ),

            // Progress Indicators
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: LinearProgressIndicator(
                backgroundColor: AppColors.secondaryDark,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryRed),
                minHeight: 10,
              ),
            ),

            // Additional Progress Text
            SizedBox(height: 20),
            Text(
              'Please wait while we process your payment',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),

            // Cancel Option
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Navigate back to Credit Card Payment
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreditCardPaymentScreen(
                      amount: widget.amount,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Cancel Payment',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
