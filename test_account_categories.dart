import 'package:flutter/material.dart';

// Import account screens
import 'lib/navigation/categories/account/subscription_screen.dart';
import 'lib/navigation/categories/account/reset_account_screen.dart';
import 'lib/navigation/categories/account/delete_account_screen.dart';
import 'lib/navigation/categories/account/logout_screen.dart';
import 'lib/navigation/categories/other/contact_us_screen.dart';

void main() {
  runApp(const TestAccountCategoriesApp());
}

class TestAccountCategoriesApp extends StatelessWidget {
  const TestAccountCategoriesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Account Categories',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1B365D),
          primary: const Color(0xFF1B365D),
        ),
        useMaterial3: true,
      ),
      home: const TestAccountCategoriesScreen(),
      routes: {
        '/subscription': (context) => const SubscriptionScreen(),
        '/reset-account': (context) => const ResetAccountScreen(),
        '/delete-account': (context) => const DeleteAccountScreen(),
        '/logout': (context) => const LogoutScreen(),
        '/contact-us': (context) => const ContactUsScreen(),
      },
    );
  }
}

class TestAccountCategoriesScreen extends StatelessWidget {
  const TestAccountCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Account Categories'),
        backgroundColor: const Color(0xFF1B365D),
        foregroundColor: Colors.white,
      ),
      body: Container(
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
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Account Section Test',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20.0),
                const Text(
                  'Test the account navigation routes:',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30.0),
                ..._buildAccountButtons(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildAccountButtons(BuildContext context) {
    final accountItems = [
      {'name': 'Subscription', 'route': '/subscription'},
      {'name': 'Reset Account', 'route': '/reset-account'},
      {'name': 'Delete Account', 'route': '/delete-account'},
      {'name': 'Logout', 'route': '/logout'},
      {'name': 'Contact Us', 'route': '/contact-us'},
    ];

    return accountItems.map((item) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, item['route']!);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF1B365D),
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            child: Text(
              'Test ${item['name']}',
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );
    }).toList();
  }
}