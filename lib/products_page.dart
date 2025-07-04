import 'package:flutter/material.dart';
import 'ManageVehicle.dart';
import 'package:shimmer/shimmer.dart';
import 'qr_scanner.dart';
import 'bottomNavbar.dart';
import 'ManageVehicle.dart';
import 'carWashDetails.dart';

void main() => runApp(ProductsPage());

class ProductsPage extends StatefulWidget {
  final int currentIndex;

  const ProductsPage({super.key, this.currentIndex = 0});

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.grey[50],
      ),
      home: Scaffold(
        body: SafeArea(
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BannerSection(),
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            children: [
                              SizedBox(height: 20),
                              CategoriesTab(),
                              SizedBox(height: 20),
                              ProductGrid(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                AppBottomNavBar(initialIndex: widget.currentIndex)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BannerSection extends StatefulWidget {
  const BannerSection({super.key});

  @override
  State<BannerSection> createState() => _BannerSectionState();
}

class _BannerSectionState extends State<BannerSection> {
  final List<String> bannerImages = [
    'images/banner1.png',
    'images/banner3.jpeg',
    'images/banner4.jpeg',
  ];
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Auto-scroll banner
    Future.delayed(Duration(seconds: 1), () {
      _autoScroll();
    });
  }

  void _autoScroll() {
    Future.delayed(Duration(seconds: 5), () {
      if (_pageController.hasClients) {
        if (_currentIndex == bannerImages.length - 1) {
          _pageController.animateToPage(
            0,
            duration: Duration(milliseconds: 800),
            curve: Curves.fastOutSlowIn,
          );
        } else {
          _pageController.nextPage(
            duration: Duration(milliseconds: 800),
            curve: Curves.fastOutSlowIn,
          );
        }
        _autoScroll();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            itemCount: bannerImages.length,
            itemBuilder: (context, index) {
              return Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(bannerImages[index]),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: bannerImages.asMap().entries.map((entry) {
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(
                      _currentIndex == entry.key ? 0.9 : 0.4,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoriesTab extends StatelessWidget {
  const CategoriesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        children: [
          CategoryItem(title: "Car Wash", isSelected: true),
          CategoryItem(title: "Mirror"),
          CategoryItem(title: "Seat"),
          CategoryItem(title: "Engine"),
          CategoryItem(title: "Service"),
        ],
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String title;
  final bool isSelected;

  const CategoryItem({super.key, required this.title, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(25),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? Colors.green : Colors.transparent,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: isSelected ? Colors.green : Colors.grey[300]!,
              ),
            ),
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProductGrid extends StatefulWidget {
  const ProductGrid({super.key});

  @override
  State<ProductGrid> createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  final List<Map<String, dynamic>> _products = [
    {
      'name': 'Basic Wash',
      'description': 'Quick exterior cleaning for your vehicle',
      'category': 'carwash',
      'actualPrice': 25.0,
      'discountedPrice': 20.0,
    },
    {
      'name': 'Premium Wash',
      'description': 'Complete exterior and interior detailing',
      'category': 'carwash',
      'actualPrice': 50.0,
      'discountedPrice': 40.0,
    },
    {
      'name': 'Interior Detailing',
      'description': 'Deep cleaning of car interior',
      'category': 'detailing',
      'actualPrice': 75.0,
      'discountedPrice': 60.0,
    },
    {
      'name': 'Full Polish',
      'description': 'Professional car polishing service',
      'category': 'polish',
      'actualPrice': 100.0,
      'discountedPrice': 80.0,
    },
  ];

  List<Map<String, dynamic>> _filteredProducts = [];
  String _searchQuery = '';
  int _priceFilterState = 0; // 0: default, 1: low to high, 2: high to low
  int _nameFilterState = 0; // 0: default, 1: A to Z, 2: Z to A

  @override
  void initState() {
    super.initState();
    _filteredProducts = _products;
  }

  void _applyFilters() {
    setState(() {
      // First, filter by search query
      _filteredProducts = _products.where((product) {
        return product['name']
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            product['description']
                .toLowerCase()
                .contains(_searchQuery.toLowerCase());
      }).toList();

      // Apply price filter
      if (_priceFilterState == 1) {
        // Low to High
        _filteredProducts.sort(
            (a, b) => a['discountedPrice'].compareTo(b['discountedPrice']));
      } else if (_priceFilterState == 2) {
        // High to Low
        _filteredProducts.sort(
            (a, b) => b['discountedPrice'].compareTo(a['discountedPrice']));
      }

      // Apply name filter
      if (_nameFilterState == 1) {
        // A to Z
        _filteredProducts.sort((a, b) => a['name'].compareTo(b['name']));
      } else if (_nameFilterState == 2) {
        // Z to A
        _filteredProducts.sort((a, b) => b['name'].compareTo(a['name']));
      }
    });
  }

  Widget _buildFilterButton({
    required IconData icon,
    required VoidCallback onPressed,
    required int filterState,
    Widget? additionalChild,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: filterState > 0 ? Colors.green.shade100 : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color: filterState > 0 ? Colors.green : Colors.grey.shade300),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          IconButton(
            icon:
                Icon(icon, color: filterState > 0 ? Colors.green : Colors.grey),
            onPressed: onPressed,
          ),
          if (additionalChild != null) additionalChild,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Filter Row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (value) {
                    _searchQuery = value;
                    _applyFilters();
                  },
                ),
              ),
              SizedBox(width: 10),
              // Price Filter Button
              _buildFilterButton(
                icon: Icons.attach_money,
                onPressed: () {
                  setState(() {
                    _priceFilterState = (_priceFilterState + 1) % 3;
                    _nameFilterState = 0; // Reset name filter
                    _applyFilters();
                  });
                },
                filterState: _priceFilterState,
                additionalChild: _priceFilterState > 0
                    ? Positioned(
                        top: 0,
                        right: 0,
                        child: Icon(
                            _priceFilterState == 1
                                ? Icons.arrow_upward
                                : Icons.arrow_downward,
                            size: 12,
                            color: Colors.green),
                      )
                    : null,
              ),
              SizedBox(width: 10),
              // Name Filter Button
              _buildFilterButton(
                icon: Icons.sort_by_alpha,
                onPressed: () {
                  setState(() {
                    _nameFilterState = (_nameFilterState + 1) % 3;
                    _priceFilterState = 0; // Reset price filter
                    _applyFilters();
                  });
                },
                filterState: _nameFilterState,
              ),
            ],
          ),
        ),

        // Product Grid
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.7,
          ),
          itemCount: _filteredProducts.length,
          itemBuilder: (context, index) {
            final product = _filteredProducts[index];
            return ProductItem(
              name: product['name'],
              description: product['description'],
              actualPrice: product['actualPrice'],
              discountedPrice: product['discountedPrice'],
              image: _getImageForCategory(product['category']),
            );
          },
        ),

        // No results handling
        if (_filteredProducts.isEmpty)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'No products found',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
      ],
    );
  }

  String _getImageForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'carwash':
        return 'images/product1.jpg';
      case 'mirror':
        return 'images/product2.jpg';
      default:
        return 'images/product3.jpg';
    }
  }
}

class ProductItem extends StatelessWidget {
  final String name;
  final String description;
  final double actualPrice;
  final double discountedPrice;
  final String image;

  const ProductItem({
    super.key,
    required this.name,
    required this.description,
    required this.actualPrice,
    required this.discountedPrice,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    final int discountPercentage =
        ((actualPrice - discountedPrice) / actualPrice * 100).round();

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CarWashDetails(
              productName: name,
              productDescription: description,
              productPrice: discountedPrice,
              productImage: image,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                  child: Image.asset(
                    image,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$discountPercentage% OFF',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '\$${discountedPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFbe1e2d),
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        '\$${actualPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
