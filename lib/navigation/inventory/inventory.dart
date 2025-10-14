import 'package:flutter/material.dart';
import '../navigation.dart';

class InventoryScreen extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onNavigationTap;

  const InventoryScreen({
    super.key,
    required this.currentIndex,
    required this.onNavigationTap,
  });

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  bool _isProductsSelected = true;
  final TextEditingController _searchController = TextEditingController();
  String dropValue1 = 'All Products', dropValue2 = 'All Categories', dropValue3 = 'All Status';
  
  List<Map<String, dynamic>> _filteredProducts = [];
  bool _isLoading = false;

  final List<Map<String, dynamic>> _products = [
    {
      'name': 'Maggie Noodles',
      'image': 'assets/products/maggi.png',
      'price': '₹20',
      'stock': '5/10',
      'gst': '5%',
      'value': '₹100',
      'expiry': '31/12/2024',
      'isExpired': true,
      'tags': ['Snacks', 'Low Stock', 'Expired'],
    },
    {
      'name': 'Coca Cola 300ml',
      'image': 'assets/products/bread.png',
      'price': '₹40',
      'stock': '25/15',
      'gst': '12%',
      'value': '₹1000',
      'expiry': '31/12/2024',
      'isExpired': true,
      'tags': ['Beverages', 'In Stock', 'Expired'],
    },
    {
      'name': 'Parle-G Biscuits',
      'image': 'assets/products/brinjal.png',
      'price': '₹10',
      'stock': '15/20',
      'gst': '5%',
      'value': '₹150',
      'expiry': '15/01/2025',
      'isExpired': false,
      'tags': ['Snacks', 'In Stock', 'Fresh'],
    },
    {
      'name': 'Lays Chips',
      'image': 'assets/products/potato.png',
      'price': '₹30',
      'stock': '8/12',
      'gst': '12%',
      'value': '₹240',
      'expiry': '20/01/2025',
      'isExpired': false,
      'tags': ['Snacks', 'Low Stock', 'Fresh'],
    },
  ];

  @override
  void initState() {
    super.initState();
    _filteredProducts = List.from(_products);
    _searchController.addListener(_filterProducts);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Filter products based on search and dropdown selections
  void _filterProducts() {
    setState(() {
      _filteredProducts = _products.where((product) {
        // Search filter
        final searchMatch = product['name']
            .toLowerCase()
            .contains(_searchController.text.toLowerCase());
        
        // Category filter
        bool categoryMatch = true;
        if (dropValue2 != 'All Categories') {
          categoryMatch = product['tags'].contains(dropValue2);
        }
        
        // Status filter
        bool statusMatch = true;
        if (dropValue3 == 'Low Stock') {
          final stock = product['stock'].split('/');
          final current = int.parse(stock[0]);
          final max = int.parse(stock[1]);
          statusMatch = current < max * 0.5; // Less than 50% stock
        } else if (dropValue3 == 'Expired') {
          statusMatch = product['isExpired'] == true;
        } else if (dropValue3 == 'In Stock') {
          statusMatch = product['isExpired'] == false;
        }
        
        return searchMatch && categoryMatch && statusMatch;
      }).toList();
    });
  }

  // Add new product
  void _showAddProductDialog() {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final stockController = TextEditingController();
    final maxStockController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Product'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: stockController,
                decoration: const InputDecoration(labelText: 'Current Stock'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: maxStockController,
                decoration: const InputDecoration(labelText: 'Maximum Stock'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty && 
                  priceController.text.isNotEmpty &&
                  stockController.text.isNotEmpty &&
                  maxStockController.text.isNotEmpty) {
                
                final newProduct = {
                  'name': nameController.text,
                  'image': 'assets/products/default.png',
                  'price': '₹${priceController.text}',
                  'stock': '${stockController.text}/${maxStockController.text}',
                  'gst': '12%',
                  'value': '₹${int.parse(priceController.text) * int.parse(stockController.text)}',
                  'expiry': '31/12/2025',
                  'isExpired': false,
                  'tags': ['General', 'In Stock', 'Fresh'],
                };
                
                setState(() {
                  _products.add(newProduct);
                  _filterProducts();
                });
                
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Product added successfully!'),
                    backgroundColor: Color(0xFF10B981),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF805D),
              foregroundColor: Colors.white,
            ),
            child: const Text('Add Product'),
          ),
        ],
      ),
    );
  }

  // Export functionality
  void _exportData(String format) {
    setState(() {
      _isLoading = true;
    });
    
    // Simulate export process
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Inventory exported as $format successfully!'),
          backgroundColor: const Color(0xFF10B981),
          action: SnackBarAction(
            label: 'View',
            textColor: Colors.white,
            onPressed: () {
              // TODO: Open exported file
            },
          ),
        ),
      );
    });
  }

  // Delete product
  void _deleteProduct(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: Text('Are you sure you want to delete "${_filteredProducts[index]['name']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                final productToDelete = _filteredProducts[index];
                _products.removeWhere((p) => p['name'] == productToDelete['name']);
                _filterProducts();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Product deleted successfully!'),
                  backgroundColor: Color(0xFFE91E63),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE91E63),
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  // Edit product
  void _editProduct(int index) {
    final product = _filteredProducts[index];
    final nameController = TextEditingController(text: product['name']);
    final priceController = TextEditingController(text: product['price'].replaceAll('₹', ''));
    final stockParts = product['stock'].split('/');
    final stockController = TextEditingController(text: stockParts[0]);
    final maxStockController = TextEditingController(text: stockParts[1]);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Product'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: stockController,
                decoration: const InputDecoration(labelText: 'Current Stock'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: maxStockController,
                decoration: const InputDecoration(labelText: 'Maximum Stock'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty && 
                  priceController.text.isNotEmpty &&
                  stockController.text.isNotEmpty &&
                  maxStockController.text.isNotEmpty) {
                
                final productIndex = _products.indexWhere((p) => p['name'] == product['name']);
                if (productIndex != -1) {
                  setState(() {
                    _products[productIndex] = {
                      ..._products[productIndex],
                      'name': nameController.text,
                      'price': '₹${priceController.text}',
                      'stock': '${stockController.text}/${maxStockController.text}',
                      'value': '₹${int.parse(priceController.text) * int.parse(stockController.text)}',
                    };
                    _filterProducts();
                  });
                }
                
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Product updated successfully!'),
                    backgroundColor: Color(0xFF10B981),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
            ),
            child: const Text('Update Product'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      body: Column(
        children: [
          SafeArea(
            child: _buildHeader(),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildSummaryCards(),
                  _buildToggleAndSearch(),
                  _buildDropdownsAndAddButton(),
                  _buildProductList(),
                  const SizedBox(height: 20),
                ],
              ),
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
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isSmallScreen = constraints.maxWidth < 400;
              
              return Row(
                children: [
                  Expanded(
                    child: Text(
                      'Inventory',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 16.0 : 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                  if (isSmallScreen) ...[
                    // Icon-only buttons for small screens
                    _buildExportButton('', Icons.picture_as_pdf, () => _exportData('PDF'), iconOnly: true),
                    const SizedBox(width: 6),
                    _buildExportButton('', Icons.description, () => _exportData('CSV'), iconOnly: true),
                  ] else ...[
                    // Full text buttons for larger screens
                    _buildExportButton('Export PDF', Icons.download, () => _exportData('PDF')),
                    const SizedBox(width: 8),
                    _buildExportButton('Export CSV', Icons.description, () {
                      Navigator.pushNamed(context, '/csv-import-export');
                    }),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildExportButton(String text, IconData icon, VoidCallback onTap, {bool iconOnly = false}) {
    return GestureDetector(
      onTap: _isLoading ? null : onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: iconOnly ? 8.0 : 12.0, 
          vertical: 6.0,
        ),
        decoration: BoxDecoration(
          color: _isLoading 
              ? Colors.grey.withOpacity(0.3)
              : Colors.white.withOpacity(0.20),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_isLoading && text.contains('PDF'))
              const SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            else if (_isLoading && text.contains('CSV'))
              const SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            else
              Icon(icon, color: Colors.white, size: 14.0),
            if (!iconOnly) ...[
              const SizedBox(width: 4.0),
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    // Calculate summary data
    final totalProducts = _products.length;
    final lowStockProducts = _products.where((p) {
      final stock = p['stock'].split('/');
      final current = int.parse(stock[0]);
      final max = int.parse(stock[1]);
      return current < max * 0.5;
    }).length;
    final expiredProducts = _products.where((p) => p['isExpired'] == true).length;
    final totalValue = _products.fold<int>(0, (sum, p) => sum + int.parse(p['value'].replaceAll('₹', '')));

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isSmallScreen = constraints.maxWidth < 400;
          
          // Use 2x2 grid for small screens, 1x4 for larger screens
          if (isSmallScreen) {
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildSummaryCard(
                        title: 'Total Products',
                        value: totalProducts.toString(),
                        color: const Color(0xFF10B981),
                        icon: Icons.inventory_2,
                        isSmall: true,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildSummaryCard(
                        title: 'Low Stock',
                        value: lowStockProducts.toString(),
                        color: const Color(0xFFFF805D),
                        icon: Icons.warning,
                        isSmall: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildSummaryCard(
                        title: 'Expired',
                        value: expiredProducts.toString(),
                        color: const Color(0xFFE91E63),
                        icon: Icons.schedule,
                        isSmall: true,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildSummaryCard(
                        title: 'Total Value',
                        value: '₹$totalValue',
                        color: const Color(0xFF5777B5),
                        icon: Icons.account_balance_wallet,
                        isSmall: true,
                      ),
                    ),
                  ],
                ),
              ],
            );
          } else {
            return Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    title: 'Total Products',
                    value: totalProducts.toString(),
                    color: const Color(0xFF10B981),
                    icon: Icons.inventory_2,
                    isSmall: false,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(
                    title: 'Low Stock',
                    value: lowStockProducts.toString(),
                    color: const Color(0xFFFF805D),
                    icon: Icons.warning,
                    isSmall: false,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(
                    title: 'Expired',
                    value: expiredProducts.toString(),
                    color: const Color(0xFFE91E63),
                    icon: Icons.schedule,
                    isSmall: false,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(
                    title: 'Total Value',
                    value: '₹$totalValue',
                    color: const Color(0xFF5777B5),
                    icon: Icons.account_balance_wallet,
                    isSmall: false,
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
    bool isSmall = false,
  }) {
    return Container(
      padding: EdgeInsets.all(isSmall ? 8 : 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
        children: [
          Icon(icon, color: color, size: isSmall ? 18 : 24),
          SizedBox(height: isSmall ? 4 : 8),
          Text(
            value,
            style: TextStyle(
              fontSize: isSmall ? 14 : 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: isSmall ? 2 : 4),
          Text(
            title,
            style: TextStyle(
              fontSize: isSmall ? 9 : 11,
              color: const Color(0xFF6B7280),
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildToggleAndSearch() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          // Toggle buttons
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _isProductsSelected = true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: _isProductsSelected 
                          ? const Color(0xFFFF805D) 
                          : Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Products',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _isProductsSelected ? Colors.white : Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _isProductsSelected = false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: !_isProductsSelected 
                          ? const Color(0xFFFF805D) 
                          : Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Categories',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: !_isProductsSelected ? Colors.white : Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Search bar
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search products...',
                prefixIcon: Icon(Icons.search, color: Color(0xFF6B7280)),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownsAndAddButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _customDropdown(
                  dropValue1, 
                  ['All Products', 'Recent', 'Popular'],
                  (val) {
                    setState(() {
                      dropValue1 = val!;
                      _filterProducts();
                    });
                  }
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: _customDropdown(
                  dropValue2, 
                  ['All Categories', 'Snacks', 'Beverages', 'General'],
                  (val) {
                    setState(() {
                      dropValue2 = val!;
                      _filterProducts();
                    });
                  }
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: _customDropdown(
                  dropValue3, 
                  ['All Status', 'Low Stock', 'In Stock', 'Expired'],
                  (val) {
                    setState(() {
                      dropValue3 = val!;
                      _filterProducts();
                    });
                  }
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _showAddProductDialog,
              icon: const Icon(Icons.add, color: Colors.white, size: 18),
              label: const Text(
                'Add Product',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF805D),
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _customDropdown(String value, List<String> items, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(fontSize: 12),
              ),
            );
          }).toList(),
          onChanged: onChanged,
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildProductList() {
    if (!_isProductsSelected) {
      return const Padding(
        padding: EdgeInsets.all(32.0),
        child: Text(
          'Categories view coming soon...',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF6B7280),
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: _filteredProducts.asMap().entries.map((entry) {
          final index = entry.key;
          final product = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: _buildProductCard(product, index),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product, int index) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 400;
        
        return Container(
          padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
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
            children: [
              Row(
                children: [
                  // Product Image
                  Container(
                    width: isSmallScreen ? 40 : 50,
                    height: isSmallScreen ? 40 : 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.inventory_2,
                      color: const Color(0xFF26344F),
                      size: isSmallScreen ? 20 : 24,
                    ),
                  ),
                  SizedBox(width: isSmallScreen ? 8 : 12),
                  // Product Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product['name'],
                          style: TextStyle(
                            fontSize: isSmallScreen ? 14 : 16,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF26344F),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: isSmallScreen ? 6 : 8),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: _detailItem('Price', product['price'], isSmallScreen),
                            ),
                            SizedBox(width: isSmallScreen ? 4 : 8),
                            Expanded(
                              flex: 2,
                              child: _detailItem('Stock', product['stock'], isSmallScreen),
                            ),
                            SizedBox(width: isSmallScreen ? 4 : 8),
                            Expanded(
                              flex: 1,
                              child: _detailItem('GST', product['gst'], isSmallScreen),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Status indicator
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 6 : 8, 
                      vertical: isSmallScreen ? 3 : 4,
                    ),
                    decoration: BoxDecoration(
                      color: product['isExpired'] 
                          ? const Color(0xFFE91E63) 
                          : const Color(0xFF10B981),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      product['isExpired'] ? 'Expired' : 'Fresh',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isSmallScreen ? 8 : 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: isSmallScreen ? 8 : 12),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: _detailItem('Total Value', product['value'], isSmallScreen),
                  ),
                  Expanded(
                    flex: 3,
                    child: _detailItem('Expiry', product['expiry'], isSmallScreen),
                  ),
                  // Actions
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () => _editProduct(index),
                          icon: Icon(
                            Icons.edit,
                            color: const Color(0xFF10B981),
                            size: isSmallScreen ? 16 : 20,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        SizedBox(width: isSmallScreen ? 2 : 4),
                        IconButton(
                          onPressed: () => _deleteProduct(index),
                          icon: Icon(
                            Icons.delete,
                            color: const Color(0xFFE91E63),
                            size: isSmallScreen ? 16 : 20,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _detailItem(String label, String value, [bool isSmallScreen = false]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isSmallScreen ? 8 : 10,
            color: const Color(0xFF6B7280),
          ),
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: isSmallScreen ? 1 : 2),
        Text(
          value,
          style: TextStyle(
            fontSize: isSmallScreen ? 10 : 12,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF26344F),
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}