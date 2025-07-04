import 'package:carwash_app/products_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flip_card/flip_card.dart';
import 'paymentInProgress.dart';
import 'carWashDetails.dart'; // For AppColors
import 'manageVehicle.dart'; // Import ManageVehicle
import 'products_page.dart';

class AppColors {
  static const Color primaryDark = Color(0xFF042b3d);
  static const Color primaryRed = Color(0xFFbe1e2d);
  static const Color secondaryDark = Color(0xFF1c4966);
  static const Color accentBlue = Color(0xFF2c5f85);
  static const Color lightBlue = Color(0xFF3b7ba3);
}

class CreditCardPaymentScreen extends StatefulWidget {
  final double amount;
  final String paymentMethod;

  const CreditCardPaymentScreen(
      {Key? key, required this.amount, this.paymentMethod = 'Credit Card'})
      : super(key: key);

  @override
  _CreditCardPaymentScreenState createState() =>
      _CreditCardPaymentScreenState();
}

class _CreditCardPaymentScreenState extends State<CreditCardPaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isCardAdded = false;
  bool _saveCardChecked = false;
  String _cardNumber = '';
  String _cardHolder = '';
  String _expiryDate = '';
  String _cvv = '';

  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardHolderController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  void _addCard() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isCardAdded = true;
        _cardNumber = _cardNumberController.text;
        _cardHolder = _cardHolderController.text;
        _expiryDate = _expiryDateController.text;
        _cvv = _cvvController.text;
      });
    }
  }

  void _submitPayment() {
    if (_isCardAdded) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentInProgress(
            amount: widget.amount,
            paymentMethod: widget.paymentMethod,
            carModel: 'Default Car Model',
            numberPlate: 'DEFAULT 0000',
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please add a card first')),
      );
    }
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Credit Card Payment',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primaryDark,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(
                bottom: 100), // Add padding to accommodate bottom button
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Payment Amount: RM ${widget.amount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: FlipCard(
                      direction: FlipDirection.HORIZONTAL,
                      front: _buildCreditCardFront(),
                      back: _buildCreditCardBack(),
                      flipOnTouch: true,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildCardNumberField(),
                        SizedBox(height: 16),
                        _buildCardHolderField(),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(child: _buildExpiryDateField()),
                            SizedBox(width: 16),
                            Expanded(child: _buildCVVField()),
                          ],
                        ),
                        SizedBox(height: 16),
                        // Save Card Checkbox
                        Row(
                          children: [
                            Checkbox(
                              value: _saveCardChecked,
                              activeColor: AppColors.primaryRed,
                              onChanged: (bool? value) {
                                setState(() {
                                  _saveCardChecked = value ?? false;
                                });
                              },
                            ),
                            Text(
                              'Save Card for Future Payments',
                              style: TextStyle(
                                color: AppColors.primaryDark,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _addCard,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryRed,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Add Card',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                if (_isCardAdded)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Card(
                      color: AppColors.secondaryDark,
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Card Information',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            _buildInfoRow('Card Number',
                                '**** **** **** ${_cardNumber.substring(_cardNumber.length - 4)}'),
                            _buildInfoRow('Card Holder', _cardHolder),
                            _buildInfoRow('Expiry Date', _expiryDate),
                          ],
                        ),
                      ),
                    ),
                  ),
                SizedBox(height: 20),
                // Payment Summary Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildPaymentSummaryRow('Subtotal', widget.amount * 0.9),
                      _buildPaymentSummaryRow('Tax (10%)', widget.amount * 0.1),
                      Divider(color: AppColors.primaryDark, thickness: 2),
                      _buildPaymentSummaryRow('Total', widget.amount,
                          isTotalRow: true),
                    ],
                  ),
                ),
                // Extra space at bottom to ensure "Pay Now" button is not covered
                SizedBox(height: 100),
              ],
            ),
          ),
          // Positioned Pay Now Button at the bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  // Cancel Button
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductsPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryRed,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10), // Spacing between buttons
                  // Pay Now Button
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _submitPayment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryDark,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Pay Now \$${widget.amount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // New method to build payment summary rows
  Widget _buildPaymentSummaryRow(String label, double amount,
      {bool isTotalRow = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotalRow ? 18 : 16,
              fontWeight: isTotalRow ? FontWeight.bold : FontWeight.normal,
              color: isTotalRow ? AppColors.primaryDark : Colors.black87,
            ),
          ),
          Text(
            'RM ${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: isTotalRow ? 18 : 16,
              fontWeight: isTotalRow ? FontWeight.bold : FontWeight.normal,
              color: isTotalRow ? AppColors.primaryRed : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreditCardFront() {
    return Container(
      width: 350,
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: [AppColors.primaryDark, AppColors.secondaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 4),
            blurRadius: 5.0,
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'images/mastercardlogo.png',
                  height: 50,
                  width: 50,
                ),
                Text(
                  'MASTERCARD',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Spacer(),
            Text(
              '4111 1111 1111 1111',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                letterSpacing: 2,
              ),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'JOHN DOE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '12/25',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreditCardBack() {
    return Container(
      width: 350,
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: [AppColors.primaryDark, AppColors.secondaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 4),
            blurRadius: 5.0,
          )
        ],
      ),
      child: Column(
        children: [
          SizedBox(height: 20),
          Container(
            height: 50,
            color: Colors.black,
          ),
          SizedBox(height: 20),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '123',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'Tap to flip',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardNumberField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextFormField(
        controller: _cardNumberController,
        decoration: InputDecoration(
          labelText: 'Card Number',
          hintText: '1234 5678 9012 3456',
          prefixIcon: Icon(Icons.credit_card, color: AppColors.primaryDark),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(16),
          _CardNumberInputFormatter(),
        ],
        validator: (value) {
          if (value == null || value.replaceAll(' ', '').length != 16) {
            return 'Please enter a valid card number';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildCardHolderField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextFormField(
        controller: _cardHolderController,
        decoration: InputDecoration(
          labelText: 'Card Holder Name',
          hintText: 'Suneel Pirkash',
          prefixIcon: Icon(Icons.person, color: AppColors.primaryDark),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter card holder name';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildExpiryDateField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextFormField(
        controller: _expiryDateController,
        decoration: InputDecoration(
          labelText: 'Expiry Date',
          hintText: 'MM/YY',
          prefixIcon: Icon(Icons.calendar_today, color: AppColors.primaryDark),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(4),
          _ExpiryDateInputFormatter(),
        ],
        validator: (value) {
          if (value == null || value.length != 5) {
            return 'Invalid date';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildCVVField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextFormField(
        controller: _cvvController,
        decoration: InputDecoration(
          labelText: 'CVV',
          hintText: '123',
          prefixIcon: Icon(Icons.lock, color: AppColors.primaryDark),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        keyboardType: TextInputType.number,
        obscureText: true,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(3),
        ],
        validator: (value) {
          if (value == null || value.length != 3) {
            return 'Invalid CVV';
          }
          return null;
        },
      ),
    );
  }
}

class _CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text.replaceAll(' ', '');
    var formattedText = '';

    for (var i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) {
        formattedText += ' ';
      }
      formattedText += text[i];
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}

class _ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text.replaceAll('/', '');
    var formattedText = '';

    for (var i = 0; i < text.length; i++) {
      if (i == 2) {
        formattedText += '/';
      }
      formattedText += text[i];
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
