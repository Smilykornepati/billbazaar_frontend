import 'package:flutter/material.dart';
import 'navigation/categories/account/subscription_screen.dart';

void main() {
  runApp(const SubscriptionTestApp());
}

class SubscriptionTestApp extends StatelessWidget {
  const SubscriptionTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Subscription Screen Test',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        useMaterial3: true,
      ),
      home: const SubscriptionScreen(),
    );
  }
}
