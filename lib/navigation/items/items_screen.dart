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
      'image': 'amul_curd',
      'category': 'Snacks',
    },
    {
      'id': 2,
      'name': 'Maggi Noodles',
      'weight': '1 Pcs',
      'price': 15,
      'image': 'maggi_noodles',
      'category': 'Noodles',
    },
    {
      'id': 3,
      'name': 'Potato',
      'weight': '1 Kg',
      'price': 30,
      'image': 'potato',
      'category': 'Vegetables',
    },
    {
      'id': 4,
      'name': 'Brown Bread',
      'weight': '1 Pcs',
      'price': 25,
      'image': 'brown_bread',
      'category': 'Breads',
    },
    {
      'id': 5,
      'name': 'Brinjal',
      'weight': '500gm',
      'price': 40,
      'image': 'brinjal',
      'category': 'Vegetables',
    },
    {
      'id': 6,
      'name': 'Carrot',
      'weight': '1kg/gm',
      'price': 50,
      'image': 'carrot',
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
          _buildHeader(),
          _buildSearchBar(),
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
      height: 60,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4A5C7A),
            Color(0xFF3B4A63),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Container(),
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
            Color(0xFF4A5C7A),
            Color(0xFF3B4A63),
          ],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
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
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.grey[400],
              size: 20,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySidebar() {
    return Container(
      width: 100,
      color: const Color(0xFFF5F5F5),
      padding: const EdgeInsets.all(12),
      child: SingleChildScrollView(
        child: Column(
          children: _categories.skip(1).map((category) {
            final isSelected = _selectedCategory == category;
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
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
                    horizontal: 8,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.grey[200]!,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: isSelected 
                          ? const Color(0xFFFF6B35)
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
          // "All" button
          Padding(
            padding: const EdgeInsets.all(16),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategory = 'All';
                  _filterProducts();
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: _selectedCategory == 'All' 
                      ? const Color(0xFFFF6B35)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _selectedCategory == 'All'
                        ? const Color(0xFFFF6B35)
                        : Colors.grey[300]!,
                    width: 1,
                  ),
                ),
                child: Text(
                  'All',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: _selectedCategory == 'All'
                        ? Colors.white
                        : const Color(0xFF374151),
                  ),
                ),
              ),
            ),
          ),
          
          // Products grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 16,
                ),
                itemCount: _filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = _filteredProducts[index];
                  return _buildProductCard(product);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _buildProductImage(product['image']),
              ),
            ),
          ),
          
          // Product Details
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price
                  Text(
                    '₹${product['price']}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 4),
                  
                  // Product Name
                  Text(
                    product['name'],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF374151),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  
                  // Weight
                  Text(
                    product['weight'],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[500],
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // Add Button
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF6B35),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: IconButton(
                        onPressed: () {
                          _addToCart(product);
                        },
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage(String imagePath) {
    // Create different colored containers for different products to simulate images
    final colors = [
      [const Color(0xFFE8F5E8), const Color(0xFFB8E6B8)], // Green for vegetables
      [const Color(0xFFFFF3E0), const Color(0xFFFFCC80)], // Orange for snacks
      [const Color(0xFFE3F2FD), const Color(0xFF90CAF9)], // Blue for others
      [const Color(0xFFFCE4EC), const Color(0xFFF48FB1)], // Pink for fruits
      [const Color(0xFFF3E5F5), const Color(0xFFCE93D8)], // Purple for breads
    ];
    
    final colorIndex = imagePath.hashCode % colors.length;
    final selectedColors = colors[colorIndex];
    
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: selectedColors,
        ),
      ),
      child: Center(
        child: Icon(
          _getProductIcon(imagePath),
          size: 32,
          color: Colors.black54,
        ),
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
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}