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
  // Category data with correct icon paths in hierarchical order
  final List<Map<String, dynamic>> _categories = [
    {
      'name': 'Billing',
      'items': [
        {
          'name': 'Quick\nBill',
          'icon': 'assets/categories/icons/billing/i-1.png',
        },
        {
          'name': 'Item-wise\nBill',
          'icon': 'assets/categories/icons/billing/i-2.png',
        },
        {
          'name': 'Inventory',
          'icon': 'assets/categories/icons/billing/i-3.png',
        },
        {
          'name': 'Staff\nManagement',
          'icon': 'assets/categories/icons/billing/i-4.png',
        },
        {
          'name': 'Customer\nManagement',
          'icon': 'assets/categories/icons/billing/i-5.png',
        },
        {
          'name': 'Credit\nDetails',
          'icon': 'assets/categories/icons/billing/i-6.png',
        },
        {
          'name': 'Cash\nManagement',
          'icon': 'assets/categories/icons/billing/i-7.png',
        },
        {
          'name': 'Training\nVideo',
          'icon': 'assets/categories/icons/billing/i-8.png',
        },
        {
          'name': 'Customer\nCatalogue',
          'icon': 'assets/categories/icons/billing/i-9.png',
        },
      ],
    },
    {
      'name': 'Analytics',
      'items': [
        {
          'name': 'Quick\nBill',
          'icon': 'assets/categories/icons/analytics/i-9.png',
        },
        {
          'name': 'Item Wise\nSales report',
          'icon': 'assets/categories/icons/analytics/i-10.png',
        },
        {
          'name': 'Day\nReport',
          'icon': 'assets/categories/icons/analytics/i-11.png',
        },
        {
          'name': 'Sales\nSummary',
          'icon': 'assets/categories/icons/analytics/i-12.png',
        },
      ],
    },
    {
      'name': 'Printing',
      'items': [
        {
          'name': 'Bluetooth',
          'icon': 'assets/categories/icons/printing/i-13.png',
        },
        {
          'name': 'Printer\nSetting',
          'icon': 'assets/categories/icons/printing/i-14.png',
        },
      ],
    },
    {
      'name': 'Smart Tools',
      'items': [
        {
          'name': 'Barcode\nMaker',
          'icon': 'assets/categories/icons/smarttools/i-15.png',
        },
        {
          'name': 'Business\nCard Maker',
          'icon': 'assets/categories/icons/smarttools/i-16.png',
        },
        {
          'name': 'Poster\nMaker',
          'icon': 'assets/categories/icons/smarttools/i-17.png',
        },
      ],
    },
    {
      'name': 'More Tools',
      'items': [
        {
          'name': 'Buy Printers\nHere',
          'icon': 'assets/categories/icons/moretools/i-18.png',
        },
        {
          'name': 'Feedback',
          'icon': 'assets/categories/icons/moretools/i-19.png',
        },
        {
          'name': 'Contact\nus',
          'icon': 'assets/categories/icons/moretools/i-20.png',
        },
      ],
    },
    {
      'name': 'Account',
      'items': [
        {
          'name': 'Subscription',
          'icon': 'assets/categories/icons/account/i-21.png',
        },
        {
          'name': 'Reset\nAccount',
          'icon': 'assets/categories/icons/account/i-22.png',
        },
        {
          'name': 'Delete\nAccount',
          'icon': 'assets/categories/icons/account/i-23.png',
        },
        {
          'name': 'Logout',
          'icon': 'assets/categories/icons/account/i-24.png',
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header with back arrow, title and profile icon
            _buildHeader(),
            // Main content area - scrollable
            Expanded(
              child: SingleChildScrollView(
                child: _buildCategoriesContent(),
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

  // Header with back arrow, title and profile icon - exact match to design
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
          child: Row(
            children: [
              const SizedBox(width: 8.0),
              // Title
              const Expanded(
                child: Text(
                  'Categories',
                  style: TextStyle(
                  fontSize: 22.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              // Profile icon
              Container(
                width: 36.0,
                height: 36.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4.0,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.person,
                  color: Color(0xFF2E5A87),
                  size: 20.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Categories content - scrollable with sections
  Widget _buildCategoriesContent() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Build all category sections
          ..._categories.map((category) => _buildCategorySection(category)),
        ],
      ),
    );
  }

  // Category section with title and items grid
  Widget _buildCategorySection(Map<String, dynamic> category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Text(
          category['name'],
          style: const TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A202C),
            height: 1.2,
          ),
        ),
        const SizedBox(height: 16.0), // Reduced spacing before white container
        // White background container for items
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8.0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20.0),
          child: _buildItemsGrid(category['items']),
        ),
        const SizedBox(height: 32.0), // Space between sections
      ],
    );
  }

  // Items grid - responsive columns based on screen width
  Widget _buildItemsGrid(List<Map<String, dynamic>> items) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate responsive items per row based on screen width
        int itemsPerRow;
        if (constraints.maxWidth < 300) {
          itemsPerRow = 2; // Very small screens
        } else if (constraints.maxWidth < 450) {
          itemsPerRow = 3; // Medium screens
        } else {
          itemsPerRow = 4; // Large screens (original design)
        }
        
        final int rowCount = (items.length / itemsPerRow).ceil();

        return Column(
          children: List.generate(rowCount, (rowIndex) {
            final startIndex = rowIndex * itemsPerRow;
            final endIndex = (startIndex + itemsPerRow).clamp(0, items.length);
            final rowItems = items.sublist(startIndex, endIndex);

            return Padding(
              padding: EdgeInsets.only(bottom: rowIndex < rowCount - 1 ? 20.0 : 0.0),
              child: Row(
                children: [
                  ...rowItems.map((item) => Expanded(child: _buildItemCard(item))),
                  // Add empty spaces if row is not complete
                  ...List.generate(
                    itemsPerRow - rowItems.length,
                    (index) => const Expanded(child: SizedBox()),
                  ),
                ],
              ),
            );
          }),
        );
      },
    );
  }

  // Item card - responsive design
  Widget _buildItemCard(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () {
        // Handle item tap
        _handleItemTap(item);
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isSmallScreen = constraints.maxWidth < 80;
          final iconSize = isSmallScreen ? 56.0 : 64.0;
          final imageSize = isSmallScreen ? 28.0 : 36.0;
          
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 4.0 : 6.0),
            child: Column(
              children: [
                // Icon container
                Container(
                  width: iconSize,
                  height: iconSize,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFE2E8F0),
                      width: 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8.0,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Image.asset(
                      item['icon'],
                      width: imageSize,
                      height: imageSize,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        // Debug: Print which asset failed to load
                        print('Failed to load asset: ${item['icon']}');
                        // Fallback icon if image fails to load
                        return Container(
                          width: imageSize,
                          height: imageSize,
                          decoration: BoxDecoration(
                            color: const Color(0xFF4A90E2).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Icon(
                            _getIconForItem(item['name']),
                            color: const Color(0xFF4A90E2),
                            size: isSmallScreen ? 18.0 : 24.0,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: isSmallScreen ? 8.0 : 12.0),
                // Item name
                SizedBox(
                  height: isSmallScreen ? 30.0 : 36.0, // Fixed height to align all text
                  child: Text(
                    item['name'],
                    style: TextStyle(
                      fontSize: isSmallScreen ? 10.0 : 12.0,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF374151),
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Handle item tap navigation
  void _handleItemTap(Map<String, dynamic> item) {
    final itemName = item['name'].toLowerCase().replaceAll('\n', ' ');

    // Navigate based on item name
    if (itemName.contains('quick bill')) {
      // Navigate to Quick Bill screen
      Navigator.pushNamed(context, '/quick-bill');
    } else if (itemName.contains('inventory')) {
      // Navigate to Inventory Management screen
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Switching to Inventory tab...'),
          backgroundColor: Color(0xFF5777B5),
        ),
      );
      widget.onNavigationTap(1); // Switch to inventory tab
    } else if (itemName.contains('staff management')) {
      // Navigate to Staff Management screen
      Navigator.pushNamed(context, '/staff-management');
    } else if (itemName.contains('customer management')) {
      // Navigate to Customer Management screen
      Navigator.pushNamed(context, '/customer-management');
    } else if (itemName.contains('cash management')) {
      // Navigate to Cash Management screen
      Navigator.pushNamed(context, '/cash-management');
    } else if (itemName.contains('item-wise bill')) {
      // Navigate to Item-wise Bill screen
      Navigator.pushNamed(context, '/itemwise-bill');
    } else if (itemName.contains('credit details')) {
      // Navigate to Ledger screen (enhanced Credit Details)
      Navigator.pushNamed(context, '/ledger');
    } else if (itemName.contains('training video')) {
      // Navigate to Training Videos screen
      Navigator.pushNamed(context, '/training-videos');
    } else if (itemName.contains('customer catalogue')) {
      // Navigate to Customer Catalogue screen
      Navigator.pushNamed(context, '/customer-catalogue');
    } else if (itemName.contains('item wise sales report') || itemName.contains('day report') || itemName.contains('sales summary')) {
      // Navigate to Reports screen
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Switching to Reports tab...'),
          backgroundColor: Color(0xFF5777B5),
        ),
      );
      widget.onNavigationTap(3); // Switch to reports tab
    } else if (itemName.contains('bluetooth') || itemName.contains('printer setting')) {
      // Navigate to appropriate printer/bluetooth screens
      if (itemName.contains('bluetooth')) {
        Navigator.pushNamed(context, '/bluetooth-settings');
      } else if (itemName.contains('printer setting')) {
        Navigator.pushNamed(context, '/printer-settings');
      }
    } else if (itemName.contains('barcode maker')) {
      // Navigate to Barcode Maker screen
      Navigator.pushNamed(context, '/barcode-maker');
    } else if (itemName.contains('business card maker')) {
      // Navigate to Business Card Maker screen
      Navigator.pushNamed(context, '/business-card-maker');
    } else if (itemName.contains('poster maker')) {
      // Navigate to Poster Maker screen
      Navigator.pushNamed(context, '/poster-maker');
    } else if (itemName.contains('buy printers')) {
      // Navigate to Printer Store screen
      Navigator.pushNamed(context, '/printer-store');
    } else if (itemName.contains('feedback')) {
      // Show feedback dialog
      _showFeedbackDialog();
    } else if (itemName.contains('subscription')) {
      // Navigate to Subscription screen
      Navigator.pushNamed(context, '/subscription');
    } else if (itemName.contains('reset account')) {
      // Navigate to Reset Account screen
      Navigator.pushNamed(context, '/reset-account');
    } else if (itemName.contains('delete account')) {
      // Navigate to Delete Account screen
      Navigator.pushNamed(context, '/delete-account');
    } else if (itemName.contains('logout')) {
      // Navigate to Logout screen
      Navigator.pushNamed(context, '/logout');
    } else if (itemName.contains('contact us')) {
      // Navigate to Contact Us screen
      Navigator.pushNamed(context, '/contact-us');
    } else {
      // Show coming soon dialog for other items
      _showComingSoonDialog(item['name']);
    }
  }

  // Show feedback dialog
  void _showFeedbackDialog() {
    final feedbackController = TextEditingController();
    int rating = 5;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Row(
            children: const [
              Icon(
                Icons.feedback,
                color: Color(0xFFFF805D),
                size: 24,
              ),
              SizedBox(width: 12),
              Text('Send Feedback'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Rate your experience:'),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      onPressed: () {
                        setState(() {
                          rating = index + 1;
                        });
                      },
                      icon: Icon(
                        index < rating ? Icons.star : Icons.star_border,
                        color: const Color(0xFFFF805D),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: feedbackController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Share your thoughts...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (feedbackController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter your feedback'),
                      backgroundColor: Color(0xFFE91E63),
                    ),
                  );
                  return;
                }
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Thank you for your $rating-star feedback!'),
                    backgroundColor: const Color(0xFF10B981),
                    duration: const Duration(seconds: 3),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF805D),
                foregroundColor: Colors.white,
              ),
              child: const Text('Send'),
            ),
          ],
        ),
      ),
    );
  }

  // Get fallback icon based on item name
  IconData _getIconForItem(String itemName) {
    final name = itemName.toLowerCase();
    if (name.contains('bill') || name.contains('invoice')) {
      return Icons.receipt_long;
    } else if (name.contains('inventory')) {
      return Icons.inventory_2;
    } else if (name.contains('staff') || name.contains('management')) {
      return Icons.people;
    } else if (name.contains('customer')) {
      return Icons.person;
    } else if (name.contains('credit')) {
      return Icons.credit_card;
    } else if (name.contains('cash')) {
      return Icons.payments;
    } else if (name.contains('training') || name.contains('video')) {
      return Icons.play_circle;
    } else if (name.contains('report') || name.contains('analytics')) {
      return Icons.analytics;
    } else if (name.contains('print')) {
      return Icons.print;
    } else if (name.contains('bluetooth')) {
      return Icons.bluetooth;
    } else if (name.contains('barcode')) {
      return Icons.qr_code_scanner;
    } else if (name.contains('business') || name.contains('card')) {
      return Icons.business_center;
    } else if (name.contains('poster')) {
      return Icons.image;
    } else if (name.contains('feedback')) {
      return Icons.feedback;
    } else if (name.contains('contact')) {
      return Icons.contact_support;
    } else if (name.contains('subscription')) {
      return Icons.star;
    } else if (name.contains('reset account')) {
      return Icons.refresh;
    } else if (name.contains('delete account')) {
      return Icons.delete_forever;
    } else if (name.contains('logout')) {
      return Icons.logout;
    } else {
      return Icons.settings;
    }
  }

  // Show coming soon dialog
  void _showComingSoonDialog(String itemName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: const [
            Icon(
              Icons.schedule,
              color: Color(0xFFFF805D),
              size: 24,
            ),
            SizedBox(width: 12),
            Text('Coming Soon'),
          ],
        ),
        content: Text(
          '$itemName feature is coming soon. Stay tuned for updates!',
          style: const TextStyle(
            color: Color(0xFF4A5568),
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF805D),
              foregroundColor: Colors.white,
            ),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
