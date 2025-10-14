import 'package:flutter/material.dart';

// Import management screens
import 'lib/navigation/categories/customermanagement/customermanagement.dart';
import 'lib/navigation/categories/staffmanagement/staffmanagement.dart';

void main() {
  runApp(const TestManagementRoutingApp());
}

class TestManagementRoutingApp extends StatelessWidget {
  const TestManagementRoutingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Management Routing',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1B365D),
          primary: const Color(0xFF1B365D),
        ),
        useMaterial3: true,
      ),
      home: const TestManagementRoutingScreen(),
      routes: {
        '/customer-management': (context) => const CustomerListScreen(),
        '/staff-management': (context) => const StaffManagementScreen(),
      },
    );
  }
}

class TestManagementRoutingScreen extends StatelessWidget {
  const TestManagementRoutingScreen({super.key});

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
                        'Management Routing Test',
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
                      'Management Screen Routing',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A202C),
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    const Text(
                      'Test the routing for Staff Management and Customer Management screens from the billing section:',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    
                    // Management screen buttons
                    ..._buildManagementButtons(context),
                    
                    const SizedBox(height: 30.0),
                    
                    // Info card
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
                            'Routing Implementation:',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1A202C),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          ..._buildImplementationDetails(),
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

  List<Widget> _buildManagementButtons(BuildContext context) {
    final managementItems = [
      {
        'name': 'Staff Management',
        'route': '/staff-management',
        'description': 'Manage staff members and permissions',
        'icon': Icons.people,
        'location': 'Billing Section → Staff Management',
      },
      {
        'name': 'Customer Management',
        'route': '/customer-management',
        'description': 'Manage customer information and history',
        'icon': Icons.person,
        'location': 'Billing Section → Customer Management',
      },
    ];

    return managementItems.map((item) {
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
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item['description'] as String,
                style: const TextStyle(
                  fontSize: 14.0,
                  color: Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                item['location'] as String,
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Color(0xFF9CA3AF),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
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

  List<Widget> _buildImplementationDetails() {
    final details = [
      '✅ Added routing in main.dart:',
      '   • /staff-management → StaffManagementScreen',
      '   • /customer-management → CustomerListScreen',
      '',
      '✅ Updated categories.dart navigation:',
      '   • Staff Management items now route correctly',
      '   • Customer Management items now route correctly',
      '',
      '✅ Both screens accessible from Billing section',
      '✅ Consistent navigation patterns maintained',
      '✅ No "Coming Soon" dialogs for these features',
    ];

    return details.map((detail) {
      if (detail.isEmpty) {
        return const SizedBox(height: 8.0);
      }
      return Padding(
        padding: const EdgeInsets.only(bottom: 6.0),
        child: Text(
          detail,
          style: TextStyle(
            fontSize: 14.0,
            color: detail.startsWith('✅') ? const Color(0xFF10B981) : const Color(0xFF374151),
            fontWeight: detail.startsWith('✅') ? FontWeight.w500 : FontWeight.normal,
            fontFamily: detail.contains('→') ? 'monospace' : null,
          ),
        ),
      );
    }).toList();
  }
}