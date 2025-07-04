import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'bottomNavbar.dart';

class AppColors {
  static const Color primaryDark = Color(0xFF042b3d);
  static const Color primaryRed = Color(0xFFbe1e2d);
  static const Color secondaryDark = Color(0xFF1c4966);
  static const Color primaryBlue = Color(0xFF2c5f85);
  static const Color accentGreen = Color(0xFF4CAF50);
}

class TransactionHistoryScreen extends StatefulWidget {
  final int currentIndex;

  const TransactionHistoryScreen({
    Key? key, 
    this.currentIndex = 0,
  }) : super(key: key);

  @override
  _TransactionHistoryScreenState createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  // Transaction status categories
  final List<String> _categories = ['All', 'Pending', 'Completed', 'Cancelled'];
  String _selectedCategory = 'All';

  // Dummy transaction data
  final List<Map<String, dynamic>> _transactions = [
    {
      'id': 'TXN001',
      'date': '2024-02-10',
      'time': '10:30 AM',
      'service': 'Basic Wash',
      'amount': 12.00,
      'status': 'Completed',
      'carModel': 'Toyota Camry',
      'numberPlate': 'ABC1234',
    },
    {
      'id': 'TXN002',
      'date': '2024-02-12',
      'time': '02:45 PM',
      'service': 'Premium Wash',
      'amount': 25.00,
      'status': 'Pending',
      'carModel': 'Honda Civic',
      'numberPlate': 'XYZ5678',
    },
    {
      'id': 'TXN003',
      'date': '2024-02-13',
      'time': '11:15 AM',
      'service': 'Deluxe Wash',
      'amount': 35.00,
      'status': 'Cancelled',
      'carModel': 'Ford Mustang',
      'numberPlate': 'DEF9012',
    },
    {
      'id': 'TXN004',
      'date': '2024-02-14',
      'time': '09:00 AM',
      'service': 'Basic Wash',
      'amount': 12.00,
      'status': 'Completed',
      'carModel': 'Tesla Model 3',
      'numberPlate': 'GHI3456',
    },
    {
      'id': 'TXN005',
      'date': '2024-02-15',
      'time': '04:20 PM',
      'service': 'Premium Wash',
      'amount': 25.00,
      'status': 'Pending',
      'carModel': 'BMW X5',
      'numberPlate': 'JKL7890',
    }
  ];

  // Filter transactions based on selected category
  List<Map<String, dynamic>> get _filteredTransactions {
    if (_selectedCategory == 'All') {
      return _transactions;
    }
    return _transactions.where((txn) => txn['status'] == _selectedCategory).toList();
  }

  // Get status color based on transaction status
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Completed':
        return Colors.green;
      case 'Pending':
        return Colors.orange;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Download transaction receipt
  Future<void> _downloadTransactionReceipt(Map<String, dynamic> transaction) async {
    // Request storage permission
    var status = await Permission.storage.request();
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Storage permission is required to download receipt')),
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
            pw.Text('Car Wash Transaction Receipt', 
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),
            pw.Text('Transaction Details:', 
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Text('Transaction ID: ${transaction['id']}'),
            pw.Text('Service: ${transaction['service']}'),
            pw.Text('Car Model: ${transaction['carModel']}'),
            pw.Text('Number Plate: ${transaction['numberPlate']}'),
            pw.Text('Date: ${transaction['date']}'),
            pw.Text('Time: ${transaction['time']}'),
            pw.Text('Amount: RM ${transaction['amount'].toStringAsFixed(2)}'),
            pw.Text('Status: ${transaction['status']}'),
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
      
      final file = File('${directory!.path}/transaction_receipt_${transaction['id']}.pdf');
      await file.writeAsBytes(await pdf.save());

      // Share or print the PDF
      await Printing.sharePdf(bytes: await pdf.save(), filename: 'transaction_receipt.pdf');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Receipt downloaded to ${file.path}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to download receipt: $e')),
      );
    }
  }

  // Method to show review dialog
  void _showReviewDialog(BuildContext context) {
    int selectedRating = 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                'Rate Your Experience',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDark,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'How was your car wash service?',
                    style: GoogleFonts.poppins(
                      color: Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedRating = index + 1;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Icon(
                            index < selectedRating 
                              ? Icons.star 
                              : Icons.star_border,
                            color: index < selectedRating 
                              ? Colors.amber 
                              : Colors.grey,
                            size: 40,
                          ),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Additional comments (optional)',
                      hintStyle: GoogleFonts.poppins(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: AppColors.primaryBlue),
                      ),
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.poppins(color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement review submission logic
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Thank you for your feedback!',
                          style: GoogleFonts.poppins(),
                        ),
                        backgroundColor: AppColors.primaryBlue,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Submit Review',
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Show transaction details dialog
  void _showTransactionDetailsDialog(Map<String, dynamic> transaction) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Transaction Details',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryDark,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Transaction ID', transaction['id']),
                _buildDetailRow('Date', transaction['date']),
                _buildDetailRow('Service', transaction['service']),
                _buildDetailRow('Amount', 'RM ${transaction['amount'].toStringAsFixed(2)}'),
                _buildDetailRow('Status', transaction['status']),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Close',
                style: GoogleFonts.poppins(color: AppColors.primaryRed),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                _downloadTransactionReceipt(transaction); // Download receipt
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
              ),
              child: Text(
                'Download Receipt',
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            ),
            // Conditionally show review button for completed transactions
            if (transaction['status'].toLowerCase() == 'completed')
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close transaction details
                  _showReviewDialog(context); // Open review dialog
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Leave a Review',
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
              ),
          ],
        );
      },
    );
  }

  // Helper method to build detail rows
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryDark,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              color: AppColors.primaryBlue,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Transaction History', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primaryBlue,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Recent Transactions',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryBlue,
              ),
            ),
          ),
          
          // Category Selector
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: _categories.map((category) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: _selectedCategory == category,
                    onSelected: (bool selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    selectedColor: AppColors.primaryBlue.withOpacity(0.2),
                    backgroundColor: Colors.grey[200],
                    labelStyle: TextStyle(
                      color: _selectedCategory == category 
                        ? AppColors.primaryBlue 
                        : Colors.black,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          
          // Transactions List
          Expanded(
            child: _filteredTransactions.isEmpty
              ? Center(
                  child: Text(
                    'No transactions in this category',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: _filteredTransactions.length,
                  itemBuilder: (context, index) {
                    final transaction = _filteredTransactions[index];
                    return GestureDetector(
                      onTap: () => _showTransactionDetailsDialog(transaction),
                      child: Card(
                        elevation: 4,
                        margin: EdgeInsets.only(bottom: 16),
                        child: ListTile(
                          title: Text(
                            transaction['service'],
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${transaction['carModel']} (${transaction['numberPlate']})',
                                style: GoogleFonts.poppins(),
                              ),
                              Text(
                                '${transaction['date']} at ${transaction['time']}',
                                style: GoogleFonts.poppins(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'RM ${transaction['amount'].toStringAsFixed(2)}',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryBlue,
                                ),
                              ),
                              Text(
                                transaction['status'],
                                style: GoogleFonts.poppins(
                                  color: _getStatusColor(transaction['status']),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNavBar(initialIndex: widget.currentIndex),
    );
  }
}
