import 'package:flutter/material.dart';
import 'home/home.dart';
import 'inventory/inventory.dart';
import 'reports/reports.dart';
import 'categories/categories.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  // Handle navigation tap
  void _onNavigationTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  // Get current screen based on index
  Widget _getCurrentScreen() {
    switch (_currentIndex) {
      case 0:
        return HomeScreen(
          currentIndex: _currentIndex,
          onNavigationTap: _onNavigationTap,
        );
      case 1:
        return InventoryScreen(
          currentIndex: _currentIndex,
          onNavigationTap: _onNavigationTap,
        );
      case 2:
        // Central FAB action - show home for now
        return HomeScreen(
          currentIndex: _currentIndex,
          onNavigationTap: _onNavigationTap,
        );
      case 3:
        return ReportsScreen(
          currentIndex: _currentIndex,
          onNavigationTap: _onNavigationTap,
        );
      case 4:
        return CategoriesScreen(
          currentIndex: _currentIndex,
          onNavigationTap: _onNavigationTap,
        );
      default:
        return HomeScreen(
          currentIndex: _currentIndex,
          onNavigationTap: _onNavigationTap,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _getCurrentScreen();
  }
}
