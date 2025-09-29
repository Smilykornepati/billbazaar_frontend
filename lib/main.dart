import 'package:flutter/material.dart';

// Core screens
import 'screens/signin_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/otp_screen.dart';

// Navigation screens
import 'navigation/main_navigation.dart';
import 'navigation/categories/billing/quick_bill_screen.dart';

void main() {
  runApp(const BillBazarApp());
}

class BillBazarApp extends StatelessWidget {
  const BillBazarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BillBazar - Your Shopping Destination',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Navy blue color scheme for ecommerce
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1B365D),
          primary: const Color(0xFF1B365D),
          secondary: const Color(0xFF0F2035),
        ),
        useMaterial3: true,
        // Custom font styles for ecommerce
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B365D),
          ),
          headlineMedium: TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF1B365D),
          ),
          bodyLarge: TextStyle(color: Color(0xFF1B365D)),
        ),
        // Input decoration theme
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF1B365D), width: 2),
          ),
        ),
        // Elevated button theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1B365D),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: const SplashScreen(),
      // Define routes for navigation
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/signin': (context) => const SignInScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/main': (context) => const MainNavigationScreen(),
        '/quick-bill': (context) => const QuickBillScreen(),
        // Add more routes as needed
        // '/forgot-password': (context) => const ForgotPasswordScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/otp') {
          final args = settings.arguments as Map<String, String>;
          return MaterialPageRoute(
            builder: (context) => OTPScreen(
              email: args['email']!,
              name: args['name']!,
              password: args['password']!,
            ),
          );
        }
        return null;
      },
    );
  }
}
