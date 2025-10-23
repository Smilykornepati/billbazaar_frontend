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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final isTablet = screenWidth > 600;
          
          return SafeArea(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isTablet ? 1000 : double.infinity,
              ),
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
          );
        },
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
          padding: EdgeInsets.fromLTRB(
            MediaQuery.of(context).size.width < 360 ? 16 : 20,
            MediaQuery.of(context).size.width < 360 ? 16 : 18,
            MediaQuery.of(context).size.width < 360 ? 16 : 20,
            MediaQuery.of(context).size.width < 360 ? 20 : 24,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isVerySmallScreen = constraints.maxWidth < 320;
              final isSmallScreen = constraints.maxWidth < 400;
              
              return Row(
                children: [
                  Expanded(
                    child: Text(
                      'Reports',
                      style: TextStyle(
                        fontSize: isVerySmallScreen ? 16.0 : isSmallScreen ? 17.0 : 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                  // Export buttons - responsive layout
                  if (isVerySmallScreen) ...[
                    // For very small screens, use compact icon-only buttons
                    _buildExportButton('', Icons.picture_as_pdf, () => _exportReport('PDF'), iconOnly: true, compact: true),
                    const SizedBox(width: 4),
                    _buildExportButton('', Icons.description, () => _exportReport('CSV'), iconOnly: true, compact: true),
                  ] else if (isSmallScreen) ...[
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
  Widget _buildExportButton(String text, IconData icon, VoidCallback onTap, {bool iconOnly = false, bool compact = false}) {
    return GestureDetector(
      onTap: _isLoading ? null : onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 6.0 : (iconOnly ? 8.0 : 12.0), 
          vertical: compact ? 4.0 : 6.0,
        ),
        decoration: BoxDecoration(
          color: _isLoading 
              ? Colors.grey.withOpacity(0.3)
              : Colors.white.withOpacity(0.20),
          borderRadius: BorderRadius.circular(compact ? 6.0 : 8.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_isLoading && text.contains('PDF'))
              SizedBox(
                width: compact ? 10 : 12,
                height: compact ? 10 : 12,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            else if (_isLoading && text.contains('CSV'))
              SizedBox(
                width: compact ? 10 : 12,
                height: compact ? 10 : 12,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            else
              Icon(icon, color: Colors.white, size: compact ? 12.0 : 14.0),
            if (!iconOnly) ...[
              SizedBox(width: compact ? 3.0 : 4.0),
              Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: compact ? 10.0 : 11.0,
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
      padding: EdgeInsets.all(MediaQuery.of(context).size.width < 360 ? 12.0 : 16.0),
      child: Column(
        children: [
          // Date filter
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                color: const Color(0xFF26344F),
                size: MediaQuery.of(context).size.width < 360 ? 18.0 : 20.0,
              ),
              SizedBox(width: MediaQuery.of(context).size.width < 360 ? 8.0 : 12.0),
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedDate,
                    isExpanded: true,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width < 360 ? 14.0 : 16.0,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF26344F),
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
          SizedBox(height: MediaQuery.of(context).size.width < 360 ? 12.0 : 16.0),
          // Tab selector - Enhanced for small screens
          LayoutBuilder(
            builder: (context, constraints) {
              final isVerySmallScreen = constraints.maxWidth < 320;
              final isSmallScreen = constraints.maxWidth < 400;
              
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _tabs.asMap().entries.map((entry) {
                    int index = entry.key;
                    String tab = entry.value;
                    bool isSelected = _selectedTabIndex == index;
                    
                    return Container(
                      width: isVerySmallScreen ? 70 : (isSmallScreen ? 80 : null),
                      margin: EdgeInsets.only(right: isVerySmallScreen ? 4.0 : 8.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedTabIndex = index;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: isVerySmallScreen ? 8.0 : (isSmallScreen ? 10.0 : 12.0),
                            horizontal: isVerySmallScreen ? 6.0 : (isSmallScreen ? 8.0 : 12.0),
                          ),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF5777B5) : Colors.transparent,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            tab,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: isVerySmallScreen ? 10.0 : (isSmallScreen ? 12.0 : 14.0),
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                              color: isSelected ? Colors.white : const Color(0xFF6B7280),
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isVerySmallScreen = screenWidth < 320;
    final isSmallScreen = screenWidth < 400;
    
    double padding = isVerySmallScreen ? 12.0 : (isSmallScreen ? 14.0 : 16.0);
    double spacing = isVerySmallScreen ? 16 : (isSmallScreen ? 18 : 20);
    
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Key metrics cards
          _buildMetricsGrid(),
          SizedBox(height: spacing),
          // Charts section
          _buildChartsSection(),
          SizedBox(height: spacing),
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
        final screenWidth = MediaQuery.of(context).size.width;
        final isVerySmallScreen = screenWidth < 320;
        final isSmallScreen = screenWidth < 400;
        final isTablet = screenWidth >= 600;
        
        // Dynamic grid layout based on screen size
        int crossAxisCount;
        double aspectRatio;
        double spacing;
        
        if (isVerySmallScreen) {
          crossAxisCount = 1; // Single column for very small screens
          aspectRatio = 3.0;
          spacing = 8;
        } else if (isSmallScreen) {
          crossAxisCount = 2;
          aspectRatio = 1.4;
          spacing = 10;
        } else if (isTablet) {
          crossAxisCount = 4;
          aspectRatio = 1.3;
          spacing = 16;
        } else {
          crossAxisCount = 2;
          aspectRatio = 1.5;
          spacing = 12;
        }
        
        return GridView.count(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
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
        final screenWidth = MediaQuery.of(context).size.width;
        final isVerySmallScreen = screenWidth < 320;
        final isSmallScreen = screenWidth < 400;
        
        // Determine if this is a single-column layout (very small screen)
        final isSingleColumn = constraints.maxWidth > screenWidth * 0.8;
        
        return Container(
          padding: EdgeInsets.all(
            isVerySmallScreen ? (isSingleColumn ? 16 : 8) : (isSmallScreen ? 12 : 16)
          ),
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
          child: isSingleColumn 
              ? _buildSingleColumnCard(title, value, icon, color, isVerySmallScreen)
              : _buildRegularCard(title, value, icon, color, isVerySmallScreen, isSmallScreen),
        );
      },
    );
  }

  // Single column layout for very small screens
  Widget _buildSingleColumnCard(String title, String value, IconData icon, Color color, bool isVerySmallScreen) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(isVerySmallScreen ? 8 : 10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon, 
            color: color, 
            size: isVerySmallScreen ? 20 : 24
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: isVerySmallScreen ? 12 : 14,
                  color: const Color(0xFF6B7280),
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: isVerySmallScreen ? 16 : 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(isVerySmallScreen ? 3 : 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.arrow_upward, 
            color: color, 
            size: isVerySmallScreen ? 12 : 14
          ),
        ),
      ],
    );
  }

  // Regular column layout
  Widget _buildRegularCard(String title, String value, IconData icon, Color color, bool isVerySmallScreen, bool isSmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon, 
              color: color, 
              size: isVerySmallScreen ? 16 : (isSmallScreen ? 18 : 24)
            ),
            const Spacer(),
            Container(
              padding: EdgeInsets.all(isVerySmallScreen ? 2 : (isSmallScreen ? 3 : 4)),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_upward, 
                color: color, 
                size: isVerySmallScreen ? 10 : (isSmallScreen ? 12 : 16)
              ),
            ),
          ],
        ),
        SizedBox(height: isVerySmallScreen ? 8 : (isSmallScreen ? 10 : 12)),
        Flexible(
          child: Text(
            value,
            style: TextStyle(
              fontSize: isVerySmallScreen ? 14 : (isSmallScreen ? 16 : 20),
              fontWeight: FontWeight.bold,
              color: color,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        SizedBox(height: isVerySmallScreen ? 4 : 6),
        Flexible(
          child: Text(
            title,
            style: TextStyle(
              fontSize: isVerySmallScreen ? 10 : (isSmallScreen ? 11 : 12),
              color: const Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      ],
    );
  }

  // Charts section
  Widget _buildChartsSection() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isVerySmallScreen = screenWidth < 320;
    final isSmallScreen = screenWidth < 400;
    
    return Container(
      padding: EdgeInsets.all(isVerySmallScreen ? 12 : (isSmallScreen ? 14 : 16)),
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
          Text(
            'Sales Trend',
            style: TextStyle(
              fontSize: isVerySmallScreen ? 16 : (isSmallScreen ? 17 : 18),
              fontWeight: FontWeight.bold,
              color: const Color(0xFF26344F),
            ),
          ),
          SizedBox(height: isVerySmallScreen ? 12 : 16),
          // Simplified chart representation
          SizedBox(
            height: isVerySmallScreen ? 160 : (isSmallScreen ? 180 : 200),
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(7, (index) {
                      final heights = [0.3, 0.6, 0.4, 0.8, 0.5, 0.9, 0.7];
                      return Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: isVerySmallScreen ? 2 : 4),
                          height: (isVerySmallScreen ? 120 : 150) * heights[index],
                          decoration: BoxDecoration(
                            color: const Color(0xFF5777B5),
                            borderRadius: BorderRadius.circular(isVerySmallScreen ? 2 : 4),
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
                              style: TextStyle(
                                fontSize: isVerySmallScreen ? 9 : 10,
                                color: const Color(0xFF6B7280),
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isVerySmallScreen = screenWidth < 320;
    final isSmallScreen = screenWidth < 400;
    
    return Container(
      padding: EdgeInsets.all(isVerySmallScreen ? 12 : (isSmallScreen ? 14 : 16)),
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
          Text(
            'Top Selling Products',
            style: TextStyle(
              fontSize: isVerySmallScreen ? 16 : (isSmallScreen ? 17 : 18),
              fontWeight: FontWeight.bold,
              color: const Color(0xFF26344F),
            ),
          ),
          SizedBox(height: isVerySmallScreen ? 12 : 16),
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
      padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width < 360 ? 6 : 8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = MediaQuery.of(context).size.width;
          final isVerySmallScreen = screenWidth < 320;
          final isSmallScreen = screenWidth < 400;
          
          return Row(
            children: [
              Container(
                width: isVerySmallScreen ? 32 : (isSmallScreen ? 36 : 40),
                height: isVerySmallScreen ? 32 : (isSmallScreen ? 36 : 40),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.inventory_2,
                  color: const Color(0xFF26344F),
                  size: isVerySmallScreen ? 16 : (isSmallScreen ? 18 : 20),
                ),
              ),
              SizedBox(width: isVerySmallScreen ? 8 : (isSmallScreen ? 10 : 12)),
              Expanded(
                flex: isVerySmallScreen ? 2 : 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: isVerySmallScreen ? 12 : (isSmallScreen ? 13 : 14),
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF26344F),
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    if (!isVerySmallScreen) ...[
                      const SizedBox(height: 2),
                      Text(
                        quantity,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 10 : 12,
                          color: const Color(0xFF6B7280),
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      revenue,
                      style: TextStyle(
                        fontSize: isVerySmallScreen ? 12 : (isSmallScreen ? 13 : 14),
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF10B981),
                      ),
                      textAlign: TextAlign.end,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    if (isVerySmallScreen) ...[
                      const SizedBox(height: 2),
                      Text(
                        quantity,
                        style: const TextStyle(
                          fontSize: 9,
                          color: Color(0xFF6B7280),
                        ),
                        textAlign: TextAlign.end,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ],
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isVerySmallScreen = screenWidth < 320;
    final isSmallScreen = screenWidth < 400;
    
    return Padding(
      padding: EdgeInsets.all(isVerySmallScreen ? 12.0 : (isSmallScreen ? 14.0 : 16.0)),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(isVerySmallScreen ? 16 : (isSmallScreen ? 18 : 20)),
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
                Text(
                  'Sales Analytics',
                  style: TextStyle(
                    fontSize: isVerySmallScreen ? 18 : (isSmallScreen ? 19 : 20),
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF26344F),
                  ),
                ),
                SizedBox(height: isVerySmallScreen ? 16 : (isSmallScreen ? 18 : 20)),
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
      padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width < 360 ? 10 : 12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = MediaQuery.of(context).size.width;
          final isVerySmallScreen = screenWidth < 320;
          final isSmallScreen = screenWidth < 400;
          
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: isVerySmallScreen ? 3 : 2,
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: isVerySmallScreen ? 13 : (isSmallScreen ? 14 : 16),
                    color: const Color(0xFF6B7280),
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              Flexible(
                flex: isVerySmallScreen ? 2 : 1,
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: isVerySmallScreen ? 13 : (isSmallScreen ? 14 : 16),
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF26344F),
                  ),
                  textAlign: TextAlign.end,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isVerySmallScreen = screenWidth < 320;
    final isSmallScreen = screenWidth < 400;
    
    return Padding(
      padding: EdgeInsets.all(isVerySmallScreen ? 12.0 : (isSmallScreen ? 14.0 : 16.0)),
      child: Column(
        children: [
          _buildInventoryStats(),
        ],
      ),
    );
  }

  Widget _buildInventoryStats() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isVerySmallScreen = screenWidth < 320;
    final isSmallScreen = screenWidth < 400;
    final stats = _reportData['inventoryStats'] as Map<String, dynamic>;
    
    return Container(
      padding: EdgeInsets.all(isVerySmallScreen ? 16 : (isSmallScreen ? 18 : 20)),
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
          Text(
            'Inventory Status',
            style: TextStyle(
              fontSize: isVerySmallScreen ? 18 : (isSmallScreen ? 19 : 20),
              fontWeight: FontWeight.bold,
              color: const Color(0xFF26344F),
            ),
          ),
          SizedBox(height: isVerySmallScreen ? 16 : (isSmallScreen ? 18 : 20)),
          _buildInventoryRow('Low Stock Items', '${stats['lowStock']}', const Color(0xFFFF805D)),
          _buildInventoryRow('Out of Stock', '${stats['outOfStock']}', const Color(0xFFE91E63)),
          _buildInventoryRow('Well Stocked', '${stats['wellStocked']}', const Color(0xFF10B981)),
        ],
      ),
    );
  }

  Widget _buildInventoryRow(String label, String value, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width < 360 ? 10 : 12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = MediaQuery.of(context).size.width;
          final isVerySmallScreen = screenWidth < 320;
          final isSmallScreen = screenWidth < 400;
          
          return Row(
            children: [
              Container(
                width: isVerySmallScreen ? 8 : (isSmallScreen ? 10 : 12),
                height: isVerySmallScreen ? 8 : (isSmallScreen ? 10 : 12),
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: isVerySmallScreen ? 8 : (isSmallScreen ? 10 : 12)),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: isVerySmallScreen ? 13 : (isSmallScreen ? 14 : 16),
                    color: const Color(0xFF6B7280),
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: isVerySmallScreen ? 13 : (isSmallScreen ? 14 : 16),
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isVerySmallScreen = screenWidth < 320;
    final isSmallScreen = screenWidth < 400;
    
    return Padding(
      padding: EdgeInsets.all(isVerySmallScreen ? 12.0 : (isSmallScreen ? 14.0 : 16.0)),
      child: Column(
        children: [
          _buildCustomerStats(),
        ],
      ),
    );
  }

  Widget _buildCustomerStats() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isVerySmallScreen = screenWidth < 320;
    final isSmallScreen = screenWidth < 400;
    final customerData = _reportData['customerData'] as Map<String, dynamic>;
    
    return Container(
      padding: EdgeInsets.all(isVerySmallScreen ? 16 : (isSmallScreen ? 18 : 20)),
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
          Text(
            'Customer Analytics',
            style: TextStyle(
              fontSize: isVerySmallScreen ? 18 : (isSmallScreen ? 19 : 20),
              fontWeight: FontWeight.bold,
              color: const Color(0xFF26344F),
            ),
          ),
          SizedBox(height: isVerySmallScreen ? 16 : (isSmallScreen ? 18 : 20)),
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
      padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width < 360 ? 10 : 12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = MediaQuery.of(context).size.width;
          final isVerySmallScreen = screenWidth < 320;
          final isSmallScreen = screenWidth < 400;
          
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: isVerySmallScreen ? 3 : 2,
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: isVerySmallScreen ? 13 : (isSmallScreen ? 14 : 16),
                    color: const Color(0xFF6B7280),
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              Flexible(
                flex: isVerySmallScreen ? 2 : 1,
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: isVerySmallScreen ? 13 : (isSmallScreen ? 14 : 16),
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF26344F),
                  ),
                  textAlign: TextAlign.end,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}