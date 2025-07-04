import 'package:flutter/material.dart';
import 'products_page.dart';
import 'carWashDetails.dart';
import 'profileScreen.dart'; // Import ProfileScreen
import 'transaction_history.dart';
import 'bottomNavbar.dart';
import 'paymentSuccess.dart'; // Import PaymentSuccess
import 'carWashDetails.dart';
import 'credit_card_payment.dart';
import 'paymentInProgress.dart'; // Import PaymentInProgress

class AppColors {
  static const Color primaryDark = Color(0xFF042b3d);
  static const Color primaryRed = Color(0xFFbe1e2d);
  static const Color secondaryDark = Color(0xFF1c4966);
  static const Color accentBlue = Color(0xFF2c5f85);
  static const Color lightBlue = Color(0xFF3b7ba3);
}

void main() =>
    runApp(ManageVehicle(amount: 10.99, paymentMethod: 'Credit Card'));

class ManageVehicle extends StatefulWidget {
  final int currentIndex;

  final double? amount;
  final String? paymentMethod;

  const ManageVehicle(
      {Key? key,
      this.amount,
      this.paymentMethod = 'Credit Card',
      this.currentIndex = 0})
      : super(key: key);

  @override
  _ManageVehicleState createState() => _ManageVehicleState();
}

class _ManageVehicleState extends State<ManageVehicle> {
  // List to store added cars
  List<Map<String, String>> _addedCars = [];

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final _carModelController = TextEditingController();
  final _numberPlateController = TextEditingController();
  final _carNameController = TextEditingController();

  // Car model dropdown options
  final List<String> _carModelOptions = [
    'Sedan',
    'SUV',
    'Hatchback',
    'Truck',
    'Convertible'
  ];
  String? _selectedCarModel;

  // Validation for number plate
  String? _validateNumberPlate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Number plate is required';
    }

    // Updated regex to allow:
    // 1. Two letters at the start
    // 2. Either 3 or 6 digits
    // 3. Optional 2 letters at the end
    final numberPlateRegex = RegExp(r'^[A-Z]{2}\d{3,6}[A-Z]{0,2}$');

    if (!numberPlateRegex.hasMatch(value)) {
      return 'Invalid number plate format\n'
          'Examples: MH123, MH123456, MH123AB';
    }
    return null;
  }

  // Method to add a new car
  void _addNewCar() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _addedCars.add({
          'model': _selectedCarModel!,
          'numberPlate': _numberPlateController.text,
          'name': _carNameController.text,
        });

        // Clear controllers after adding
        _selectedCarModel = null;
        _carModelController.clear();
        _numberPlateController.clear();
        _carNameController.clear();
      });
    }
  }

  // Payment method selection dialog
  void _showPaymentMethodDialog() {
    String? selectedPaymentMethod;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 10,
              backgroundColor: Colors.white,
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Select Payment Method',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    SizedBox(height: 20),

                    // Online Payment Option
                    _buildPaymentMethodTile(
                      icon: Icons.credit_card,
                      title: 'Online Payment',
                      subtitle: 'Pay with credit/debit card',
                      value: 'Online Payment',
                      groupValue: selectedPaymentMethod,
                      onChanged: (value) {
                        setState(() {
                          selectedPaymentMethod = value;
                        });
                      },
                    ),

                    SizedBox(height: 10),

                    // Cash Payment Option
                    _buildPaymentMethodTile(
                      icon: Icons.attach_money,
                      title: 'Cash Payment',
                      subtitle: 'Pay at the car wash location',
                      value: 'Cash Payment',
                      groupValue: selectedPaymentMethod,
                      onChanged: (value) {
                        setState(() {
                          selectedPaymentMethod = value;
                        });
                      },
                    ),

                    SizedBox(height: 10),

                    // Mobile Pay Option
                    _buildPaymentMethodTile(
                      icon: Icons.phone_android,
                      title: 'Mobile Pay',
                      subtitle: 'Pay using mobile wallet',
                      value: 'Mobile Pay',
                      groupValue: selectedPaymentMethod,
                      onChanged: (value) {
                        setState(() {
                          selectedPaymentMethod = value;
                        });
                      },
                    ),

                    SizedBox(height: 20),

                    // Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: AppColors.primaryRed,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: selectedPaymentMethod != null
                              ? () {
                                  Navigator.of(context).pop();

                                  // Conditional navigation based on payment method
                                  if (selectedPaymentMethod ==
                                      'Online Payment') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CreditCardPaymentScreen(
                                          amount: widget.amount ?? 0,
                                          paymentMethod: selectedPaymentMethod!,
                                        ),
                                      ),
                                    );
                                  } else {
                                    // For Mobile Pay and Cash Payment
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PaymentInProgress(
                                          amount: widget.amount ?? 0,
                                          paymentMethod: selectedPaymentMethod!,
                                          carModel: _addedCars.first['model']!,
                                          numberPlate:
                                              _addedCars.first['numberPlate']!,
                                        ),
                                      ),
                                    );
                                  }
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selectedPaymentMethod != null
                                ? AppColors.primaryDark
                                : Colors.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Pay Now',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Helper method to build payment method tiles
  Widget _buildPaymentMethodTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
    required String? groupValue,
    required void Function(String?)? onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: groupValue == value
            ? AppColors.primaryDark.withOpacity(0.1)
            : Colors.grey[100],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color:
              groupValue == value ? AppColors.primaryDark : Colors.transparent,
          width: 2,
        ),
      ),
      child: RadioListTile<String>(
        secondary: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color:
                groupValue == value ? AppColors.primaryDark : Colors.grey[300],
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: groupValue == value ? Colors.white : Colors.black54,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: groupValue == value ? AppColors.primaryDark : Colors.black87,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: groupValue == value
                ? AppColors.primaryDark.withOpacity(0.7)
                : Colors.grey,
          ),
        ),
        value: value,
        groupValue: groupValue,
        onChanged: onChanged,
        controlAffinity: ListTileControlAffinity.trailing,
      ),
    );
  }

  // Modify Continue to Payment method
  void _navigateToPaymentSuccess() {
    if (_addedCars.isNotEmpty) {
      _showPaymentMethodDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: AppColors.primaryDark,
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Image.asset(
                'assets/images/logo1.png',
                height: 150,
                color: Colors.white,
                fit: BoxFit.contain,
              ),
            ),
            // Added Cars List
            Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Vehicles',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  SizedBox(height: 10),
                  _addedCars.isEmpty
                      ? Text('No vehicles added yet')
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _addedCars.length,
                          itemBuilder: (context, index) {
                            final car = _addedCars[index];
                            return Card(
                              elevation: 2,
                              margin: EdgeInsets.symmetric(vertical: 5),
                              child: ListTile(
                                title: Text(car['name']!),
                                subtitle: Text(
                                    '${car['model']} - ${car['numberPlate']}'),
                                trailing: Icon(Icons.directions_car,
                                    color: AppColors.primaryDark),
                              ),
                            );
                          },
                        ),
                ],
              ),
            ),

            // Add New Car Form
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Add New Vehicle',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    SizedBox(height: 10),

                    // Car Name
                    TextFormField(
                      controller: _carNameController,
                      decoration: InputDecoration(
                        labelText: 'Car Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Car name is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),

                    // Car Model Dropdown
                    DropdownButtonFormField<String>(
                      value: _selectedCarModel,
                      decoration: InputDecoration(
                        labelText: 'Car Model',
                        border: OutlineInputBorder(),
                      ),
                      items: _carModelOptions
                          .map((model) => DropdownMenuItem(
                                value: model,
                                child: Text(model),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCarModel = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a car model';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),

                    // Number Plate
                    TextFormField(
                      controller: _numberPlateController,
                      decoration: InputDecoration(
                        labelText: 'Number Plate',
                        hintText: 'MH02AB1234',
                        border: OutlineInputBorder(),
                      ),
                      validator: _validateNumberPlate,
                    ),
                    SizedBox(height: 20),

                    // Add Car Button
                    ElevatedButton(
                      onPressed: _addNewCar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryDark,
                        padding: EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: Text(
                        'Add Car',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Continue to Payment Button
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      _addedCars.isNotEmpty ? _navigateToPaymentSuccess : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryRed,
                    padding: EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: Text(
                    'Continue to Payment',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(initialIndex: widget.currentIndex),
    );
  }

  @override
  void dispose() {
    // Clean up controllers
    _carModelController.dispose();
    _numberPlateController.dispose();
    _carNameController.dispose();
    super.dispose();
  }
}
