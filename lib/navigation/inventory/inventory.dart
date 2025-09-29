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
  bool _isProductsSelected = true; // Toggle for Products/Categories
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All Products';
  String _selectedStatus = 'All Products';
  String _selectedSort = 'All Products';

  // Sample product data
  final List<Map<String, dynamic>> _products = [
    {
      'name': 'Maggie Noodles',
      'image': 'assets/images/maggie.png', // Placeholder for image
      'price': '₹20',
      'stock': '5/10',
      'gst': '5%',
      'value': '₹100',
      'expiry': '31/12/2024',
      'isExpired': true,
      'category': 'Snacks',
      'status': 'Low Stock',
      'tags': ['Snacks', 'Low Stock', 'Expired'],
    },
    {
      'name': 'Coca Cola 300ml',
      'image': 'assets/images/coca_cola.png', // Placeholder for image
      'price': '₹40',
      'stock': '25/15',
      'gst': '12%',
      'value': '₹1000',
      'expiry': '31/12/2024',
      'isExpired': true,
      'category': 'Beverages',
      'status': 'In Stock',
      'tags': ['Beverages', 'In Stock', 'Expired'],
    },
    {
      'name': 'Parle-G Biscuits',
      'image': 'assets/images/parle_g.png', // Placeholder for image
      'price': '₹10',
      'stock': '15/20',
      'gst': '5%',
      'value': '₹150',
      'expiry': '15/01/2025',
      'isExpired': false,
      'category': 'Snacks',
      'status': 'In Stock',
      'tags': ['Snacks', 'In Stock', 'Fresh'],
    },
    {
      'name': 'Lays Chips',
      'image': 'assets/images/lays.png', // Placeholder for image
      'price': '₹30',
      'stock': '8/12',
      'gst': '12%',
      'value': '₹240',
      'expiry': '20/01/2025',
      'isExpired': false,
      'category': 'Snacks',
      'status': 'Low Stock',
      'tags': ['Snacks', 'Low Stock', 'Fresh'],
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // Header with title and export buttons
            _buildHeader(),
            // Summary cards
            _buildSummaryCards(),
            // Toggle and search section
            _buildToggleAndSearch(),
            // Dropdowns and add button
            _buildDropdownsAndAddButton(),
            // Main content area - scrollable
            Expanded(child: SingleChildScrollView(child: _buildProductList())),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: widget.currentIndex,
        onTap: widget.onNavigationTap,
      ),
    );
  }

  // Header with title and export buttons - exact match to design
  Widget _buildHeader() {
    return Container(
      height: 60.0,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF5777B5), // Blue
            Color(0xFF26344F), // Dark Blue
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          children: [
            // Title
            const Expanded(
              child: Text(
                'Inventory',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            // Export buttons
            _buildExportButton('Export PDF', Icons.download, () {}),
            const SizedBox(width: 8.0),
            _buildExportButton('Export CSV', Icons.description, () {}),
          ],
        ),
      ),
    );
  }

  // Export button widget - exact match to design
  Widget _buildExportButton(String text, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 16.0),
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

  // Summary cards - exact match to design
  Widget _buildSummaryCards() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              icon: Icons.inventory_2_outlined,
              iconColor: Colors.blue,
              title: 'Total Products',
              value: '6',
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: _buildSummaryCard(
              icon: Icons.category_outlined,
              iconColor: Colors.green,
              title: 'Total Categories',
              value: '6',
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: _buildSummaryCard(
              icon: Icons.bar_chart,
              iconColor: Colors.purple,
              title: 'Total Value',
              value: '₹2,285',
            ),
          ),
        ],
      ),
    );
  }

  // Individual summary card - exact match to design
  Widget _buildSummaryCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10.0,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 24.0),
          const SizedBox(height: 8.0),
          Text(
            title,
            style: const TextStyle(fontSize: 12.0, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4.0),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF26344F),
            ),
          ),
        ],
      ),
    );
  }

  // Toggle and search section - exact match to design
  Widget _buildToggleAndSearch() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          // Toggle switch
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25.0),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isProductsSelected = true;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      decoration: BoxDecoration(
                        color: _isProductsSelected
                            ? const Color(0xFF26344F)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: Text(
                        'Products',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                          color: _isProductsSelected
                              ? Colors.white
                              : const Color(0xFF26344F),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isProductsSelected = false;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      decoration: BoxDecoration(
                        color: !_isProductsSelected
                            ? const Color(0xFF26344F)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: Text(
                        'Categories',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                          color: !_isProductsSelected
                              ? Colors.white
                              : const Color(0xFF26344F),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          // Search bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search Products',
                hintStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: InputBorder.none,
              ),
              onChanged: (value) {
                setState(() {}); // Trigger rebuild for search
              },
            ),
          ),
        ],
      ),
    );
  }

  // Dropdowns and add button - exact match to design
  Widget _buildDropdownsAndAddButton() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          // Dropdowns row
          Row(
            children: [
              Expanded(
                child: _buildDropdown('All Products', _selectedCategory, (
                  value,
                ) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                }),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: _buildDropdown('All Products', _selectedStatus, (value) {
                  setState(() {
                    _selectedStatus = value!;
                  });
                }),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: _buildDropdown('All Products', _selectedSort, (value) {
                  setState(() {
                    _selectedSort = value!;
                  });
                }),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          // Add Product button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: Implement add product functionality
              },
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                'Add Product',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B35), // Orange color
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Dropdown widget - exact match to design
  Widget _buildDropdown(
    String hint,
    String value,
    ValueChanged<String?> onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          style: const TextStyle(fontSize: 14.0, color: Color(0xFF26344F)),
          items: ['All Products', 'Snacks', 'Beverages', 'Dairy', 'Frozen'].map(
            (String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            },
          ).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  // Product list - exact match to design
  Widget _buildProductList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: _products.map((product) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16.0),
            child: _buildProductCard(product),
          );
        }).toList(),
      ),
    );
  }

  // Product card - exact match to design
  Widget _buildProductCard(Map<String, dynamic> product) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10.0,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with image, name, and action buttons
          Row(
            children: [
              // Product image placeholder
              Container(
                width: 60.0,
                height: 60.0,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Icon(Icons.image, color: Colors.grey, size: 30.0),
              ),
              const SizedBox(width: 12.0),
              // Product name and tags
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['name'],
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF26344F),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    // Tags
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: product['tags'].map<Widget>((tag) {
                        Color tagColor;
                        if (tag == 'Snacks' || tag == 'Beverages') {
                          tagColor = Colors.blue[100]!;
                        } else if (tag == 'Low Stock') {
                          tagColor = Colors.orange[100]!;
                        } else if (tag == 'In Stock') {
                          tagColor = Colors.green[100]!;
                        } else if (tag == 'Expired') {
                          tagColor = Colors.red[100]!;
                        } else {
                          tagColor = Colors.green[100]!;
                        }

                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 4.0,
                          ),
                          decoration: BoxDecoration(
                            color: tagColor,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Text(
                            tag,
                            style: TextStyle(
                              fontSize: 10.0,
                              color: tag == 'Expired'
                                  ? Colors.red
                                  : Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              // Action buttons
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      // TODO: Implement edit functionality
                    },
                    icon: const Icon(Icons.edit, color: Colors.grey),
                  ),
                  IconButton(
                    onPressed: () {
                      // TODO: Implement delete functionality
                    },
                    icon: const Icon(Icons.delete, color: Colors.red),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          // Product details grid
          Row(
            children: [
              Expanded(child: _buildDetailItem('Price', product['price'])),
              Expanded(child: _buildDetailItem('Stock', product['stock'])),
              Expanded(child: _buildDetailItem('GST', product['gst'])),
              Expanded(child: _buildDetailItem('Value', product['value'])),
            ],
          ),
          const SizedBox(height: 12.0),
          // Expiry information
          Row(
            children: [
              Text(
                'Expires: ${product['expiry']}',
                style: const TextStyle(fontSize: 12.0, color: Colors.grey),
              ),
              if (product['isExpired'])
                const Text(
                  ' (Expired)',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // Detail item widget
  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10.0, color: Colors.grey)),
        const SizedBox(height: 2.0),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.w600,
            color: Color(0xFF26344F),
          ),
        ),
      ],
    );
  }
}
