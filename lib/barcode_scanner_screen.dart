import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';  // To format the expiry date

import 'package:peams/search_screen.dart';
import 'home.dart';

class BarcodeScreen extends StatefulWidget {
  @override
  _BarcodeScreenState createState() => _BarcodeScreenState();
}

class _BarcodeScreenState extends State<BarcodeScreen> {
  int _selectedIndex = 2; // Set the initial selected index to 2 to indicate the Barcode tab
  String _scanResult = "";

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SearchScreen()),
      );
    } else if (index == 3) {
      // Handle Profile navigation (You can add your Profile screen here)
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  Future<void> _startBarcodeScan() async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Cancel", true, ScanMode.BARCODE);

    if (barcodeScanRes == "-1") {
      _showFailurePopup("Failed to scan");
    } else {
      setState(() {
        _scanResult = barcodeScanRes;
      });

      // Debug: Print the scanned barcode result
      print('Scanned barcode: $_scanResult');

      // Extract name and expiry date from the scanned barcode result
      String? name = extractNameAndExpiryDate(_scanResult)['name'];
      String? expiryDate = extractNameAndExpiryDate(_scanResult)['expiry_date'];

      // Debug: Print extracted values
      print('Extracted Name: $name');
      print('Extracted Expiry Date: $expiryDate');

      // Send data to the Flask backend if the data is not null
      if (name != null && expiryDate != null) {
        await sendProductData(context, name, expiryDate);
      } else {
        _showFailurePopup("Failed to extract data from barcode");
      }
    }
  }

  Map<String, String?> extractNameAndExpiryDate(String barcodeData) {
    // Split the barcode data on the first comma
    List<String> parts = barcodeData.split(',');
    if (parts.length == 2) {
      String name = parts[0].trim();
      String expiryDate = parts[1].trim();

      // Format the expiry date to match the desired format
      DateTime date = DateTime.parse(expiryDate);
      String formattedExpiryDate = DateFormat('EEE, dd MMM yyyy HH:mm:ss').format(date) + ' GMT';

      return {'name': name, 'expiry_date': formattedExpiryDate};
    } else {
      return {'name': null, 'expiry_date': null};
    }
  }

  Future<void> sendProductData(BuildContext context, String name, String expiryDate) async {
    final url = 'http://192.168.0.140:5000/add_product'; // Replace with your actual Flask backend IP address

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"name": name, "expiry_date": expiryDate}),
      );

      if (response.statusCode == 201) {
        _showSuccessPopup("Product added successfully");
      } else {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
        _showFailurePopup("Failed to add product");
      }
    } catch (error) {
      print('Error: $error');
      _showFailurePopup("An error occurred: $error");
    }
  }

  void _showSuccessPopup(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Success"),
          content: Text(message),
          actions: [
            TextButton(
              child: Text("OK", style: TextStyle(color: Color(0xFFFFA547))),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showFailurePopup(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              child: Text("OK", style: TextStyle(color: Color(0xFFFFA547))),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startBarcodeScan());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Add to Inventory',
          style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none, color: Color(0xFF8B635C)),
            onPressed: () {
              // Handle notifications action
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(
                'Total Items: 5835',  // Placeholder for total items
                style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Center( // Center the button within the available space
                child: ElevatedButton.icon(
                  onPressed: _startBarcodeScan,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Color(0xFFFFA547), // Text color
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  icon: Icon(Icons.qr_code_scanner), // Add an icon to the button
                  label: Text('Scan Another Barcode'),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        //backgroundColor: Color(0xFF8B635C), // Brand color for the background
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,  // Show label text when active
        showUnselectedLabels: false, // Hide label text when inactive
        items: [
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.home, 0),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.search, 1),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.qr_code_scanner, 2),
            label: 'Barcode',  // Updated label to Barcode
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.person_outline, 3),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(IconData iconData, int index) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: _selectedIndex == index ? Color(0xFFFFA547) : Colors.transparent, // Active icon background color
        borderRadius: BorderRadius.circular(15),
      ),
      child: Icon(
        iconData,
        color: _selectedIndex == index ? Colors.white : Colors.grey, // Icon color change based on active/inactive state
      ),
    );
  }
}
