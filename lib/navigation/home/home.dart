import 'package:flutter/material.dart';
// If you have a custom navigation bar, import accordingly
import '../navigation.dart';

class HomeScreen extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onNavigationTap;

  const HomeScreen({
    super.key,
    required this.currentIndex,
    required this.onNavigationTap,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic> dashboardData = {
    'todaysSales': '15,250',
    'pendingPayments': 924,
    'lowStockItems': 6,
    'lowStockAlert': {
      'count': 6,
      'message': '6 items are running low on stock',
    },
    'paymentReminders': {'count': 2, 'message': '2 payments are pending'},
  };

  List<Map<String, dynamic>> notifications = [
    {
      'id': 1,
      'type': 'customer_added',
      'title': 'New customer Raj Kumar added',
      'time': '6 hours ago',
      'tag': 'New',
      'tagColor': 'green',
      'icon': 'person_add',
    },
    {
      'id': 2,
      'type': 'stock_alert',
      'title': 'Maggie Noddles stock is low (7 units left)',
      'time': '2 payments are pending',
      'tag': 'Alert',
      'tagColor': 'orange',
      'icon': 'warning',
    },
    {
      'id': 3,
      'type': 'customer_added',
      'title': 'New customer Suraj Kumar added',
      'time': '3 hours ago',
      'tag': 'New',
      'tagColor': 'green',
      'icon': 'person_add',
    },
  ];

  String storeName = 'A to Z Store';
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _refreshDashboardData();
  }

  // Simulate data refresh with dynamic content
  Future<void> _refreshDashboardData() async {
    if (_isRefreshing) return;
    
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      // Update with dynamic data
      final now = DateTime.now();
      final random = now.millisecond;
      
      dashboardData['todaysSales'] = '${15000 + (random % 5000)}';
      dashboardData['pendingPayments'] = 800 + (random % 300);
      dashboardData['lowStockItems'] = 3 + (random % 8);
      
      // Update notifications with timestamps
      for (var notification in notifications) {
        if (notification['type'] == 'customer_added') {
          final hours = 1 + (random % 12);
          notification['time'] = '$hours hours ago';
        }
      }
      
      _isRefreshing = false;
    });
  }

  // Navigate to inventory with low stock filter
  void _navigateToLowStockItems() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Navigating to low stock items...'),
        backgroundColor: Color(0xFFFF805D),
        duration: Duration(seconds: 2),
      ),
    );
    // TODO: Navigate to inventory screen with low stock filter
  }

  // Navigate to pending payments
  void _navigateToPendingPayments() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Navigating to pending payments...'),
        backgroundColor: Color(0xFFE91E63),
        duration: Duration(seconds: 2),
      ),
    );
    // TODO: Navigate to payments screen
  }

  // Navigate to quick bill
  void _navigateToQuickBill() {
    Navigator.pushNamed(context, '/quick-bill');
  }

  // Handle notification tap
  void _handleNotificationTap(Map<String, dynamic> notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(notification['title']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Time: ${notification['time']}'),
            const SizedBox(height: 8),
            Text('Type: ${notification['type']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle specific actions based on notification type
              if (notification['type'] == 'stock_alert') {
                _navigateToLowStockItems();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF805D),
              foregroundColor: Colors.white,
            ),
            child: const Text('Take Action'),
          ),
        ],
      ),
    );
  }

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning !';
    } else if (hour < 17) {
      return 'Good Afternoon !';
    } else {
      return 'Good Evening !';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final isSmallScreen = screenWidth < 400;
          final isTablet = screenWidth > 600;

          return Column(
            children: [
              _buildHeader(screenWidth, isSmallScreen, isTablet),
              Expanded(
                child: SingleChildScrollView(
                  child: _buildMainContent(screenWidth, isSmallScreen, isTablet),
                ),
              ),
            ],
          );
        },
      ),
      // No FloatingActionButton, matches the bottom nav in the image
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: widget.currentIndex,
        onTap: widget.onNavigationTap,
      ),
    );
  }

  Widget _buildHeader(double screenWidth, bool isSmallScreen, bool isTablet) {
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
            isSmallScreen ? 16 : 18,
            isSmallScreen ? 16 : 20,
            isSmallScreen ? 24 : 30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _greeting,
                          style: TextStyle(
                            fontSize: isSmallScreen ? 24 : (isTablet ? 32 : 28),
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            height: 1.1,
                          ),
                        ),
                        SizedBox(height: isSmallScreen ? 2 : 4),
                        Text(
                          storeName,
                          style: TextStyle(
                            fontSize: isSmallScreen ? 13 : 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.white70,
                            height: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      _buildHeaderIcon(Icons.language, isSmallScreen),
                      SizedBox(width: isSmallScreen ? 12 : 16),
                      _buildHeaderIcon(Icons.notifications_outlined, isSmallScreen),
                      SizedBox(width: isSmallScreen ? 12 : 16),
                      _buildHeaderIcon(Icons.account_circle, isSmallScreen),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderIcon(IconData icon, bool isSmallScreen) {
    final size = isSmallScreen ? 34.0 : 38.0;
    final iconSize = isSmallScreen ? 18.0 : 20.0;
    
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: const Color(0xFF26344F), size: iconSize),
    );
  }

  Widget _buildMainContent(double screenWidth, bool isSmallScreen, bool isTablet) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 16 : 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTodaysSales(isSmallScreen, isTablet),
            SizedBox(height: isSmallScreen ? 16 : 18),
            _buildSummaryCards(isSmallScreen, isTablet),
            SizedBox(height: isSmallScreen ? 16 : 18),
            _buildAlertCards(),
            SizedBox(height: isSmallScreen ? 18 : 20),
            _buildNotificationsSection(),
            SizedBox(height: isSmallScreen ? 60 : 70),
          ],
        ),
      ),
    );
  }

  Widget _buildTodaysSales(bool isSmallScreen, bool isTablet) {
    return GestureDetector(
      onTap: _navigateToQuickBill,
      child: Container(
        padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      "Today's Sales",
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1F1F1F),
                        height: 1.1,
                      ),
                    ),
                    SizedBox(width: isSmallScreen ? 6 : 8),
                    Icon(
                      Icons.trending_up,
                      color: const Color(0xFF10B981),
                      size: isSmallScreen ? 20 : 22,
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: _refreshDashboardData,
                  child: Container(
                    width: isSmallScreen ? 40 : 44,
                    height: isSmallScreen ? 40 : 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF805D),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: _isRefreshing
                        ? Padding(
                            padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Icon(
                            Icons.refresh,
                            color: Colors.white,
                            size: isSmallScreen ? 20 : 22,
                          ),
                  ),
                ),
              ],
            ),
            SizedBox(height: isSmallScreen ? 12 : 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '₹ ',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 28 : (isTablet ? 38 : 34),
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF10B981),
                    height: 1.1,
                  ),
                ),
                Flexible(
                  child: Text(
                    dashboardData['todaysSales']?.toString() ?? '15,250',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 28 : (isTablet ? 38 : 34),
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1F1F1F),
                      height: 1.1,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards(bool isSmallScreen, bool isTablet) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: _navigateToPendingPayments,
            child: _buildSummaryCard(
              icon: Icons.currency_rupee,
              iconColor: const Color(0xFFE91E63),
              title: 'Pending Payments',
              value: '₹ ${dashboardData['pendingPayments']?.toString() ?? '924'}',
              valueColor: const Color(0xFFE91E63),
              isSmallScreen: isSmallScreen,
            ),
          ),
        ),
        SizedBox(width: isSmallScreen ? 8 : 12),
        Expanded(
          child: GestureDetector(
            onTap: _navigateToLowStockItems,
            child: _buildSummaryCard(
              icon: Icons.inventory_2_outlined,
              iconColor: const Color(0xFF26344F),
              title: 'Low Stock items',
              value: dashboardData['lowStockItems']?.toString() ?? '6',
              valueColor: const Color(0xFF26344F),
              isSmallScreen: isSmallScreen,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required Color valueColor,
    required bool isSmallScreen,
  }) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: isSmallScreen ? 38 : 44,
            height: isSmallScreen ? 38 : 44,
            decoration: BoxDecoration(
              color: iconColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: isSmallScreen ? 18 : 22),
          ),
          SizedBox(height: isSmallScreen ? 10 : 12),
          Text(
            title,
            style: TextStyle(
              fontSize: isSmallScreen ? 10 : 11,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF6B7280),
              height: 1.2,
            ),
          ),
          SizedBox(height: isSmallScreen ? 3 : 4),
          Text(
            value,
            style: TextStyle(
              fontSize: isSmallScreen ? 15 : 17,
              fontWeight: FontWeight.w700,
              color: valueColor,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertCards() {
    return Column(
      children: [
        _buildAlertCard(
          icon: Icons.warning_amber,
          iconColor: const Color(0xFFFF805D),
          title: 'Low Stock Alert',
          subtitle: dashboardData['lowStockAlert']?['message'] ??
              '6 items are running low on stock',
        ),
        const SizedBox(height: 12),
        _buildAlertCard(
          icon: Icons.notifications_active,
          iconColor: const Color(0xFFFF805D),
          title: 'Payments Reminders',
          subtitle:
              dashboardData['paymentReminders']?['message'] ?? '2 payments are pending',
        ),
      ],
    );
  }

  Widget _buildAlertCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F1F1F),
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF6B7280),
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                color: Color(0xFF26344F),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 11),
            const Text(
              'Notifications',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F1F1F),
                height: 1.1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...notifications
            .map(
              (notification) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildNotificationCard(notification),
              ),
            )
            .toList(),
      ],
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    return GestureDetector(
      onTap: () => _handleNotificationTap(notification),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _getNotificationIconColor(notification['type']),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _getNotificationIcon(notification['icon']),
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification['title'] ?? '',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1F1F1F),
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    notification['time'] ?? '',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF6B7280),
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: _getTagColor(notification['tagColor']),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Text(
                notification['tag'] ?? '',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF6B7280),
              size: 14,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getNotificationIcon(String? iconType) {
    switch (iconType) {
      case 'person_add':
        return Icons.person_add_alt_1;
      case 'warning':
        return Icons.warning_amber;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationIconColor(String? type) {
    switch (type) {
      case 'customer_added':
        return const Color(0xFFFF805D);
      case 'stock_alert':
        return const Color(0xFFFF805D);
      default:
        return const Color(0xFF26344F);
    }
  }

  Color _getTagColor(String? color) {
    switch (color) {
      case 'green':
        return const Color(0xFF10B981);
      case 'orange':
        return const Color(0xFFFF9500);
      default:
        return const Color(0xFF26344F);
    }
  }
}
