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
  String dropValue1 = 'All Products', dropValue2 = 'All Products', dropValue3 = 'All Products';

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
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              _buildSummaryCards(),
              _buildToggleAndSearch(),
              _buildDropdownsAndAddButton(),
              _buildProductList(),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: widget.currentIndex,
        onTap: widget.onNavigationTap,
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 64.0,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF5777B5), Color(0xFF26344F)],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22.0),
        child: Row(
          children: [
            const Expanded(
              child: Text(
                'Inventory',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.2,
                ),
              ),
            ),
            _buildExportButton('Export PDF', Icons.download, () {}),
            const SizedBox(width: 10),
            _buildExportButton('Export CVC', Icons.description, () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildExportButton(String text, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.20),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 15.0),
            const SizedBox(width: 4.0),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12.0,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              icon: Icons.inventory_2_outlined,
              iconColor: const Color(0xFF23408F),
              title: 'Total Products',
              value: '6',
            ),
          ),
          const SizedBox(width: 14.0),
          Expanded(
            child: _buildSummaryCard(
              icon: Icons.grid_view_rounded,
              iconColor: const Color(0xFF10B981),
              title: 'Total Categories',
              value: '6',
            ),
          ),
          const SizedBox(width: 14.0),
          Expanded(
            child: _buildSummaryCard(
              icon: Icons.bar_chart_rounded,
              iconColor: const Color(0xFFAA60E0),
              title: 'Total Value',
              value: '₹2,285',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
  }) {
    return Container(
      height: 90,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 26),
          const SizedBox(height: 7),
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Color(0xFF26344F)),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16.5,
              fontWeight: FontWeight.w700,
              color: Color(0xFF26344F),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleAndSearch() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                _toggleButton('Products', _isProductsSelected, () {
                  setState(() => _isProductsSelected = true);
                }),
                _toggleButton('Categories', !_isProductsSelected, () {
                  setState(() => _isProductsSelected = false);
                }),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: const Color(0xFFE6EEFA),
              borderRadius: BorderRadius.circular(13.0),
            ),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search Products',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                border: InputBorder.none,
                icon: Icon(Icons.search, color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _toggleButton(String text, bool selected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF5777B5) : Colors.transparent,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : const Color(0xFF26344F),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownsAndAddButton() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _customDropdown(dropValue1, (val) {
                  setState(() => dropValue1 = val!);
                }),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: _customDropdown(dropValue2, (val) {
                  setState(() => dropValue2 = val!);
                }),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: _customDropdown(dropValue3, (val) {
                  setState(() => dropValue3 = val!);
                }),
              ),
            ],
          ),
          const SizedBox(height: 14.0),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add, color: Colors.white, size: 21),
              label: const Text(
                'Add Product',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.5,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF805D),
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
                elevation: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _customDropdown(String current, ValueChanged<String?> onChanged) {
    const items = [
      'All Products', 'Snacks', 'Beverages', 'Dairy', 'Frozen'
    ];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: current,
          isExpanded: true,
          items: items.map((e) =>
            DropdownMenuItem(child: Text(e), value: e)).toList(),
          style: const TextStyle(fontSize: 13.0, color: Color(0xFF26344F)),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildProductList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: _products.map((product) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 14.0),
            child: _buildProductCard(product),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 7, offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Product image
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: AssetImage(product['image']),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['name'],
                      style: const TextStyle(
                        fontSize: 16.2,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF26344F),
                        letterSpacing: 0.15,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Wrap(
                      spacing: 7.0,
                      children: product['tags'].map<Widget>((tag) {
                        Color bgColor;
                        Color textColor;
                        if (tag == 'Snacks') {
                          bgColor = const Color(0xFFE6EEFA);
                          textColor = const Color(0xFF23408F);
                        } else if (tag == 'Beverages') {
                          bgColor = const Color(0xFFE6FAF1);
                          textColor = const Color(0xFF10B981);
                        } else if (tag == 'Low Stock') {
                          bgColor = const Color(0xFFFEE5BB);
                          textColor = const Color(0xFFFF9500);
                        } else if (tag == 'In Stock') {
                          bgColor = const Color(0xFFD1F3E8);
                          textColor = const Color(0xFF10B981);
                        } else if (tag == 'Expired') {
                          bgColor = const Color(0xFFFED1DC);
                          textColor = const Color(0xFFE53935);
                        } else {
                          bgColor = const Color(0xFFD1F3E8);
                          textColor = const Color(0xFF10B981);
                        }
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          margin: const EdgeInsets.only(top: 4),
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: Text(
                            tag,
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              // Edit and Delete actions
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Color(0xFF26344F), size: 21),
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red, size: 21),
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 11),
          Row(
            children: [
              Expanded(child: _detailItem('Price', product['price'])),
              Expanded(child: _detailItem('Stock', product['stock'])),
              Expanded(child: _detailItem('GST', product['gst'])),
              Expanded(child: _detailItem('Value', product['value'])),
            ],
          ),
          const SizedBox(height: 11),
          Row(
            children: [
              const Icon(Icons.calendar_today, color: Colors.grey, size: 13),
              const SizedBox(width: 5),
              Text(
                'Expires: ${product['expiry']}',
                style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
              ),
              if (product['isExpired'])
                const Text(
                  ' (Expired)',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFFE53935),
                    fontWeight: FontWeight.w600,
                  ),
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
        Text(label, style: const TextStyle(fontSize: 10.5, color: Color(0xFFADB5BC))),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF26344F), letterSpacing: 0.1),
        ),
      ],
    );
  }
}
