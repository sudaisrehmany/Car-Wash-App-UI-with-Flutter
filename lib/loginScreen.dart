import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'forgot_password_screen.dart';
import 'register_screen.dart';
import 'home_page.dart';

// Custom color palette
class AppColors {
  static const Color primaryDark = Color(0xFF042b3d);
  static const Color primaryRed = Color(0xFFbe1e2d);
  static const Color secondaryDark = Color(0xFF1c4966);
  static const Color accentBlue = Color(0xFF2c5f85);
  static const Color lightBlue = Color(0xFF3b7ba3);
}

void main() {
  runApp(MaterialApp(
    home: LoginScreenWidget(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primaryColor: AppColors.primaryDark,
      scaffoldBackgroundColor: AppColors.primaryDark,
    ),
  ));
}

class LoginScreenWidget extends StatefulWidget {
  const LoginScreenWidget({super.key});

  @override
  _LoginScreenWidgetState createState() => _LoginScreenWidgetState();
}

class _LoginScreenWidgetState extends State<LoginScreenWidget> {
  final _formKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _mobileController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.primaryDark, // Dark blue background
      body: SingleChildScrollView(
        child: SizedBox(
          height: screenHeight,
          child: Column(
            children: [
              // Logo section
              Container(
                color: AppColors.primaryDark,
                padding: EdgeInsets.only(
                    top: screenHeight * 0.1, bottom: screenHeight * 0.03),
                child: Center(
                  child: Image.asset(
                    'assets/images/logo1.png',
                    height: screenHeight * 0.15, // Responsive height
                    width: screenHeight * 0.15, // Responsive width
                    color: Colors.white, // White logo for contrast
                  ),
                ),
              ),

              // White login container
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(screenWidth * 0.08),
                      topRight: Radius.circular(screenWidth * 0.08),
                    ),
                  ),
                  padding:
                      EdgeInsets.all(screenWidth * 0.06), // Responsive padding
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            "Login",
                            style: TextStyle(
                              fontSize:
                                  screenWidth * 0.08, // Responsive font size
                              fontWeight: FontWeight.w900,
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ),
                        SizedBox(
                            height: screenHeight * 0.04), // Responsive spacing
                        Text(
                          "Mobile No",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize:
                                screenWidth * 0.04, // Responsive font size
                            color: AppColors.secondaryDark,
                          ),
                        ),
                        SizedBox(
                            height: screenHeight * 0.01), // Responsive spacing
                        TextFormField(
                          controller: _mobileController,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            hintText: "Enter your Mobile No",
                            filled: true,
                            fillColor: AppColors.lightBlue.withOpacity(0.1),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(screenWidth * 0.03),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColors.primaryRed, width: 2),
                              borderRadius:
                                  BorderRadius.circular(screenWidth * 0.03),
                            ),
                            prefixIcon: Icon(Icons.phone_android,
                                color: AppColors.accentBlue),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Mobile number is required';
                            }
                            if (value.length != 11) {
                              return 'Mobile number must be 11 digits';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                            height: screenHeight * 0.03), // Responsive spacing
                        Text(
                          "Password",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize:
                                screenWidth * 0.04, // Responsive font size
                            color: AppColors.secondaryDark,
                          ),
                        ),
                        SizedBox(
                            height: screenHeight * 0.01), // Responsive spacing
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            hintText: "Enter your password",
                            filled: true,
                            fillColor: AppColors.lightBlue.withOpacity(0.1),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(screenWidth * 0.03),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColors.primaryRed, width: 2),
                              borderRadius:
                                  BorderRadius.circular(screenWidth * 0.03),
                            ),
                            prefixIcon:
                                Icon(Icons.lock, color: AppColors.accentBlue),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: AppColors.secondaryDark,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password is required';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                            height: screenHeight * 0.02), // Responsive spacing
                        // Remember Me and Forgot Password in one line
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: _rememberMe,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _rememberMe = value ?? false;
                                    });
                                  },
                                  activeColor: AppColors.primaryRed,
                                ),
                                Text(
                                  "Remember Me",
                                  style: TextStyle(
                                    color: AppColors.secondaryDark,
                                    fontWeight: FontWeight.w500,
                                    fontSize: screenWidth *
                                        0.035, // Responsive font size
                                  ),
                                ),
                              ],
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ForgotPasswordScreen()),
                                );
                              },
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  color: AppColors.primaryRed,
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenWidth *
                                      0.035, // Responsive font size
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                            height: screenHeight * 0.04), // Responsive spacing
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePage()),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryRed,
                              minimumSize: Size(screenWidth * 0.8,
                                  screenHeight * 0.06), // Responsive size
                              padding: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.02),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(screenWidth * 0.06),
                              ),
                              elevation: 5,
                              shadowColor: AppColors.primaryDark,
                            ),
                            child: Text(
                              "Login",
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize:
                                    screenWidth * 0.045, // Responsive font size
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                            height: screenHeight * 0.04), // Responsive spacing
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildSocialLoginButton(
                              icon: Icons.g_mobiledata,
                              color: AppColors.primaryRed,
                              onPressed: () async {
                                final Uri googleLoginUrl = Uri.parse(
                                    'https://accounts.google.com/v3/signin/identifier?continue=https%3A%2F%2Faccounts.google.com%2F&followup=https%3A%2F%2Faccounts.google.com%2F&ifkv=ASSHykq6KxQHJ0jVuVmgyfeRnpRZnvnp698UzuBe-QUuWq4Bj0e2rTVIP5ir-DRiNfTUqmGkVCsC&passive=1209600&flowName=GlifWebSignIn&flowEntry=ServiceLogin&dsh=S-1459396791%3A1739472633217150&ddm=1');

                                if (!await launchUrl(googleLoginUrl)) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Could not launch Google login')),
                                  );
                                }
                              },
                              size: screenWidth * 0.12, // Responsive size
                            ),
                            SizedBox(
                                width:
                                    screenWidth * 0.04), // Responsive spacing
                            _buildSocialLoginButton(
                              icon: Icons.facebook,
                              color: AppColors.accentBlue,
                              onPressed: () async {
                                final Uri facebookLoginUrl =
                                    Uri.parse('https://www.facebook.com/');

                                if (!await launchUrl(facebookLoginUrl)) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Could not launch Facebook login')),
                                  );
                                }
                              },
                              size: screenWidth * 0.12, // Responsive size
                            ),
                          ],
                        ),
                        SizedBox(
                            height: screenHeight * 0.02), // Responsive spacing
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account? ",
                              style: TextStyle(
                                color: AppColors.secondaryDark,
                                fontSize:
                                    screenWidth * 0.035, // Responsive font size
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          RegisterScreenWidget()),
                                );
                              },
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                  color: AppColors.primaryRed,
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenWidth *
                                      0.035, // Responsive font size
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialLoginButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    required double size,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: CircleBorder(),
        padding: EdgeInsets.all(size * 0.3), // Responsive padding
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: size * 0.6, // Responsive icon size
      ),
    );
  }
}
