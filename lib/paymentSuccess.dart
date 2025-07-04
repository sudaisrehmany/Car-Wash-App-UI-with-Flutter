import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:printing/printing.dart';
import 'package:permission_handler/permission_handler.dart';
import 'bottomNavbar.dart';
import 'status.dart';
import 'transaction_history.dart';

class AppColors {
  static const Color primaryDark = Color(0xFF042b3d);
  static const Color primaryRed = Color(0xFFbe1e2d);
  static const Color secondaryDark = Color(0xFF1c4966);
  static const Color accentBlue = Color(0xFF2c5f85);
  static const Color lightBlue = Color(0xFF3b7ba3);
}

class PaymentSuccess extends StatefulWidget {
  final double amount;
  final String paymentMethod;
  final String carModel;
  final String numberPlate;

  const PaymentSuccess({
    Key? key,
    required this.amount,
    required this.paymentMethod,
    this.carModel = '',
    this.numberPlate = '',
  }) : super(key: key);

  @override
  _PaymentSuccessState createState() => _PaymentSuccessState();
}

class _PaymentSuccessState extends State<PaymentSuccess> {
  late DateTime _transactionDate;
  late String _transactionTime;

  @override
  void initState() {
    super.initState();
    _transactionDate = DateTime.now();
    _transactionTime = DateFormat('HH:mm:ss').format(_transactionDate);
  }

  Future<void> _downloadReceipt() async {
    // Request storage permission
    var status = await Permission.storage.request();
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Storage permission is required to download receipt')),
      );
      return;
    }

    // Create PDF
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Car Wash Receipt',
                style:
                    pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),
            pw.Text('Payment Details:',
                style:
                    pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Text('Amount: \$${widget.amount.toStringAsFixed(2)}'),
            pw.Text('Payment Method: ${widget.paymentMethod}'),
            pw.Text('Car Model: ${widget.carModel}'),
            pw.Text('Number Plate: ${widget.numberPlate}'),
            pw.SizedBox(height: 20),
            pw.Text('Thank you for using our Car Wash Service!',
                style: pw.TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );

    // Save PDF
    try {
      final directory = Platform.isAndroid
          ? await getExternalStorageDirectory()
          : await getApplicationDocumentsDirectory();

      final file = File(
          '${directory!.path}/car_wash_receipt_${DateTime.now().millisecondsSinceEpoch}.pdf');
      await file.writeAsBytes(await pdf.save());

      // Print or share the PDF
      await Printing.sharePdf(
          bytes: await pdf.save(), filename: 'car_wash_receipt.pdf');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Receipt downloaded to ${file.path}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to download receipt: $e')),
      );
    }
  }

  void _viewBookings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransactionHistoryScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      // appBar: AppBar(
      //   title: Text('Payment Success', style: TextStyle(color: Colors.white)),
      //   backgroundColor: AppColors.primaryDark,
      // ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 50),
              // Success Icon
              Icon(
                Icons.check_circle,
                color: AppColors.primaryRed,
                size: 100,
              ),
              SizedBox(height: 20),
              // Success Message
              Text(
                'Payment Successful!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30),

              // Transaction Details Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Card(
                  color: AppColors.secondaryDark,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow('Date',
                            DateFormat('yyyy-MM-dd').format(_transactionDate)),
                        _buildDetailRow('Time', _transactionTime),
                        _buildDetailRow('Payment Method', widget.paymentMethod),
                        _buildDetailRow(
                            'Amount', '\$${widget.amount.toStringAsFixed(2)}'),

                        // Vehicle Details
                        Divider(color: Colors.white30),
                        _buildDetailRow('Car Model', widget.carModel),
                        _buildDetailRow('Number Plate', widget.numberPlate),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),

              // Download Receipt Button
              ElevatedButton(
                onPressed: _downloadReceipt,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryRed,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: Text(
                  'Download Receipt',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(height: 20),

              // New View Bookings Button
              ElevatedButton(
                onPressed: _viewBookings,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryDark,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: Text(
                  'View Bookings',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Return to Home Button
              TextButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: Text(
                  'Return to Home',
                  style: TextStyle(
                    color: AppColors.primaryDark,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
