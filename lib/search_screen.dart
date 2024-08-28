import 'package:flutter/material.dart';
import 'barcode_scanner_screen.dart';
import 'home.dart';


class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  int _selectedIndex = 1; // Set the initial selected index to 1 to indicate the Search tab

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BarcodeScreen()),  // Navigate to BarcodeScreen
      );
    } else if (index == 3) {
      // Handle Profile navigation (You can add your Profile screen here)
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
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
          'Search',
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
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          children: [
            // Search Field
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Biscuits', // Placeholder text
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                  Icon(Icons.tune, color: Color(0xFFFFA547)), // Filter icon with brand color
                ],
              ),
            ),
            // Add more UI elements here if needed
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
