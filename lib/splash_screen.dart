import 'package:flutter/material.dart';
import 'loginScreen.dart';
import 'register_screen.dart';

void main() {
  runApp(MaterialApp(home: OnboardingScreen()));
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _slideAnimation = Tween<Offset>(begin: Offset(0, 0.5), end: Offset.zero)
        .animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Center(
                child: Image.asset(
                  'assets/images/logo1.png',
                  height: screenHeight * 0.3, // Responsive height
                ),
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.05), // Responsive spacing
          FadeTransition(
            opacity: _fadeAnimation,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildButton(
                  "Register",
                  () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegisterScreenWidget())),
                  isOutlined: true,
                  screenWidth: screenWidth,
                ),
                SizedBox(width: screenWidth * 0.07), // Responsive spacing
                _buildButton(
                  "Login",
                  () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginScreenWidget())),
                  isOutlined: false,
                  screenWidth: screenWidth,
                ),
              ],
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed,
      {bool isOutlined = false, required double screenWidth}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(screenWidth * 0.4, 45), // Responsive width
        backgroundColor: isOutlined ? Colors.white : const Color(0xFF2B8761),
        side: isOutlined ? BorderSide(color: Colors.black) : null,
        elevation: isOutlined ? 0 : 3,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: screenWidth * 0.04, // Responsive font size
          color: isOutlined ? Colors.black : Colors.white,
        ),
      ),
    );
  }
}
