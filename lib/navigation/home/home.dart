import 'package:flutter/material.dart';
import '../../constants/colors.dart';
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
  // Dynamic greeting based on time
  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning!';
    } else if (hour < 17) {
      return 'Good Afternoon!';
    } else {
      return 'Good Evening!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC), // Light gray background
      body: SafeArea(
        child: Column(
          children: [
            // Header with gradient background
            _buildHeader(),
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

  // Header with gradient background and greeting
  Widget _buildHeader() {
    return Container(
      height: 200.0,
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
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status bar area
            const SizedBox(height: 10.0),
            // Greeting and store name
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _greeting,
                    style: const TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    'A to Z Store',
                    style: TextStyle(fontSize: 16.0, color: Colors.white70),
                  ),
                ],
              ),
            ),
            // Header icons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildHeaderIcon(Icons.language, () {}),
                const SizedBox(width: 16.0),
                _buildHeaderIcon(Icons.notifications_outlined, () {}),
                const SizedBox(width: 16.0),
                _buildHeaderIcon(Icons.person_outline, () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Header icon widget
  Widget _buildHeaderIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Icon(icon, color: Colors.white, size: 20.0),
      ),
    );
  }

  // Main content area
  Widget _buildMainContent() {
    return Container(
      margin: const EdgeInsets.all(20.0),
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
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Today's Sales section
              _buildTodaysSales(),
              const SizedBox(height: 24.0),
              // Summary cards
              _buildSummaryCards(),
              const SizedBox(height: 24.0),
              // Alerts section
              _buildAlertsSection(),
              const SizedBox(height: 24.0),
              // Notifications section
              _buildNotificationsSection(),
            ],
          ),
        ),
      ),
    );
  }

  // Today's Sales widget
  Widget _buildTodaysSales() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.trending_up, color: Colors.green, size: 20.0),
            const SizedBox(width: 8.0),
            const Text(
              "Today's Sales",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            // TODO: Navigate to sales details
          },
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: AppColors.primaryOrange,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: const Icon(
              Icons.arrow_forward,
              color: Colors.white,
              size: 16.0,
            ),
          ),
        ),
      ],
    );
  }

  // Summary cards widget
  Widget _buildSummaryCards() {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            icon: Icons.currency_rupee,
            iconColor: Colors.pink,
            title: 'Pending Payments',
            value: '₹ 924',
            valueColor: Colors.pink,
          ),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: _buildSummaryCard(
            icon: Icons.inventory_2_outlined,
            iconColor: const Color(0xFF26344F),
            title: 'Low Stock items',
            value: '6',
            valueColor: const Color(0xFF26344F),
          ),
        ),
      ],
    );
  }

  // Individual summary card
  Widget _buildSummaryCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required Color valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFC),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 24.0),
          const SizedBox(height: 8.0),
          Text(
            title,
            style: const TextStyle(fontSize: 12.0, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4.0),
          Text(
            value,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  // Alerts section
  Widget _buildAlertsSection() {
    return Column(
      children: [
        _buildAlertCard(
          icon: Icons.warning_amber_rounded,
          iconColor: Colors.red,
          title: 'Low Stock Alert',
          subtitle: '6 items are running low on stock',
        ),
        const SizedBox(height: 12.0),
        _buildAlertCard(
          icon: Icons.notifications_outlined,
          iconColor: const Color(0xFF26344F),
          title: 'Payments Reminders',
          subtitle: '2 payments are pending',
        ),
      ],
    );
  }

  // Individual alert card
  Widget _buildAlertCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFC),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 24.0),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12.0, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Notifications section
  Widget _buildNotificationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.notifications_outlined,
              color: Color(0xFF26344F),
              size: 20.0,
            ),
            const SizedBox(width: 8.0),
            const Text(
              'Notifications',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16.0),
        _buildNotificationCard(
          icon: Icons.person_add,
          iconColor: AppColors.primaryOrange,
          title: 'New customer Raj Kumar added',
          time: '8 hours ago',
          tag: 'New',
          tagColor: Colors.green,
        ),
        const SizedBox(height: 12.0),
        _buildNotificationCard(
          icon: Icons.warning_amber_rounded,
          iconColor: Colors.red,
          title: 'Maggie Noddles stock is low (7 units left)',
          time: '2 payments are pending',
          tag: 'Alert',
          tagColor: AppColors.primaryOrange,
        ),
        const SizedBox(height: 12.0),
        _buildNotificationCard(
          icon: Icons.person_add,
          iconColor: AppColors.primaryOrange,
          title: 'New customer Suraj Kumar added',
          time: '3 hours ago',
          tag: 'New',
          tagColor: Colors.green,
        ),
      ],
    );
  }

  // Individual notification card
  Widget _buildNotificationCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String time,
    required String tag,
    required Color tagColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFC),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 24.0),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 14.0, color: Colors.black),
                ),
                const SizedBox(height: 2.0),
                Text(
                  time,
                  style: const TextStyle(fontSize: 12.0, color: Colors.grey),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: tagColor,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Text(
              tag,
              style: const TextStyle(
                fontSize: 10.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
