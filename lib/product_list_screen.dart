import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'product_detail_screen.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List products = [];
  final TextEditingController _searchController = TextEditingController();
  String selectedCategory = 'All';
  bool isDarkMode = false;

  List<Map<String, dynamic>> categories = [
    {'name': 'All', 'icon': Icons.apps},
    {'name': 'Smartphones', 'icon': Icons.phone_android},
    {'name': 'Laptops', 'icon': Icons.laptop},
    {'name': 'Home Appliances', 'icon': Icons.kitchen},
    {'name': 'Fashion', 'icon': Icons.checkroom},
    {'name': 'Shoes', 'icon': Icons.shopping_bag},
    {'name': 'Watches', 'icon': Icons.watch},
    {'name': 'Jewelry', 'icon': Icons.diamond},
    {'name': 'Beauty & Skincare', 'icon': Icons.face},
    {'name': 'Groceries', 'icon': Icons.shopping_cart},
    {'name': 'Sports', 'icon': Icons.sports_soccer},
    {'name': 'Electronics', 'icon': Icons.devices},
  ];

  int categoryOffset = 0;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts({String? searchQuery, String? category}) async {
    String url;
    if (searchQuery != null && searchQuery.isNotEmpty) {
      url = 'https://dummyjson.com/products/search?q=$searchQuery';
    } else if (category != null && category != 'All') {
      url = 'https://dummyjson.com/products/category/$category';
    } else {
      url = 'https://dummyjson.com/products';
    }

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      setState(() {
        var data = jsonDecode(response.body);
        products = data['products'] ?? [];
      });
    }
  }

  void _onCategorySelected(String category) {
    setState(() {
      selectedCategory = category;
    });
    fetchProducts(category: category);
  }

  void _toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  void _moveCategoryLeft() {
    setState(() {
      if (categoryOffset > 0) {
        categoryOffset--;
      }
    });
  }

  void _moveCategoryRight() {
    setState(() {
      if (categoryOffset < categories.length - 4) {
        categoryOffset++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: Column(
            children: [
              Text(
                'أهلا بكم في متجر',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'Ghazal',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          centerTitle: true,
          backgroundColor: Color(0xFF8B4513),
          actions: [],
        ),
        body: Column(
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/123.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'ابحث عن منتج...',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () => fetchProducts(searchQuery: _searchController.text),
                        ),
                      ),
                      onSubmitted: (value) => fetchProducts(searchQuery: value),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isDarkMode ? Icons.nightlight_round : Icons.wb_sunny,
                      color: Color(0xFF8B4513),
                    ),
                    onPressed: _toggleTheme,
                  ),
                ],
              ),
            ),
            Container(
              height: 80,
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_left, color: Color(0xFF8B4513)),
                    onPressed: _moveCategoryLeft,
                  ),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      controller: ScrollController(),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        if (index < categoryOffset || index >= categoryOffset + 4) {
                          return Container();
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ChoiceChip(
                            label: Row(
                              children: [
                                Icon(categories[index]['icon'], color: Color(0xFF8B4513)),
                                SizedBox(width: 6),
                                Text(categories[index]['name']),
                              ],
                            ),
                            selected: selectedCategory == categories[index]['name'],
                            onSelected: (bool selected) {
                              setState(() {
                                selectedCategory = categories[index]['name'];
                              });
                              fetchProducts(category: categories[index]['name']);
                            },
                            selectedColor: Color(0xFF8B4513),
                            backgroundColor: Colors.grey[300],
                          ),
                        );
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_right, color: Color(0xFF8B4513)),
                    onPressed: _moveCategoryRight,
                  ),
                ],
              ),
            ),
            Expanded(
              child: products.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : GridView.builder(
                padding: EdgeInsets.all(12),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.8,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  var product = products[index];
                  return GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailScreen(product: product),
                      ),
                    ),
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                              child: Image.network(
                                product['thumbnail'],
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  product['title'],
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '\$${product['price']}',
                                  style: TextStyle(color: Color(0xFF8B4513)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
