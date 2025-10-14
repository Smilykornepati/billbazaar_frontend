import 'package:flutter/material.dart';

// Import contact us screen
import 'lib/navigation/categories/other/contact_us_screen.dart';

void main() {
  runApp(const TestContactUsApp());
}

class TestContactUsApp extends StatelessWidget {
  const TestContactUsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Contact Us Screen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1B365D),
          primary: const Color(0xFF1B365D),
        ),
        useMaterial3: true,
      ),
      home: const TestContactUsMenu(),
      routes: {
        '/contact-us': (context) => const ContactUsScreen(),
      },
    );
  }
}

class TestContactUsMenu extends StatelessWidget {
  const TestContactUsMenu({super.key});

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
                        'Contact Us Screen - Light Theme Test',
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
                      'Contact Us - Light Theme',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A202C),
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    const Text(
                      'The contact us screen has been updated to match your project\'s light theme:',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    
                    // Contact us button
                    Container(
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
                          child: const Icon(
                            Icons.contact_support,
                            color: Colors.white,
                            size: 20.0,
                          ),
                        ),
                        title: const Text(
                          'Contact Us',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A202C),
                          ),
                        ),
                        subtitle: const Text(
                          'Get in touch with our support team',
                          style: TextStyle(
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
                          Navigator.pushNamed(context, '/contact-us');
                        },
                      ),
                    ),
                    
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

  List<Widget> _buildFeaturesList() {
    final features = [
      '✅ Light background (#F7FAFC)',
      '✅ Gradient header (#5777B5 → #26344F)',
      '✅ Removed menu icon, added back arrow',
      '✅ White main card with subtle shadow',
      '✅ Dark text colors for readability',
      '✅ Light-themed contact option icons',
      '✅ Orange accent colors maintained',
      '✅ Copy to clipboard functionality',
      '✅ Consistent with project design',
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