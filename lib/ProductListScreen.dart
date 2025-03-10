import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  final Map product;

  ProductDetailScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product['title'])),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Image.network(product['thumbnail'], height: 200)),
            SizedBox(height: 16),
            Text(product['title'], style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('\$${product['price']}', style: TextStyle(fontSize: 18, color: Colors.green)),
            SizedBox(height: 8),
            Text(product['description']),
          ],
        ),
      ),
    );
  }
}
