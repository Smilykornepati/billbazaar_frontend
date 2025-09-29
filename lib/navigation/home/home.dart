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
  Map<String, dynamic> dashboardData = {};
  List<Map<String, dynamic>> notifications = [];
  bool isLoading = true;
  String storeName = 'A to Z Store';

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
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

  Future<void> _loadDashboardData() async {
    try {
      await Future.wait([
        _fetchDashboardSummary(),
        _fetchNotifications(),
        _fetchStoreInfo(),
      ]);
    } catch (e) {
      print('Error loading dashboard data: $e');
      _loadMockData();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchDashboardSummary() async {
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
    }
  }

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
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _buildHeader(),
          ),
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -30),
              child: _buildMainContent(),
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
      height: 180,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4A5C7A),
            Color(0xFF3B4A63),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 60, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _greeting,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        storeName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withOpacity(0.85),
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    _buildHeaderIcon(Icons.language_outlined),
                    const SizedBox(width: 12),
                    _buildHeaderIcon(Icons.notifications_outlined),
                    const SizedBox(width: 12),
                    _buildHeaderIcon(Icons.account_circle_outlined),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderIcon(IconData icon) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 20,
      ),
    );
  }

  Widget _buildMainContent() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTodaysSales(),
            const SizedBox(height: 24),
            _buildSummaryCards(),
            const SizedBox(height: 24),
            _buildAlertCards(),
            const SizedBox(height: 24),
            _buildNotificationsSection(),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildTodaysSales() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    "Today's Sales",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF374151),
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(
                      Icons.trending_up,
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                ],
              ),
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B35),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '₹ ',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                  height: 1.1,
                ),
              ),
              Text(
                isLoading
                    ? 'Loading...'
                    : (dashboardData['todaysSales']?.toString() ?? '2, XXXX'),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                  height: 1.1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            icon: Icons.currency_rupee,
            iconColor: const Color(0xFFE91E63),
            title: 'Pending Payments',
            value: isLoading
                ? '...'
                : '₹ ${dashboardData['pendingPayments']?.toString() ?? '924'}',
            valueColor: const Color(0xFFE91E63),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _buildSummaryCard(
            icon: Icons.inventory_2,
            iconColor: const Color(0xFF3E5A7E),
            title: 'Low Stock items',
            value: isLoading
                ? '...'
                : (dashboardData['lowStockItems']?.toString() ?? '6'),
            valueColor: const Color(0xFF3E5A7E),
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
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF6B7280),
              height: 1.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
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
          iconColor: const Color(0xFFFF6B35),
          title: 'Low Stock Alert',
          subtitle: isLoading
              ? 'Loading...'
              : (dashboardData['lowStockAlert']?['message'] ??
                  '6 items are running low on stock'),
        ),
        const SizedBox(height: 16),
        _buildAlertCard(
          icon: Icons.notifications_active,
          iconColor: const Color(0xFFFF6B35),
          title: 'Payments Reminders',
          subtitle: isLoading
              ? 'Loading...'
              : (dashboardData['paymentReminders']?['message'] ??
                  '2 payments are pending'),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF6B7280),
                    height: 1.4,
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
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Color(0xFF4A5C7A),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Notifications',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827),
                height: 1.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (isLoading)
          const Center(child: CircularProgressIndicator())
        else
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getNotificationIconColor(notification['type']),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getNotificationIcon(notification['icon']),
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification['title'] ?? '',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF111827),
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  notification['time'] ?? '',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF6B7280),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: _getTagColor(notification['tagColor']),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              notification['tag'] ?? '',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
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
        return const Color(0xFFFF6B35);
      case 'stock_alert':
        return const Color(0xFFFF6B35);
      default:
        return const Color(0xFF3E5A7E);
    }
  }

  Color _getTagColor(String? color) {
    switch (color) {
      case 'green':
        return const Color(0xFF10B981);
      case 'orange':
        return const Color(0xFFFF6B35);
      default:
        return const Color(0xFF3E5A7E);
    }
  }
}
