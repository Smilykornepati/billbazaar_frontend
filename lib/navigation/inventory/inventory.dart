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
  int _selectedTabIndex = 0;
  final List<String> _tabs = ['Overview', 'Sales', 'Inventory', 'Customer'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button, title, and export buttons
            _buildHeader(),
            // Date filter and tabs
            _buildFilterAndTabs(),
            // Main content area
            Expanded(child: _buildMainContent()),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: widget.currentIndex,
        onTap: widget.onNavigationTap,
      ),
    );
  }

  // Header with back button, title, and export buttons
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
            // Removed back button for main navigation screens
            // Title
            const Expanded(
              child: Text(
                'Reports',
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

  // Export button widget
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

  // Date filter and tabs section
  Widget _buildFilterAndTabs() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Date filter
          Container(
            margin: const EdgeInsets.all(20.0),
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF7FAFC),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  color: Color(0xFF26344F),
                  size: 20.0,
                ),
                const SizedBox(width: 12.0),
                const Expanded(
                  child: Text(
                    'Today',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF26344F),
                    ),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: Color(0xFF26344F),
                  size: 20.0,
                ),
              ],
            ),
          ),
          // Tabs
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: _tabs.asMap().entries.map((entry) {
                int index = entry.key;
                String tab = entry.value;
                bool isSelected = _selectedTabIndex == index;

                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedTabIndex = index;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8.0),
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF26344F)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Text(
                        tab,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF26344F),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }

  // Main content area
  Widget _buildMainContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Today's Sales Card
          _buildTodaysSalesCard(),
          const SizedBox(height: 20.0),
          // Metrics Cards
          _buildMetricsCards(),
          const SizedBox(height: 20.0),
          // Top Selling Products
          _buildTopSellingProducts(),
          const SizedBox(height: 20.0),
          // Low Stock Alert
          _buildLowStockAlert(),
        ],
      ),
    );
  }

  // Today's Sales Card
  Widget _buildTodaysSalesCard() {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.currency_rupee, color: Colors.green, size: 24.0),
              const SizedBox(width: 8.0),
              const Text(
                "Today's Sales",
                style: TextStyle(fontSize: 16.0, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '₹15,250',
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              Row(
                children: [
                  const Icon(
                    Icons.trending_up,
                    color: Colors.green,
                    size: 20.0,
                  ),
                  const SizedBox(width: 4.0),
                  const Text(
                    '12.5%',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          const Text(
            'from your previous sale',
            style: TextStyle(fontSize: 12.0, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // Metrics Cards
  Widget _buildMetricsCards() {
    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            icon: Icons.description,
            iconColor: Colors.blue,
            title: 'Total Orders',
            value: '48',
            trend: '-5.2%',
            trendColor: Colors.red,
            trendIcon: Icons.trending_down,
          ),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: _buildMetricCard(
            icon: Icons.bar_chart,
            iconColor: Colors.purple,
            title: 'Avg Order Value',
            value: '₹318',
            trend: '+8.7%',
            trendColor: Colors.green,
            trendIcon: Icons.trending_up,
          ),
        ),
      ],
    );
  }

  // Individual metric card
  Widget _buildMetricCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required String trend,
    required Color trendColor,
    required IconData trendIcon,
  }) {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 24.0),
          const SizedBox(height: 12.0),
          Text(
            title,
            style: const TextStyle(fontSize: 14.0, color: Colors.grey),
          ),
          const SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF26344F),
                ),
              ),
              Row(
                children: [
                  Icon(trendIcon, color: trendColor, size: 16.0),
                  const SizedBox(width: 4.0),
                  Text(
                    trend,
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
                      color: trendColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Top Selling Products
  Widget _buildTopSellingProducts() {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.inventory_2_outlined,
                color: Colors.grey,
                size: 20.0,
              ),
              const SizedBox(width: 8.0),
              const Text(
                'Top Selling Products',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF26344F),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          _buildProductItem(
            '1. Maggie Noodles',
            '45 items sold',
            '₹900 revenue',
          ),
          const SizedBox(height: 12.0),
          _buildProductItem('2. Coca Cola', '32 items sold', '₹1280 revenue'),
          const SizedBox(height: 12.0),
          _buildProductItem('3. Parle-G', '28 items sold', '₹280 revenue'),
        ],
      ),
    );
  }

  // Product item widget
  Widget _buildProductItem(String title, String items, String revenue) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              color: Color(0xFF26344F),
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              items,
              style: const TextStyle(fontSize: 12.0, color: Colors.grey),
            ),
            Text(
              revenue,
              style: const TextStyle(fontSize: 12.0, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }

  // Low Stock Alert
  Widget _buildLowStockAlert() {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Colors.red,
                size: 20.0,
              ),
              const SizedBox(width: 8.0),
              const Text(
                'Low Stock Alert',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          _buildStockItem('1. Maggie Noodles', '45 items sold', '5 units Left'),
          const SizedBox(height: 12.0),
          _buildStockItem('2. Coca Cola', '32 items sold', '2 units Left'),
        ],
      ),
    );
  }

  // Stock item widget
  Widget _buildStockItem(String title, String items, String stock) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              color: Color(0xFF26344F),
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              items,
              style: const TextStyle(fontSize: 12.0, color: Colors.grey),
            ),
            Text(
              stock,
              style: const TextStyle(
                fontSize: 12.0,
                color: Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
