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
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'Inventory',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
              _buildExportButton('Export PDF', Icons.download, () => _exportData('PDF')),
              const SizedBox(width: 8),
              _buildExportButton('Export CSV', Icons.description, () => _exportData('CSV')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExportButton(String text, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: _isLoading ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
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
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              title: 'Total Products',
              value: totalProducts.toString(),
              color: const Color(0xFF10B981),
              icon: Icons.inventory_2,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  dropValue3 = 'Low Stock';
                  _filterProducts();
                });
              },
              child: _buildSummaryCard(
                title: 'Low Stock',
                value: lowStockProducts.toString(),
                color: const Color(0xFFFF805D),
                icon: Icons.warning,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  dropValue3 = 'Expired';
                  _filterProducts();
                });
              },
              child: _buildSummaryCard(
                title: 'Expired',
                value: expiredProducts.toString(),
                color: const Color(0xFFE91E63),
                icon: Icons.schedule,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              title: 'Total Value',
              value: '₹$totalValue',
              color: const Color(0xFF5777B5),
              icon: Icons.currency_rupee,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
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
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF6B7280),
            ),
            textAlign: TextAlign.center,
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
    return Container(
      padding: const EdgeInsets.all(16),
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
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.inventory_2,
                  color: Color(0xFF26344F),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              // Product Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['name'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF26344F),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _detailItem('Price', product['price']),
                        const SizedBox(width: 16),
                        _detailItem('Stock', product['stock']),
                        const SizedBox(width: 16),
                        _detailItem('GST', product['gst']),
                      ],
                    ),
                  ],
                ),
              ),
              // Status indicator
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: product['isExpired'] 
                      ? const Color(0xFFE91E63) 
                      : const Color(0xFF10B981),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  product['isExpired'] ? 'Expired' : 'Fresh',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _detailItem('Total Value', product['value']),
              ),
              Expanded(
                child: _detailItem('Expiry', product['expiry']),
              ),
              // Actions
              Row(
                children: [
                  IconButton(
                    onPressed: () => _editProduct(index),
                    icon: const Icon(
                      Icons.edit,
                      color: Color(0xFF10B981),
                      size: 20,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () => _deleteProduct(index),
                    icon: const Icon(
                      Icons.delete,
                      color: Color(0xFFE91E63),
                      size: 20,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _detailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF26344F),
          ),
        ),
      ],
    );
  }
}