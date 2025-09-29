import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
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
  // API Data Models
  Map<String, dynamic> dashboardData = {};
  List<Map<String, dynamic>> notifications = [];
  bool isLoading = true;
  String storeName = 'A to Z Store';

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  // Dynamic greeting based on time - exactly as requested
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

  // API Endpoints for real data fetching
  Future<void> _loadDashboardData() async {
    try {
      // Replace with your actual API endpoints
      await Future.wait([
        _fetchDashboardSummary(),
        _fetchNotifications(),
        _fetchStoreInfo(),
      ]);
    } catch (e) {
      print('Error loading dashboard data: $e');
      // Load mock data as fallback
      _loadMockData();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchDashboardSummary() async {
    // API endpoint for dashboard summary
    const String apiUrl = 'https://your-api-domain.com/api/dashboard/summary';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer YOUR_TOKEN_HERE',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          dashboardData = data;
        });
      } else {
        throw Exception('Failed to load dashboard data');
      }
    } catch (e) {
      print('Dashboard API Error: $e');
      _loadMockData();
    }
  }

  Future<void> _fetchNotifications() async {
    // API endpoint for notifications
    const String apiUrl = 'https://your-api-domain.com/api/notifications';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer YOUR_TOKEN_HERE',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          notifications = List<Map<String, dynamic>>.from(
            data['notifications'] ?? [],
          );
        });
      } else {
        throw Exception('Failed to load notifications');
      }
    } catch (e) {
      print('Notifications API Error: $e');
      _loadMockNotifications();
    }
  }

  Future<void> _fetchStoreInfo() async {
    // API endpoint for store information
    const String apiUrl = 'https://your-api-domain.com/api/store/info';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer YOUR_TOKEN_HERE',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          storeName = data['store_name'] ?? 'A to Z Store';
        });
      }
    } catch (e) {
      print('Store info API Error: $e');
      // Keep default store name
    }
  }

  // Mock data for development/fallback
  void _loadMockData() {
    dashboardData = {
      'todaysSales': '2,XXXX',
      'pendingPayments': 924,
      'lowStockItems': 6,
      'lowStockAlert': {
        'count': 6,
        'message': '6 items are running low on stock',
      },
      'paymentReminders': {'count': 2, 'message': '2 payments are pending'},
    };
  }

  void _loadMockNotifications() {
    notifications = [
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // Header with exact gradient and styling
            _buildHeader(),
            // Main content area - overlapping the header
            Expanded(child: SingleChildScrollView(child: _buildMainContent())),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: widget.currentIndex,
        onTap: widget.onNavigationTap,
      ),
    );
  }

  // Header - exact pixel match to design
  Widget _buildHeader() {
    return Container(
      height: 240.0, // Restoring proper header height
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF4A6FA5), // Top blue color
            Color(0xFF2D4A73), // Bottom blue color
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20.0), // Status bar spacing
            // Top row with greeting and icons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting and store name
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _greeting,
                        style: const TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        storeName,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFFE8E8E8),
                        ),
                      ),
                    ],
                  ),
                ),
                // Header icons - exact positioning
                Row(
                  children: [
                    _buildHeaderIcon(Icons.language, () {}),
                    const SizedBox(width: 16.0),
                    _buildHeaderIcon(Icons.notifications_outlined, () {}),
                    const SizedBox(width: 16.0),
                    _buildHeaderIcon(Icons.account_circle, () {}),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Header icon - exact styling
  Widget _buildHeaderIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40.0,
        height: 40.0,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Icon(icon, color: Colors.white, size: 22.0),
      ),
    );
  }

  // Main content - exact pixel match with proper overlap
  Widget _buildMainContent() {
    return Transform.translate(
      offset: const Offset(0, -40.0), // Negative translate for overlap effect
      child: Container(
        margin: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 24.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10.0,
              spreadRadius: 0.0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Today's Sales section - exact match
              _buildTodaysSales(),
              const SizedBox(height: 32.0),
              // Summary cards row - exact positioning
              _buildSummaryCards(),
              const SizedBox(height: 32.0),
              // Alert cards - exact styling
              _buildAlertCards(),
              const SizedBox(height: 32.0),
              // Notifications section - exact match
              _buildNotificationsSection(),
              const SizedBox(height: 24.0), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }

  // Today's Sales - exact pixel match
  Widget _buildTodaysSales() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 24.0,
                  height: 24.0,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: const Icon(
                    Icons.trending_up,
                    color: Colors.white,
                    size: 16.0,
                  ),
                ),
                const SizedBox(width: 12.0),
                const Text(
                  "Today's Sales",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
              ],
            ),
            Container(
              width: 40.0,
              height: 40.0,
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B35), // Orange color from image
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 20.0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20.0),
        // Sales amount - exact styling
        Row(
          children: [
            const Text(
              '₹ ',
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2D3748),
              ),
            ),
            Text(
              isLoading
                  ? 'Loading...'
                  : (dashboardData['todaysSales']?.toString() ?? '2,XXXX'),
              style: const TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2D3748),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Summary cards - exact pixel match
  Widget _buildSummaryCards() {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            icon: Icons.currency_rupee,
            iconColor: const Color(0xFFE91E63), // Pink color from image
            title: 'Pending Payments',
            value: isLoading
                ? 'Loading...'
                : '₹ ${dashboardData['pendingPayments']?.toString() ?? '924'}',
            valueColor: const Color(0xFFE91E63),
          ),
        ),
        const SizedBox(width: 20.0), // Exact spacing
        Expanded(
          child: _buildSummaryCard(
            icon: Icons.inventory_2_outlined,
            iconColor: const Color(0xFF2D4A73), // Dark blue from header
            title: 'Low Stock items',
            value: isLoading
                ? 'Loading...'
                : (dashboardData['lowStockItems']?.toString() ?? '6'),
            valueColor: const Color(0xFF2D4A73),
          ),
        ),
      ],
    );
  }

  // Individual summary card - exact styling
  Widget _buildSummaryCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required Color valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(20.0), // Exact padding
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFC), // Exact background color
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        children: [
          // Icon with circular background
          Container(
            width: 48.0,
            height: 48.0,
            decoration: BoxDecoration(
              color: iconColor,
              borderRadius: BorderRadius.circular(24.0),
            ),
            child: Icon(icon, color: Colors.white, size: 24.0),
          ),
          const SizedBox(height: 16.0),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              color: Color(0xFF718096),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8.0),
          Text(
            value,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
              color: valueColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Alert cards - exact styling from image
  Widget _buildAlertCards() {
    return Column(
      children: [
        _buildAlertCard(
          icon: Icons.warning,
          iconColor: const Color(0xFFFF6B35), // Orange color
          title: 'Low Stock Alert',
          subtitle: isLoading
              ? 'Loading...'
              : (dashboardData['lowStockAlert']?['message'] ??
                    '6 items are running low on stock'),
        ),
        const SizedBox(height: 16.0),
        _buildAlertCard(
          icon: Icons.notifications_outlined,
          iconColor: const Color(0xFFFF6B35), // Orange color
          title: 'Payments Reminders',
          subtitle: isLoading
              ? 'Loading...'
              : (dashboardData['paymentReminders']?['message'] ??
                    '2 payments are pending'),
        ),
      ],
    );
  }

  // Individual alert card - exact styling
  Widget _buildAlertCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFC),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: [
          Container(
            width: 48.0,
            height: 48.0,
            decoration: BoxDecoration(
              color: iconColor,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Icon(icon, color: Colors.white, size: 24.0),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF718096),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Notifications section - exact pixel match
  Widget _buildNotificationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          children: [
            Container(
              width: 32.0,
              height: 32.0,
              decoration: BoxDecoration(
                color: const Color(0xFF2D4A73),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: const Icon(
                Icons.notifications,
                color: Colors.white,
                size: 18.0,
              ),
            ),
            const SizedBox(width: 12.0),
            const Text(
              'Notifications',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3748),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20.0),
        // Notification items
        if (isLoading)
          const Center(child: CircularProgressIndicator())
        else
          ...notifications
              .map(
                (notification) => Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: _buildNotificationCard(notification),
                ),
              )
              .toList(),
      ],
    );
  }

  // Individual notification card - exact styling
  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFC),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: [
          Container(
            width: 48.0,
            height: 48.0,
            decoration: BoxDecoration(
              color: _getNotificationIconColor(notification['type']),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Icon(
              _getNotificationIcon(notification['icon']),
              color: Colors.white,
              size: 24.0,
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification['title'] ?? '',
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  notification['time'] ?? '',
                  style: const TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF718096),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12.0),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 6.0,
            ),
            decoration: BoxDecoration(
              color: _getTagColor(notification['tagColor']),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Text(
              notification['tag'] ?? '',
              style: const TextStyle(
                fontSize: 11.0,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods for notification styling
  IconData _getNotificationIcon(String? iconType) {
    switch (iconType) {
      case 'person_add':
        return Icons.person_add;
      case 'warning':
        return Icons.warning;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationIconColor(String? type) {
    switch (type) {
      case 'customer_added':
        return const Color(0xFFFF6B35);
      case 'stock_alert':
        return const Color(0xFFFF6B35);
      default:
        return const Color(0xFF2D4A73);
    }
  }

  Color _getTagColor(String? color) {
    switch (color) {
      case 'green':
        return const Color(0xFF38A169);
      case 'orange':
        return const Color(0xFFFF6B35);
      default:
        return const Color(0xFF2D4A73);
    }
  }
}
