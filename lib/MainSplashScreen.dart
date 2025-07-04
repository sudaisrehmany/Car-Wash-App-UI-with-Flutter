import 'package:flutter/material.dart';
import 'dart:async';
import 'splash_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _carPosition = -200; // Start off-screen to the left

  @override
  void initState() {
    super.initState();
    _startAnimation();
    Timer(Duration(seconds: 4), () {
      // Navigate to the next screen after 5 seconds
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => OnboardingScreen()),
      );
    });
  }

  void _startAnimation() {
    Timer.periodic(Duration(milliseconds: 60), (timer) {
      setState(() {
        if (_carPosition < MediaQuery.of(context).size.width) {
          _carPosition += 10; // Move car to the right
        } else {
          timer.cancel(); // Stop when car is off-screen to the right
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            left: _carPosition,
            top: MediaQuery.of(context).size.height / 2 - 100,
            child: Image.asset(
              'assets/images/carmodel.png', // Replace with your actual asset path
              width: 200,
              height: 200,
            ),
          ),
        ],
      ),
    );
  }
}
