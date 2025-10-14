import 'package:flutter/material.dart';
import '../navigation.dart';

class ItemsScreen extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onNavigationTap;

  const ItemsScreen({
    super.key,
    required this.currentIndex,
    required this.onNavigationTap,
  });

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;
  
  final List<String> _categories = [
    'All',
    'Snacks',
    'Noodles', 
    'Vegetables',
    'Fruits',
    'Breads',
  ];

  // Sample product data
  final List<Map<String, dynamic>> _allProducts = [
    {
      'id': 1,
      'name': 'Amul Masti Curd',
      'weight': '(400gm)',
      'price': 150,
      'image': 'assets/products/amul_curd.png',
      'category': 'Snacks',
    },
    {
      'id': 2,
      'name': 'Maggi Noodles',
      'weight': '1 Pcs',
      'price': 15,
      'image': 'assets/products/maggi.png',
      'category': 'Noodles',
    },
    {
      'id': 3,
      'name': 'Potato',
      'weight': '1 Kg',
      'price': 30,
      'image': 'assets/products/potato.png',
      'category': 'Vegetables',
    },
    {
      'id': 4,
      'name': 'Brown Bread',
      'weight': '1 Pcs',
      'price': 25,
      'image': 'assets/products/bread.png',
      'category': 'Breads',
    },
    {
      'id': 5,
      'name': 'Brinjal',
      'weight': '500gm',
      'price': 40,
      'image': 'assets/products/brinjal.png',
      'category': 'Vegetables',
    },
    {
      'id': 6,
      'name': 'Carrot',
      'weight': '1kg',
      'price': 50,
      'image': 'assets/products/carrot.png',
      'category': 'Vegetables',
    },
  ];

  List<Map<String, dynamic>> _filteredProducts = [];
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _filteredProducts = _allProducts;
    
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _selectedCategory = _categories[_tabController.index];
          _filterProducts();
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _filterProducts() {
    setState(() {
      if (_selectedCategory == 'All') {
        _filteredProducts = _allProducts;
      } else {
        _filteredProducts = _allProducts
            .where((product) => product['category'] == _selectedCategory)
            .toList();
      }
    });
  }

  void _searchProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        _filterProducts();
      } else {
        _filteredProducts = _allProducts
            .where((product) =>
                product['name'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                _buildSearchBar(),
              ],
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left sidebar with categories
                _buildCategorySidebar(),
                // Right side with products
                Expanded(
                  child: _buildProductsSection(),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: widget.currentIndex,
        onTap: widget.onNavigationTap,
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 50,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF5777B5),
            Color(0xFF26344F),
          ],
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF5777B5),
            Color(0xFF26344F),
          ],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          onChanged: _searchProducts,
          decoration: InputDecoration(
            hintText: 'Search Products',
            hintStyle: TextStyle(
              color: Colors.grey[400],
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.grey[400],
              size: 18,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySidebar() {
    return Container(
      width: 80,
      color: const Color(0xFFF5F5F5),
      padding: const EdgeInsets.all(6),
      child: SingleChildScrollView(
        child: Column(
          children: _categories.skip(1).map((category) {
            final isSelected = _selectedCategory == category;
            return Container(
              margin: const EdgeInsets.only(bottom: 5),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategory = category;
                    _filterProducts();
                  });
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF5777B5) : Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isSelected ? const Color(0xFF5777B5) : Colors.grey[200]!,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                      color: isSelected 
                          ? Colors.white
                          : const Color(0xFF374151),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildProductsSection() {
    return Container(
      color: const Color(0xFFF5F5F5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // "All" button and Add Product button
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = 'All';
                      _filterProducts();
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _selectedCategory == 'All' 
                          ? const Color(0xFF5777B5)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: _selectedCategory == 'All'
                            ? const Color(0xFF5777B5)
                            : Colors.grey[300]!,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'All',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: _selectedCategory == 'All'
                            ? Colors.white
                            : const Color(0xFF374151),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  height: 30,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add, size: 14, color: Colors.white),
                    label: const Text('Add Product', style: TextStyle(fontSize: 11, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF805D),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Products grid
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isSmallScreen = constraints.maxWidth < 400;
                final crossAxisCount = isSmallScreen ? 2 : 3;
                final childAspectRatio = isSmallScreen ? 0.85 : 0.9;
                
                return Padding(
                  padding: EdgeInsets.fromLTRB(
                    isSmallScreen ? 8 : 10, 
                    0, 
                    isSmallScreen ? 8 : 10, 
                    isSmallScreen ? 8 : 10
                  ),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: childAspectRatio,
                      crossAxisSpacing: isSmallScreen ? 6 : 8,
                      mainAxisSpacing: isSmallScreen ? 8 : 10,
                    ),
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = _filteredProducts[index];
                      return _buildProductCard(product, isSmallScreen);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product, [bool isSmallScreen = false]) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isSmallScreen ? 8 : 10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Expanded(
            flex: isSmallScreen ? 2 : 3,
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.all(isSmallScreen ? 4 : 6),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(isSmallScreen ? 4 : 6),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(isSmallScreen ? 4 : 6),
                child: Image.asset(
                  product['image'],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFFE8F5E8),
                            const Color(0xFFB8E6B8),
                          ],
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          _getProductIcon(product['image']),
                          size: isSmallScreen ? 16 : 20,
                          color: Colors.black54,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          
          // Product Details
          Expanded(
            flex: isSmallScreen ? 3 : 2,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                isSmallScreen ? 4 : 6, 
                0, 
                isSmallScreen ? 4 : 6, 
                isSmallScreen ? 4 : 6
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price
                  Text(
                    '₹${product['price']}',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 12 : 14,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF111827),
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 0.5 : 1),
                  
                  // Product Name
                  Expanded(
                    child: Text(
                      product['name'],
                      style: TextStyle(
                        fontSize: isSmallScreen ? 9 : 11,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF374151),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  
                  // Weight and Add Button Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          product['weight'],
                          style: TextStyle(
                            fontSize: isSmallScreen ? 8 : 9,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[500],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: isSmallScreen ? 4 : 6),
                      Container(
                        width: isSmallScreen ? 20 : 24,
                        height: isSmallScreen ? 20 : 24,
                        decoration: BoxDecoration(
                          color: const Color(0xFF5777B5),
                          borderRadius: BorderRadius.circular(isSmallScreen ? 4 : 6),
                        ),
                        child: IconButton(
                          onPressed: () {
                            _addToCart(product);
                          },
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: isSmallScreen ? 12 : 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getProductIcon(String imagePath) {
    if (imagePath.contains('curd') || imagePath.contains('amul')) {
      return Icons.local_drink;
    } else if (imagePath.contains('maggi') || imagePath.contains('noodles')) {
      return Icons.ramen_dining;
    } else if (imagePath.contains('potato') || imagePath.contains('brinjal') || imagePath.contains('carrot')) {
      return Icons.eco;
    } else if (imagePath.contains('bread')) {
      return Icons.bakery_dining;
    } else {
      return Icons.shopping_basket;
    }
  }

  void _addToCart(Map<String, dynamic> product) {
    // Show a snackbar for now
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product['name']} added to cart!'),
        backgroundColor: const Color(0xFF5777B5),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}