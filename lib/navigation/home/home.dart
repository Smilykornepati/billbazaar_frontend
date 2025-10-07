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
    'todaysSales': '2,XXXX',
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
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: _buildMainContent(),
            ),
          ),
        ],
      ),
      // No FloatingActionButton, matches the bottom nav in the image
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: widget.currentIndex,
        onTap: widget.onNavigationTap,
      ),
    );
  }

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
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
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
                          style: const TextStyle(
                            fontSize: 28, // Image accurate, was 32
                            fontWeight: FontWeight.w700, // heavier
                            color: Colors.white,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          storeName,
                          style: const TextStyle(
                            fontSize: 15,
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
                      _buildHeaderIcon(Icons.language),
                      const SizedBox(width: 16),
                      _buildHeaderIcon(Icons.notifications_outlined),
                      const SizedBox(width: 16),
                      _buildHeaderIcon(Icons.account_circle),
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

  Widget _buildHeaderIcon(IconData icon) {
    return Container(
      width: 38, // adjusted for image
      height: 38,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Color(0xFF26344F), size: 20),
    );
  }

  Widget _buildMainContent() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTodaysSales(),
            const SizedBox(height: 18),
            _buildSummaryCards(),
            const SizedBox(height: 18),
            _buildAlertCards(),
            const SizedBox(height: 20),
            _buildNotificationsSection(),
            const SizedBox(height: 70),
          ],
        ),
      ),
    );
  }

  Widget _buildTodaysSales() {
    return Container(
      padding: const EdgeInsets.all(20),
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
                    style: const TextStyle(
                      fontSize: 16, // image accurate
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F1F1F),
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.trending_up,
                    color: Color(0xFF10B981),
                    size: 22,
                  ),
                ],
              ),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF805D),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '₹ ',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF10B981),
                  height: 1.1,
                ),
              ),
              Text(
                dashboardData['todaysSales']?.toString() ?? '2, XXXX',
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F1F1F),
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
            value: '₹ ${dashboardData['pendingPayments']?.toString() ?? '924'}',
            valueColor: const Color(0xFFE91E63),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard(
            icon: Icons.inventory_2_outlined,
            iconColor: const Color(0xFF26344F),
            title: 'Low Stock items',
            value: dashboardData['lowStockItems']?.toString() ?? '6',
            valueColor: const Color(0xFF26344F),
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
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: Color(0xFF6B7280),
              height: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 17,
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
