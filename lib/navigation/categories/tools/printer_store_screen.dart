import 'package:flutter/material.dart';
import '../../../widgets/responsive_dialog.dart';

class PrinterStoreScreen extends StatefulWidget {
  const PrinterStoreScreen({super.key});

  @override
  State<PrinterStoreScreen> createState() => _PrinterStoreScreenState();
}

class _PrinterStoreScreenState extends State<PrinterStoreScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  String _selectedCategory = 'All Products';
  String _selectedBrand = 'All Brands';
  String _selectedPriceRange = 'All Prices';
  
  final List<String> _categories = [
    'All Products',
    'Thermal Printers',
    'Inkjet Printers',
    'Label Printers',
    'POS Printers',
    'Mobile Printers',
    'Accessories',
  ];
  
  final List<String> _brands = [
    'All Brands',
    'HP',
    'Canon',
    'Epson',
    'TVS Electronics',
    'WeP',
    'Zebra',
    'Star Micronics',
  ];
  
  final List<String> _priceRanges = [
    'All Prices',
    'Under ₹5,000',
    '₹5,000 - ₹15,000',
    '₹15,000 - ₹30,000',
    '₹30,000 - ₹50,000',
    'Above ₹50,000',
  ];

  final List<Map<String, dynamic>> _allProducts = [
    {
      'id': 1,
      'name': 'TVS Electronics LP 45 Barcode',
      'brand': 'TVS Electronics',
      'category': 'Label Printers',
      'price': 8500,
      'originalPrice': 9500,
      'rating': 4.3,
      'reviews': 245,
      'image': 'assets/printer1.jpg',
      'features': ['USB Connectivity', 'Thermal Printing', 'High Speed'],
      'inStock': true,
      'description': 'High-quality thermal label printer perfect for small businesses.',
    },
    {
      'id': 2,
      'name': 'HP DeskJet 2723 All-in-One',
      'brand': 'HP',
      'category': 'Inkjet Printers',
      'price': 6500,
      'originalPrice': 7500,
      'rating': 4.1,
      'reviews': 567,
      'image': 'assets/printer2.jpg',
      'features': ['Wireless Printing', 'Mobile Print', 'Scan & Copy'],
      'inStock': true,
      'description': 'Versatile all-in-one printer with wireless connectivity.',
    },
    {
      'id': 3,
      'name': 'Epson TM-T82III POS Printer',
      'brand': 'Epson',
      'category': 'POS Printers',
      'price': 12500,
      'originalPrice': 14000,
      'rating': 4.6,
      'reviews': 189,
      'image': 'assets/printer3.jpg',
      'features': ['Auto-cutter', 'USB & Ethernet', 'Fast Printing'],
      'inStock': true,
      'description': 'Professional POS thermal printer for retail businesses.',
    },
    {
      'id': 4,
      'name': 'Canon PIXMA G3000',
      'brand': 'Canon',
      'category': 'Inkjet Printers',
      'price': 14500,
      'originalPrice': 16000,
      'rating': 4.4,
      'reviews': 423,
      'image': 'assets/printer4.jpg',
      'features': ['Refillable Ink Tank', 'Wi-Fi Direct', 'Borderless Print'],
      'inStock': false,
      'description': 'High-yield ink tank printer for home and office use.',
    },
    {
      'id': 5,
      'name': 'WeP BP Joy Thermal Printer',
      'brand': 'WeP',
      'category': 'Thermal Printers',
      'price': 5500,
      'originalPrice': 6500,
      'rating': 4.0,
      'reviews': 156,
      'image': 'assets/printer5.jpg',
      'features': ['Compact Design', 'USB Interface', 'Energy Efficient'],
      'inStock': true,
      'description': 'Compact thermal printer ideal for small businesses.',
    },
    {
      'id': 6,
      'name': 'Star TSP143IIIW Wireless',
      'brand': 'Star Micronics',
      'category': 'POS Printers',
      'price': 18500,
      'originalPrice': 20000,
      'rating': 4.7,
      'reviews': 78,
      'image': 'assets/printer6.jpg',
      'features': ['Wireless', 'Cloud Ready', 'Auto-cutter'],
      'inStock': true,
      'description': 'Advanced wireless POS printer with cloud connectivity.',
    },
  ];

  List<Map<String, dynamic>> get _filteredProducts {
    return _allProducts.where((product) {
      // Category filter
      if (_selectedCategory != 'All Products' && product['category'] != _selectedCategory) {
        return false;
      }
      
      // Brand filter
      if (_selectedBrand != 'All Brands' && product['brand'] != _selectedBrand) {
        return false;
      }
      
      // Price range filter
      if (_selectedPriceRange != 'All Prices') {
        final price = product['price'];
        switch (_selectedPriceRange) {
          case 'Under ₹5,000':
            if (price >= 5000) return false;
            break;
          case '₹5,000 - ₹15,000':
            if (price < 5000 || price > 15000) return false;
            break;
          case '₹15,000 - ₹30,000':
            if (price < 15000 || price > 30000) return false;
            break;
          case '₹30,000 - ₹50,000':
            if (price < 30000 || price > 50000) return false;
            break;
          case 'Above ₹50,000':
            if (price <= 50000) return false;
            break;
        }
      }
      
      // Search filter
      if (_searchController.text.isNotEmpty) {
        final searchTerm = _searchController.text.toLowerCase();
        return product['name'].toLowerCase().contains(searchTerm) ||
               product['brand'].toLowerCase().contains(searchTerm) ||
               product['category'].toLowerCase().contains(searchTerm);
      }
      
      return true;
    }).toList();
  }

  void _showProductDetails(Map<String, dynamic> product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                height: 4,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Image
                      Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.print,
                          size: 80,
                          color: Color(0xFF5777B5),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Product Name and Rating
                      Text(
                        product['name'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF26344F),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Row(
                            children: List.generate(5, (index) {
                              return Icon(
                                index < product['rating'].floor()
                                    ? Icons.star
                                    : Icons.star_border,
                                color: const Color(0xFFFFB800),
                                size: 16,
                              );
                            }),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${product['rating']} (${product['reviews']} reviews)',
                              style: const TextStyle(color: Color(0xFF6B7280)),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Price
                      Row(
                        children: [
                          Text(
                            '₹${product['price'].toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFF805D),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '₹${product['originalPrice'].toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                            style: const TextStyle(
                              fontSize: 16,
                              decoration: TextDecoration.lineThrough,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${((product['originalPrice'] - product['price']) / product['originalPrice'] * 100).round()}% OFF',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF10B981),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Stock Status
                      Row(
                        children: [
                          Icon(
                            product['inStock'] ? Icons.check_circle : Icons.cancel,
                            color: product['inStock'] ? const Color(0xFF10B981) : const Color(0xFFE91E63),
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            product['inStock'] ? 'In Stock' : 'Out of Stock',
                            style: TextStyle(
                              color: product['inStock'] ? const Color(0xFF10B981) : const Color(0xFFE91E63),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      
                      // Description
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF26344F),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        product['description'],
                        style: const TextStyle(
                          color: Color(0xFF6B7280),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Features
                      const Text(
                        'Key Features',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF26344F),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...product['features'].map<Widget>((feature) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            const Icon(Icons.check, color: Color(0xFF10B981), size: 16),
                            const SizedBox(width: 8),
                            Text(feature, style: const TextStyle(color: Color(0xFF6B7280))),
                          ],
                        ),
                      )).toList(),
                      const SizedBox(height: 30),
                      
                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: product['inStock'] ? () {
                                Navigator.pop(context);
                                _addToCart(product);
                              } : null,
                              icon: const Icon(Icons.shopping_cart),
                              label: const Text('Add to Cart'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF5777B5),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: product['inStock'] ? () {
                                Navigator.pop(context);
                                _buyNow(product);
                              } : null,
                              icon: const Icon(Icons.flash_on),
                              label: const Text('Buy Now'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF805D),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
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
        ),
      ),
    );
  }

  void _addToCart(Map<String, dynamic> product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product['name']} added to cart!'),
        backgroundColor: const Color(0xFF10B981),
        action: SnackBarAction(
          label: 'VIEW CART',
          textColor: Colors.white,
          onPressed: () {
            // Navigate to cart
          },
        ),
      ),
    );
  }

  void _buyNow(Map<String, dynamic> product) {
    showResponsiveDialog(
      context: context,
      child: ResponsiveDialog(
        title: 'Confirm Purchase',
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.shopping_cart,
              size: 48,
              color: const Color(0xFF5777B5),
            ),
            const SizedBox(height: 16),
            Text(
              'Proceed to buy ${product['name']} for ₹${product['price']}?',
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF26344F),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          ResponsiveDialogButton(
            text: 'Cancel',
            onPressed: () => Navigator.pop(context),
            icon: Icons.close,
          ),
          ResponsiveDialogButton(
            text: 'Confirm',
            isPrimary: true,
            icon: Icons.payment,
            color: const Color(0xFFFF805D),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Redirecting to payment...'),
                  backgroundColor: Color(0xFF5777B5),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isSmallScreen = constraints.maxWidth < 400;
          
          return SafeArea(
            child: Column(
              children: [
                _buildHeader(isSmallScreen),
                _buildSearchAndFilters(isSmallScreen),
                Expanded(
                  child: _buildProductGrid(isSmallScreen),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(bool isSmallScreen) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF5777B5), Color(0xFF26344F)],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            isSmallScreen ? 16 : 20,
            isSmallScreen ? 12 : 18,
            isSmallScreen ? 16 : 20,
            isSmallScreen ? 16 : 24,
          ),
          child: Row(
            children: [
              SizedBox(width: isSmallScreen ? 6 : 8),
              Expanded(
                child: Text(
                  'Printer Store',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 16.0 : 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.2,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Shopping Cart'),
                      backgroundColor: Color(0xFF5777B5),
                    ),
                  );
                },
                icon: Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                  size: isSmallScreen ? 20 : 24,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchAndFilters(bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      child: Column(
        children: [
          // Search Bar
          TextField(
            controller: _searchController,
            style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
            decoration: InputDecoration(
              hintText: 'Search printers...',
              hintStyle: TextStyle(fontSize: isSmallScreen ? 14 : 16),
              prefixIcon: Icon(
                Icons.search,
                size: isSmallScreen ? 20 : 24,
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                        });
                      },
                      icon: const Icon(Icons.clear),
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            onChanged: (value) => setState(() {}),
          ),
          const SizedBox(height: 12),
          
          // Filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterDropdown('Category', _selectedCategory, _categories, (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                }),
                const SizedBox(width: 8),
                _buildFilterDropdown('Brand', _selectedBrand, _brands, (value) {
                  setState(() {
                    _selectedBrand = value;
                  });
                }),
                const SizedBox(width: 8),
                _buildFilterDropdown('Price', _selectedPriceRange, _priceRanges, (value) {
                  setState(() {
                    _selectedPriceRange = value;
                  });
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown(String label, String value, List<String> items, Function(String) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          items: items.map((item) {
            return DropdownMenuItem(value: item, child: Text(item, style: const TextStyle(fontSize: 12)));
          }).toList(),
          onChanged: (newValue) => onChanged(newValue!),
          icon: const Icon(Icons.keyboard_arrow_down, size: 16),
          style: const TextStyle(color: Color(0xFF26344F), fontSize: 12),
        ),
      ),
    );
  }

  Widget _buildProductGrid(bool isSmallScreen) {
    final products = _filteredProducts;
    
    if (products.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Color(0xFF6B7280)),
            SizedBox(height: 16),
            Text(
              'No products found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFF6B7280),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Try adjusting your filters',
              style: TextStyle(color: Color(0xFF9CA3AF)),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isSmallScreen ? 2 : 3,
        childAspectRatio: isSmallScreen ? 0.7 : 0.75,
        crossAxisSpacing: isSmallScreen ? 8 : 12,
        mainAxisSpacing: isSmallScreen ? 8 : 12,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return _buildProductCard(product, isSmallScreen);
      },
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product, bool isSmallScreen) {
    return GestureDetector(
      onTap: () => _showProductDetails(product),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(isSmallScreen ? 8 : 12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
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
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: const Center(
                  child: Icon(
                    Icons.print,
                    size: 48,
                    color: Color(0xFF5777B5),
                  ),
                ),
              ),
            ),
            
            // Product Details
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(isSmallScreen ? 8 : 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['name'],
                      style: TextStyle(
                        fontSize: isSmallScreen ? 12 : 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF26344F),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: isSmallScreen ? 2 : 4),
                    
                    Row(
                      children: [
                        Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              index < product['rating'].floor()
                                  ? Icons.star
                                  : Icons.star_border,
                              color: const Color(0xFFFFB800),
                              size: 12,
                            );
                          }),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${product['reviews']})',
                          style: const TextStyle(
                            color: Color(0xFF6B7280),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    
                    Row(
                      children: [
                        Text(
                          '₹${product['price'].toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF805D),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '₹${product['originalPrice']}',
                          style: const TextStyle(
                            fontSize: 12,
                            decoration: TextDecoration.lineThrough,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                    
                    Row(
                      children: [
                        Icon(
                          product['inStock'] ? Icons.check_circle : Icons.cancel,
                          color: product['inStock'] ? const Color(0xFF10B981) : const Color(0xFFE91E63),
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          product['inStock'] ? 'In Stock' : 'Out of Stock',
                          style: TextStyle(
                            color: product['inStock'] ? const Color(0xFF10B981) : const Color(0xFFE91E63),
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
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
      ),
    );
  }
}