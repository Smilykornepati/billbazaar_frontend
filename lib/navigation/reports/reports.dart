import 'package:flutter/material.dart';
import '../navigation.dart';

class ReportsScreen extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onNavigationTap;

  const ReportsScreen({
    super.key,
    required this.currentIndex,
    required this.onNavigationTap,
  });

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  int _selectedTabIndex = 0;
  final List<String> _tabs = ['Overview', 'Sales', 'Inventory', 'Customer'];
  String _selectedDate = 'Today';
  bool _isLoading = false;
  
  // Dynamic data that changes based on date selection
  Map<String, dynamic> _reportData = {
    'totalSales': 45250,
    'totalOrders': 125,
    'avgOrderValue': 362,
    'profit': 8250,
    'topProducts': [
      {'name': 'Maggie Noodles', 'sold': 45, 'revenue': 900},
      {'name': 'Coca Cola', 'sold': 32, 'revenue': 1280},
      {'name': 'Parle-G', 'sold': 28, 'revenue': 280},
    ],
    'customerData': {
      'newCustomers': 15,
      'returningCustomers': 42,
      'totalCustomers': 57,
    },
    'inventoryStats': {
      'lowStock': 6,
      'outOfStock': 2,
      'wellStocked': 120,
    }
  };

  @override
  void initState() {
    super.initState();
    _refreshReportData();
  }

  // Simulate refreshing report data
  Future<void> _refreshReportData() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      // Simulate different data based on date selection
      final multiplier = _selectedDate == 'Today' ? 1.0 : 
                       _selectedDate == 'This Week' ? 7.0 : 
                       _selectedDate == 'This Month' ? 30.0 : 365.0;
      
      _reportData = {
        'totalSales': (45250 * multiplier).round(),
        'totalOrders': (125 * multiplier).round(),
        'avgOrderValue': 362,
        'profit': (8250 * multiplier).round(),
        'topProducts': [
          {'name': 'Maggie Noodles', 'sold': (45 * multiplier).round(), 'revenue': (900 * multiplier).round()},
          {'name': 'Coca Cola', 'sold': (32 * multiplier).round(), 'revenue': (1280 * multiplier).round()},
          {'name': 'Parle-G', 'sold': (28 * multiplier).round(), 'revenue': (280 * multiplier).round()},
        ],
        'customerData': {
          'newCustomers': (15 * multiplier).round(),
          'returningCustomers': (42 * multiplier).round(),
          'totalCustomers': (57 * multiplier).round(),
        },
        'inventoryStats': {
          'lowStock': 6,
          'outOfStock': 2,
          'wellStocked': 120,
        }
      };
      _isLoading = false;
    });
  }

  // Export functionality
  void _exportReport(String format) {
    setState(() {
      _isLoading = true;
    });
    
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Report exported as $format successfully!'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // Header with title and export buttons
            _buildHeader(),
            // Date filter and tabs
            _buildFilterAndTabs(),
            // Main content area - scrollable
            Expanded(
              child: _isLoading 
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF5777B5),
                      ),
                    )
                  : SingleChildScrollView(
                      child: _buildMainContent(),
                    ),
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

  // Header with title and export buttons
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
                  const Expanded(
                    child: Text(
                      'Reports',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                  // Export buttons - responsive layout
                  if (isSmallScreen) ...[
                    // For small screens, use icon-only buttons
                    _buildExportButton('', Icons.picture_as_pdf, () => _exportReport('PDF'), iconOnly: true),
                    const SizedBox(width: 6),
                    _buildExportButton('', Icons.description, () => _exportReport('CSV'), iconOnly: true),
                  ] else ...[
                    // For larger screens, use full text buttons
                    _buildExportButton('Export PDF', Icons.download, () => _exportReport('PDF')),
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

  // Export button widget
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
                  fontSize: 11.0,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Date filter and tabs section
  Widget _buildFilterAndTabs() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Date filter
          Row(
            children: [
              const Icon(
                Icons.calendar_today,
                color: Color(0xFF26344F),
                size: 20.0,
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedDate,
                    isExpanded: true,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF26344F),
                    ),
                    items: [
                      'Today',
                      'Yesterday',
                      'This Week',
                      'This Month',
                      'This Year',
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedDate = newValue;
                        });
                        _refreshReportData(); // Refresh data when date changes
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          // Tab selector
          LayoutBuilder(
            builder: (context, constraints) {
              final isSmallScreen = constraints.maxWidth < 400;
              
              return Row(
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
                        padding: EdgeInsets.symmetric(
                          vertical: isSmallScreen ? 10.0 : 12.0,
                          horizontal: 4.0,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF5777B5) : Colors.transparent,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          tab,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: isSmallScreen ? 12.0 : 14.0,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            color: isSelected ? Colors.white : const Color(0xFF6B7280),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  // Main content based on selected tab
  Widget _buildMainContent() {
    switch (_selectedTabIndex) {
      case 0:
        return _buildOverviewContent();
      case 1:
        return _buildSalesContent();
      case 2:
        return _buildInventoryContent();
      case 3:
        return _buildCustomerContent();
      default:
        return _buildOverviewContent();
    }
  }

  // Overview tab content
  Widget _buildOverviewContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Key metrics cards
          _buildMetricsGrid(),
          const SizedBox(height: 20),
          // Charts section
          _buildChartsSection(),
          const SizedBox(height: 20),
          // Top products
          _buildTopProductsSection(),
        ],
      ),
    );
  }

  // Key metrics grid
  Widget _buildMetricsGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth < 600 ? 2 : 4;
        final aspectRatio = constraints.maxWidth < 400 ? 1.3 : 1.5;
        
        return GridView.count(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: constraints.maxWidth < 400 ? 12 : 16,
          mainAxisSpacing: constraints.maxWidth < 400 ? 12 : 16,
          childAspectRatio: aspectRatio,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildMetricCard(
              'Total Sales',
              '₹${_reportData['totalSales']}',
              Icons.trending_up,
              const Color(0xFF10B981),
            ),
            _buildMetricCard(
              'Total Orders',
              '${_reportData['totalOrders']}',
              Icons.shopping_cart,
              const Color(0xFF5777B5),
            ),
            _buildMetricCard(
              'Avg Order Value',
              '₹${_reportData['avgOrderValue']}',
              Icons.attach_money,
              const Color(0xFFFF805D),
            ),
            _buildMetricCard(
              'Profit',
              '₹${_reportData['profit']}',
              Icons.account_balance_wallet,
              const Color(0xFFE91E63),
            ),
          ],
        );
      },
    );
  }

  // Individual metric card
  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 120;
        
        return Container(
          padding: EdgeInsets.all(isSmallScreen ? 8 : 16),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    icon, 
                    color: color, 
                    size: isSmallScreen ? 18 : 24
                  ),
                  const Spacer(),
                  Container(
                    padding: EdgeInsets.all(isSmallScreen ? 2 : 4),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_upward, 
                      color: color, 
                      size: isSmallScreen ? 12 : 16
                    ),
                  ),
                ],
              ),
              SizedBox(height: isSmallScreen ? 6 : 12),
              Flexible(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              SizedBox(height: isSmallScreen ? 2 : 4),
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 9 : 12,
                    color: const Color(0xFF6B7280),
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Charts section
  Widget _buildChartsSection() {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sales Trend',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF26344F),
            ),
          ),
          const SizedBox(height: 16),
          // Simplified chart representation
          Container(
            height: 200,
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(7, (index) {
                      final heights = [0.3, 0.6, 0.4, 0.8, 0.5, 0.9, 0.7];
                      return Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 150 * heights[index],
                          decoration: BoxDecoration(
                            color: const Color(0xFF5777B5),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                      .map((day) => Expanded(
                            child: Text(
                              day,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 10,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Top products section
  Widget _buildTopProductsSection() {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Top Selling Products',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF26344F),
            ),
          ),
          const SizedBox(height: 16),
          ...(_reportData['topProducts'] as List).map((product) {
            return _buildProductRow(
              product['name'],
              '${product['sold']} sold',
              '₹${product['revenue']}',
            );
          }).toList(),
        ],
      ),
    );
  }

  // Product row widget
  Widget _buildProductRow(String name, String quantity, String revenue) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isSmallScreen = constraints.maxWidth < 400;
          
          return Row(
            children: [
              Container(
                width: isSmallScreen ? 36 : 40,
                height: isSmallScreen ? 36 : 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.inventory_2,
                  color: const Color(0xFF26344F),
                  size: isSmallScreen ? 18 : 20,
                ),
              ),
              SizedBox(width: isSmallScreen ? 8 : 12),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 13 : 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF26344F),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      quantity,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 11 : 12,
                        color: const Color(0xFF6B7280),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Text(
                  revenue,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 13 : 14,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF10B981),
                  ),
                  textAlign: TextAlign.end,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Sales tab content
  Widget _buildSalesContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
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
                const Text(
                  'Sales Analytics',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF26344F),
                  ),
                ),
                const SizedBox(height: 20),
                _buildSalesMetrics(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSalesMetrics() {
    return Column(
      children: [
        _buildSalesRow('Daily Revenue', '₹${(_reportData['totalSales'] / 30).round()}'),
        _buildSalesRow('Weekly Revenue', '₹${(_reportData['totalSales'] / 4).round()}'),
        _buildSalesRow('Monthly Revenue', '₹${_reportData['totalSales']}'),
        _buildSalesRow('Growth Rate', '+12.5%'),
      ],
    );
  }

  Widget _buildSalesRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isSmallScreen = constraints.maxWidth < 400;
          
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    color: const Color(0xFF6B7280),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Flexible(
                flex: 1,
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF26344F),
                  ),
                  textAlign: TextAlign.end,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Inventory tab content
  Widget _buildInventoryContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildInventoryStats(),
        ],
      ),
    );
  }

  Widget _buildInventoryStats() {
    final stats = _reportData['inventoryStats'] as Map<String, dynamic>;
    return Container(
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Inventory Status',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF26344F),
            ),
          ),
          const SizedBox(height: 20),
          _buildInventoryRow('Low Stock Items', '${stats['lowStock']}', const Color(0xFFFF805D)),
          _buildInventoryRow('Out of Stock', '${stats['outOfStock']}', const Color(0xFFE91E63)),
          _buildInventoryRow('Well Stocked', '${stats['wellStocked']}', const Color(0xFF10B981)),
        ],
      ),
    );
  }

  Widget _buildInventoryRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isSmallScreen = constraints.maxWidth < 400;
          
          return Row(
            children: [
              Container(
                width: isSmallScreen ? 10 : 12,
                height: isSmallScreen ? 10 : 12,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: isSmallScreen ? 8 : 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    color: const Color(0xFF6B7280),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: isSmallScreen ? 14 : 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Customer tab content
  Widget _buildCustomerContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildCustomerStats(),
        ],
      ),
    );
  }

  Widget _buildCustomerStats() {
    final customerData = _reportData['customerData'] as Map<String, dynamic>;
    return Container(
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Customer Analytics',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF26344F),
            ),
          ),
          const SizedBox(height: 20),
          _buildCustomerRow('New Customers', '${customerData['newCustomers']}'),
          _buildCustomerRow('Returning Customers', '${customerData['returningCustomers']}'),
          _buildCustomerRow('Total Customers', '${customerData['totalCustomers']}'),
          _buildCustomerRow('Customer Retention', '73.7%'),
        ],
      ),
    );
  }

  Widget _buildCustomerRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF6B7280),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF26344F),
            ),
          ),
        ],
      ),
    );
  }
}