// import 'package:flutter/material.dart';
// import 'barcode_scanner_screen.dart';
// import 'product_detail_screen.dart';
// import 'search_screen.dart';
// import 'barcode_scanner_screen.dart'; // Import the barcode screen
//
// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   int _selectedIndex = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
//
//   void _onItemTapped(int index) {
//     if (index == 1) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => SearchScreen()),
//       );
//     } else if (index == 2) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => BarcodeScreen()), // Navigate to barcode screen
//       );
//     } else {
//       setState(() {
//         _selectedIndex = index;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         title: Text('Explore', style: TextStyle(color: Color(0xFF8B635C))),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.notifications_none, color: Color(0xFF8B635C)),
//             onPressed: () {
//               // Handle notifications action
//             },
//           ),
//         ],
//       ),
//       body: IndexedStack(
//         index: _selectedIndex,
//         children: [
//           // Home tab content
//           Column(
//             children: [
//               TabBar(
//                 controller: _tabController,
//                 labelColor: Color(0xFF8B635C),
//                 unselectedLabelColor: Colors.grey,
//                 indicatorColor: Color(0xFFFFA547),
//                 tabs: [
//                   Tab(text: "Due Expiry"),
//                   Tab(text: "Later Days"),
//                   Tab(text: "New Addons"),
//                 ],
//               ),
//               Expanded(
//                 child: TabBarView(
//                   controller: _tabController,
//                   children: [
//                     // Due Expiry tab content
//                     ListView.builder(
//                       padding: EdgeInsets.all(10.0),
//                       itemCount: 10, // Adjust as necessary
//                       itemBuilder: (context, index) {
//                         String productName = index % 2 == 0 ? "Biscuits" : "Tomatoes";
//                         int quantity = index % 2 == 0 ? 20 : 50;
//                         String description = "Perishable goods";
//
//                         return GestureDetector(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => ProductDetailScreen(
//                                   productName: productName,
//                                   quantity: quantity,
//                                   description: description,
//                                 ),
//                               ),
//                             );
//                           },
//                           child: Card(
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10.0),
//                             ),
//                             elevation: 2,
//                             margin: EdgeInsets.symmetric(vertical: 8.0),
//                             child: Padding(
//                               padding: const EdgeInsets.all(15.0),
//                               child: Row(
//                                 children: [
//                                   Expanded(
//                                     child: Text(
//                                       productName,
//                                       style: TextStyle(fontSize: 16),
//                                     ),
//                                   ),
//                                   IconButton(
//                                     icon: Icon(Icons.favorite_border),
//                                     onPressed: () {
//                                       // Handle favorite action
//                                     },
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                     // Later Days tab content (Placeholder for now)
//                     Center(child: Text('Later Days Content')),
//                     // New Addons tab content (Placeholder for now)
//                     Center(child: Text('New Addons Content')),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           // Barcode tab placeholder
//           Center(child: Text('Barcode Placeholder Content')),
//           // Profile tab placeholder
//           Center(child: Text('Profile Placeholder Content')),
//         ],
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         //backgroundColor: Color(0xFF8B635C), // Brand color for the background
//         selectedItemColor: Colors.white,
//         unselectedItemColor: Colors.grey,
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//         type: BottomNavigationBarType.fixed,
//         showSelectedLabels: true,  // Show label text when active
//         showUnselectedLabels: false, // Hide label text when inactive
//         items: [
//           BottomNavigationBarItem(
//             icon: _buildIcon(Icons.home, 0),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: _buildIcon(Icons.search, 1),
//             label: 'Search',
//           ),
//           BottomNavigationBarItem(
//             icon: _buildIcon(Icons.qr_code, 2),
//             label: 'Barcode', // Updated label to Barcode
//           ),
//           BottomNavigationBarItem(
//             icon: _buildIcon(Icons.person_outline, 3),
//             label: 'Profile',
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildIcon(IconData iconData, int index) {
//     return Container(
//       padding: EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: _selectedIndex == index ? Color(0xFFFFA547) : Colors.transparent, // Active icon background color
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Icon(
//         iconData,
//         color: _selectedIndex == index ? Colors.white : Colors.grey, // Icon color change based on active/inactive state
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'barcode_scanner_screen.dart';
import 'product_detail_screen.dart';
import 'search_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  List<Map<String, dynamic>> dueExpiryProducts = [];
  List<Map<String, dynamic>> laterDaysProducts = [];
  List<Map<String, dynamic>> newAddonsProducts = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchProducts();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchProducts() async {
    final url = 'http://192.168.0.140:5000/get_products'; // Replace with your actual Flask backend IP address

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List<dynamic> products = jsonDecode(response.body);
        DateTime now = DateTime.now();
        DateTime today = DateTime(now.year, now.month, now.day);

        for (var product in products) {
          String name = product['name'];
          DateTime expiryDate = DateFormat('EEE, dd MMM yyyy HH:mm:ss').parse(product['expiry_date']);

          if (expiryDate.isBefore(today.add(Duration(days: 1)))) {
            dueExpiryProducts.add({"name": name, "expiry_date": product['expiry_date']});
          } else if (expiryDate.isBefore(today.add(Duration(days: 8)))) {
            laterDaysProducts.add({"name": name, "expiry_date": product['expiry_date']});
          } else {
            newAddonsProducts.add({"name": name, "expiry_date": product['expiry_date']});
          }
        }

        setState(() {}); // Update the UI after fetching and categorizing the products
      } else {
        print('Failed to load products');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SearchScreen()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BarcodeScreen()), // Navigate to barcode screen
      );
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
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text('Explore', style: TextStyle(color: Color(0xFF8B635C))),
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
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          // Home tab content
          Column(
            children: [
              TabBar(
                controller: _tabController,
                labelColor: Color(0xFF8B635C),
                unselectedLabelColor: Colors.grey,
                indicatorColor: Color(0xFFFFA547),
                tabs: [
                  Tab(text: "Due Expiry"),
                  Tab(text: "Later Days"),
                  Tab(text: "New Addons"),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Due Expiry tab content
                    _buildProductList(dueExpiryProducts),
                    // Later Days tab content
                    _buildProductList(laterDaysProducts),
                    // New Addons tab content
                    _buildProductList(newAddonsProducts),
                  ],
                ),
              ),
            ],
          ),
          // Barcode tab placeholder
          Center(child: Text('Barcode Placeholder Content')),
          // Profile tab placeholder
          Center(child: Text('Profile Placeholder Content')),
        ],
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
            icon: _buildIcon(Icons.qr_code, 2),
            label: 'Barcode', // Updated label to Barcode
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.person_outline, 3),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildProductList(List<Map<String, dynamic>> products) {
    return ListView.builder(
      padding: EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder: (context, index) {
        String productName = products[index]['name'];
        String expiryDate = products[index]['expiry_date'];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailScreen(
                  productName: productName,
                  quantity: 0, // You can add more details as needed
                  description: 'Perishable goods',
                ),
              ),
            );
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 2,
            margin: EdgeInsets.symmetric(vertical: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productName,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Expiry Date: $expiryDate",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
