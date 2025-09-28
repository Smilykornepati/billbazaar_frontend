import 'package:flutter/material.dart';
import '../navigation.dart';

class CategoriesScreen extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onNavigationTap;

  const CategoriesScreen({
    super.key,
    required this.currentIndex,
    required this.onNavigationTap,
  });

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  // Category data with actual icon paths
  final List<Map<String, dynamic>> _categories = [
    // Analytics Category
    {
      'name': 'Analytics',
      'icon': 'assets/categories/icons/analytics/i-9.png',
      'items': [
        {
          'name': 'Sales Analytics',
          'icon': 'assets/categories/icons/analytics/i-10.png',
        },
        {
          'name': 'Customer Analytics',
          'icon': 'assets/categories/icons/analytics/i-11.png',
        },
        {
          'name': 'Inventory Analytics',
          'icon': 'assets/categories/icons/analytics/i-12.png',
        },
      ],
    },
    // Billing Category
    {
      'name': 'Billing',
      'icon': 'assets/categories/icons/billing/i-1.png',
      'items': [
        {
          'name': 'Invoice Management',
          'icon': 'assets/categories/icons/billing/i-2.png',
        },
        {
          'name': 'Payment Tracking',
          'icon': 'assets/categories/icons/billing/i-3.png',
        },
        {
          'name': 'Tax Management',
          'icon': 'assets/categories/icons/billing/i-4.png',
        },
        {
          'name': 'Receipt Generation',
          'icon': 'assets/categories/icons/billing/i-5.png',
        },
        {
          'name': 'Payment Methods',
          'icon': 'assets/categories/icons/billing/i-6.png',
        },
        {
          'name': 'Billing Reports',
          'icon': 'assets/categories/icons/billing/i-7.png',
        },
        {
          'name': 'Customer Billing',
          'icon': 'assets/categories/icons/billing/i-8.png',
        },
      ],
    },
    // Smart Tools Category
    {
      'name': 'Smart Tools',
      'icon': 'assets/categories/icons/smarttools/i-15.png',
      'items': [
        {
          'name': 'AI Assistant',
          'icon': 'assets/categories/icons/smarttools/i-16.png',
        },
        {
          'name': 'Smart Reports',
          'icon': 'assets/categories/icons/smarttools/i-17.png',
        },
      ],
    },
    // Printing Category
    {
      'name': 'Printing',
      'icon': 'assets/categories/icons/printing/i-13.png',
      'items': [
        {
          'name': 'Label Printing',
          'icon': 'assets/categories/icons/printing/i-14.png',
        },
      ],
    },
    // More Tools Category
    {
      'name': 'More Tools',
      'icon': 'assets/categories/icons/moretools/i-18.png',
      'items': [
        {
          'name': 'Advanced Settings',
          'icon': 'assets/categories/icons/moretools/i-19.png',
        },
        {
          'name': 'System Tools',
          'icon': 'assets/categories/icons/moretools/i-20.png',
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // Header with title and export buttons
            _buildHeader(),
            // Main content area - scrollable
            Expanded(
              child: SingleChildScrollView(child: _buildCategoriesContent()),
            ),
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
                'Categories',
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

  // Categories content - scrollable
  Widget _buildCategoriesContent() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          const Text(
            'All Categories',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF26344F),
            ),
          ),
          const SizedBox(height: 20.0),
          // Categories grid
          _buildCategoriesGrid(),
        ],
      ),
    );
  }

  // Categories grid - exact match to design
  Widget _buildCategoriesGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 1.2,
      ),
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        return _buildCategoryCard(_categories[index]);
      },
    );
  }

  // Category card - exact match to design
  Widget _buildCategoryCard(Map<String, dynamic> category) {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to category details
        _showCategoryItems(category);
      },
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10.0,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Category icon
            Container(
              width: 60.0,
              height: 60.0,
              decoration: BoxDecoration(
                color: const Color(0xFFF7FAFC),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.asset(
                  category['icon'],
                  width: 40.0,
                  height: 40.0,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.category_outlined,
                      color: Colors.grey,
                      size: 30.0,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 12.0),
            // Category name
            Text(
              category['name'],
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF26344F),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4.0),
            // Item count
            Text(
              '${category['items'].length} items',
              style: const TextStyle(fontSize: 12.0, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  // Show category items modal
  void _showCategoryItems(Map<String, dynamic> category) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12.0),
              width: 40.0,
              height: 4.0,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7FAFC),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        category['icon'],
                        width: 24.0,
                        height: 24.0,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.category_outlined,
                            color: Colors.grey,
                            size: 20.0,
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Text(
                      category['name'],
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF26344F),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.grey),
                  ),
                ],
              ),
            ),
            // Items list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                itemCount: category['items'].length,
                itemBuilder: (context, index) {
                  final item = category['items'][index];
                  return GestureDetector(
                    onTap: () {
                      // Navigate to Quick Bill for Invoice Management
                      if (item['name'] == 'Invoice Management') {
                        Navigator.pushNamed(context, '/quick-bill');
                      } else {
                        // TODO: Implement other item navigation
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12.0),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7FAFC),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40.0,
                            height: 40.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.asset(
                                item['icon'],
                                width: 24.0,
                                height: 24.0,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.settings,
                                    color: Colors.grey,
                                    size: 20.0,
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 12.0),
                          Expanded(
                            child: Text(
                              item['name'],
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF26344F),
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey,
                            size: 16.0,
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
