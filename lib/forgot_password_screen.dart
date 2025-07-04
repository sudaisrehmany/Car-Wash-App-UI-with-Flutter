import 'package:flutter/material.dart';
import 'create_new_password_screen.dart';
import 'loginScreen.dart';

void main() => runApp(ForgotPasswordScreen());

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    // Regular expression for email validation
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  void _sendResetInstruction() {
    if (_formKey.currentState!.validate()) {
      // Proceed with sending reset instruction
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateNewPasswordScreen(),
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Color palette
    final Color primaryRed = Color(0xFFBE1E2D);
    final Color primaryBlue = Color(0xFF042B3D);
    final Color secondaryRed = Color(0xFFD14A5A);
    final Color secondaryBlue = Color(0xFF1A4B6E);
    final Color lightBlue = Color(0xFF6B8E9F);

    return MaterialApp(
      home: Scaffold(
        backgroundColor: primaryBlue, // Background color for the whole screen
        body: Column(
          children: [
            // Logo at top center
            Padding(
              padding: EdgeInsets.only(top: 50),
              child: Center(
                child: Image.asset(
                  'assets/images/logo1.png', // Make sure to add your logo to assets
                  height: 150,
                  width: 150,
                  color: Colors.white, // White logo for contrast
                ),
              ),
            ),

            // White container for forget password section
            Expanded(
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Center(
                        child: Text(
                          "Forget Password",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            color: primaryBlue,
                          ),
                        ),
                      ),

                      SizedBox(height: 10),

                      // Subtitle
                      Center(
                        child: Text(
                          "No worries! Enter your email address below and we will send you a code to reset password.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: secondaryBlue,
                          ),
                        ),
                      ),

                      SizedBox(height: 30),

                      // Email label
                      Text("E-mail",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, color: primaryBlue)),

                      SizedBox(height: 10),

                      // Email TextField
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: _validateEmail,
                        decoration: InputDecoration(
                          hintText: "Enter your email",
                          hintStyle: TextStyle(color: lightBlue),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: secondaryBlue),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: primaryRed, width: 2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: primaryRed, width: 2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: primaryRed, width: 2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreenWidget(),
                                ),
                              );
                            },
                            child: RichText(
                              text: TextSpan(
                                text: "Remember your password? ",
                                style: TextStyle(
                                  color: primaryBlue,
                                  fontSize: 16,
                                ),
                                children: [
                                  TextSpan(
                                    text: "Login",
                                    style: TextStyle(
                                      color: secondaryBlue,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Spacer(), // Pushes the button to the bottom

                      // Send Reset Instruction Button
                      Center(
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _sendResetInstruction,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryRed,
                              padding: EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              "Reset Password",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),

            // Login navigation text
          ],
        ),
      ),
    );
  }
}
