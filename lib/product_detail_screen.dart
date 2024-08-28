import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  final String productName;
  final int quantity;
  final String description;

  ProductDetailScreen({
    required this.productName,
    required this.quantity,
    required this.description,
  });

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
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border, color: Color(0xFFFFA547)),
            onPressed: () {
              // Handle favorite action
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Seller/Brand name
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                "Man Shoe’s",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),

            // Product name
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(
                productName,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),

            // Quantity and star icon
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Row(
                children: [
                  Icon(Icons.star, color: Color(0xFFFFA547)),
                  SizedBox(width: 8),
                  Text(
                    "Quantity - $quantity",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            ),

            // Description section
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(
                "Description",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Text(
                    description,
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),
              ),
            ),

            // Bottom button
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Handle removal from inventory
                  },
                  icon: Icon(Icons.delete_outline, size: 30),
                  label: Text("Remove from Inventory"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Color(0xFFFFA547),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    textStyle: TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
