import 'package:flutter/material.dart';

// Import account screens
import 'lib/navigation/categories/account/subscription_screen.dart';
import 'lib/navigation/categories/account/reset_account_screen.dart';
import 'lib/navigation/categories/account/delete_account_screen.dart';
import 'lib/navigation/categories/account/logout_screen.dart';

void main() {
  runApp(const TestLightThemeAccountApp());
}

class TestLightThemeAccountApp extends StatelessWidget {
  const TestLightThemeAccountApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Light Theme Account Screens',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1B365D),
          primary: const Color(0xFF1B365D),
        ),
        useMaterial3: true,
      ),
      home: const TestAccountScreensMenu(),
      routes: {
        '/subscription': (context) => const SubscriptionScreen(),
        '/reset-account': (context) => const ResetAccountScreen(),
        '/delete-account': (context) => const DeleteAccountScreen(),
        '/logout': (context) => const LogoutScreen(),
      },
    );
  }
}

class TestAccountScreensMenu extends StatelessWidget {
  const TestAccountScreensMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // Header with gradient background
            Container(
              height: 100.0,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF5777B5),
                    Color(0xFF26344F),
                  ],
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 16.0),
                child: Row(
                  children: [
                    SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        'Account Screens - Light Theme Test',
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Light Theme Account Screens',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A202C),
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    const Text(
                      'All account screens now use light theme with gradient headers and no menu icons:',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    
                    // Account screen buttons
                    ..._buildAccountButtons(context),
                    
                    const SizedBox(height: 30.0),
                    
                    // Features list
                    Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8.0,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Updated Features:',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1A202C),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          ..._buildFeaturesList(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildAccountButtons(BuildContext context) {
    final accountItems = [
      {
        'name': 'Subscription',
        'route': '/subscription',
        'description': 'Premium subscription plans',
        'icon': Icons.star,
      },
      {
        'name': 'Reset Account',
        'route': '/reset-account',
        'description': 'Reset account data with confirmation',
        'icon': Icons.refresh,
      },
      {
        'name': 'Delete Account',
        'route': '/delete-account',
        'description': 'Permanently delete account',
        'icon': Icons.delete_forever,
      },
      {
        'name': 'Logout',
        'route': '/logout',
        'description': 'Secure logout with confirmation',
        'icon': Icons.logout,
      },
    ];

    return accountItems.map((item) {
      return Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8.0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          leading: Container(
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(
              color: const Color(0xFF5777B5),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Icon(
              item['icon'] as IconData,
              color: Colors.white,
              size: 20.0,
            ),
          ),
          title: Text(
            item['name'] as String,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A202C),
            ),
          ),
          subtitle: Text(
            item['description'] as String,
            style: const TextStyle(
              fontSize: 14.0,
              color: Color(0xFF6B7280),
            ),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            color: Color(0xFF9CA3AF),
            size: 16.0,
          ),
          onTap: () {
            Navigator.pushNamed(context, item['route'] as String);
          },
        ),
      );
    }).toList();
  }

  List<Widget> _buildFeaturesList() {
    final features = [
      '✅ Light theme background (#F7FAFC)',
      '✅ Gradient headers (#5777B5 → #26344F)',
      '✅ Removed menu icons from all screens',
      '✅ White cards with subtle shadows',
      '✅ Consistent dark text colors',
      '✅ Professional spacing and layout',
      '✅ Orange accent colors maintained',
      '✅ Back navigation with arrow icons',
    ];

    return features.map((feature) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '  ',
              style: TextStyle(color: Color(0xFF10B981)),
            ),
            Expanded(
              child: Text(
                feature,
                style: const TextStyle(
                  fontSize: 14.0,
                  color: Color(0xFF374151),
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}