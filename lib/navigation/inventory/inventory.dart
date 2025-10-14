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
      height: 56.0,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF5777B5), Color(0xFF26344F)],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
            _buildExportButton('Export PDF', Icons.download, () {}),
            const SizedBox(width: 8),
            _buildExportButton('Export CSV', Icons.description, () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildExportButton(String text, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.20),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 14.0),
            const SizedBox(width: 4.0),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11.0,
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
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              icon: Icons.inventory_2_outlined,
              iconColor: const Color(0xFF23408F),
              title: 'Products',
              value: '6',
            ),
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: _buildSummaryCard(
              icon: Icons.grid_view_rounded,
              iconColor: const Color(0xFF10B981),
              title: 'Categories',
              value: '6',
            ),
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: _buildSummaryCard(
              icon: Icons.bar_chart_rounded,
              iconColor: const Color(0xFFAA60E0),
              title: 'Value',
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
      height: 70,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(height: 3),
          Flexible(
            child: Text(
              title,
              style: const TextStyle(fontSize: 9, color: Color(0xFF26344F)),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 2),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF26344F),
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleAndSearch() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
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
          const SizedBox(height: 8),
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            decoration: BoxDecoration(
              color: const Color(0xFFE6EEFA),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search Products',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                border: InputBorder.none,
                icon: Icon(Icons.search, color: Colors.grey, size: 18),
                contentPadding: EdgeInsets.symmetric(vertical: 8),
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
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF5777B5) : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
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
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _customDropdown(dropValue1, (val) {
                  setState(() => dropValue1 = val!);
                }),
              ),
              const SizedBox(width: 6.0),
              Expanded(
                child: _customDropdown(dropValue2, (val) {
                  setState(() => dropValue2 = val!);
                }),
              ),
              const SizedBox(width: 6.0),
              Expanded(
                child: _customDropdown(dropValue3, (val) {
                  setState(() => dropValue3 = val!);
                }),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {},
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
                padding: const EdgeInsets.symmetric(vertical: 11.0),
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

  Widget _customDropdown(String current, ValueChanged<String?> onChanged) {
    const items = [
      'All Products', 'Snacks', 'Beverages', 'Dairy', 'Frozen'
    ];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: current,
          isExpanded: true,
          items: items.map((e) =>
            DropdownMenuItem(child: Text(e, style: const TextStyle(fontSize: 11)), value: e)).toList(),
          style: const TextStyle(fontSize: 11.0, color: Color(0xFF26344F)),
          onChanged: onChanged,
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildProductList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: _products.map((product) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: _buildProductCard(product),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6, offset: const Offset(0, 2),
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
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: AssetImage(product['image']),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['name'],
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF26344F),
                        letterSpacing: 0.1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6.0,
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
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          margin: const EdgeInsets.only(top: 3),
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            tag,
                            style: TextStyle(
                              fontSize: 10,
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
                    icon: const Icon(Icons.edit, color: Color(0xFF26344F), size: 20),
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _detailItem('Price', product['price'])),
              Expanded(child: _detailItem('Stock', product['stock'])),
              Expanded(child: _detailItem('GST', product['gst'])),
              Expanded(child: _detailItem('Value', product['value'])),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.calendar_today, color: Colors.grey, size: 12),
              const SizedBox(width: 4),
              Text(
                'Expires: ${product['expiry']}',
                style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
              ),
              if (product['isExpired'])
                const Text(
                  ' (Expired)',
                  style: TextStyle(
                    fontSize: 11,
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
