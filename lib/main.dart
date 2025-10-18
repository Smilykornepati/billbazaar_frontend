import 'package:flutter/material.dart';

// Core screens
import 'screens/signin_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/otp_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/reset_password_screen.dart';

// Navigation screens
import 'navigation/main_navigation.dart';
import 'navigation/categories/billing/quick_bill_screen.dart';

// Account screens
import 'navigation/categories/account/subscription_screen.dart';
import 'navigation/categories/account/reset_account_screen.dart';
import 'navigation/categories/account/delete_account_screen.dart';
import 'navigation/categories/account/logout_screen.dart';

// Other screens
import 'navigation/categories/other/contact_us_screen.dart';

// Management screens
import 'navigation/categories/customermanagement/customermanagement.dart';
import 'navigation/categories/customermanagement/addcustomer/addcustomer.dart';
import 'navigation/categories/staffmanagement/staffmanagement.dart';
import 'navigation/categories/staffmanagement/addstaff/addstaff.dart';

// Billing screens
import 'navigation/categories/billing/additem/add_item_screen.dart';
import 'navigation/categories/billing/addclient/add_client_screen.dart';
import 'navigation/categories/billing/itemwise_bill_screen.dart';
import 'navigation/categories/billing/credit_details_screen.dart';
import 'navigation/categories/billing/cash_management_screen.dart';

// Tools screens
import 'navigation/categories/tools/training_videos_screen.dart';
import 'navigation/categories/tools/bluetooth_settings_screen.dart';
import 'navigation/categories/tools/printer_settings_screen.dart';
import 'navigation/categories/tools/printer_store_screen.dart';

// Smart Tools screens
import 'navigation/categories/smarttools/barcode_maker_screen.dart';
import 'navigation/categories/smarttools/business_card_maker_screen.dart';
import 'navigation/categories/smarttools/poster_maker_screen.dart';

// Ledger screens
import 'navigation/categories/ledger/ledger_screen.dart';

// CSV Import/Export screens
import 'navigation/categories/csv/csv_import_export_screen.dart';

// Customer Catalogue screens
import 'navigation/categories/catalogue/customer_catalogue_screen.dart';

// Payment Gateway screens
import 'navigation/categories/payment/payment_gateway_screen.dart';

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
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/subscription': (context) => const SubscriptionScreen(),
        '/reset-account': (context) => const ResetAccountScreen(),
        '/delete-account': (context) => const DeleteAccountScreen(),
        '/logout': (context) => const LogoutScreen(),
        '/contact-us': (context) => const ContactUsScreen(),
        '/customer-management': (context) => const CustomerListScreen(),
        '/add-customer': (context) => const AddCustomerScreen(),
        '/staff-management': (context) => const StaffManagementScreen(),
        '/add-staff': (context) => const AddStaffScreen(),
        '/add-item': (context) => const AddItemScreen(),
        '/add-client': (context) => const AddClientScreen(),
        '/itemwise-bill': (context) => const ItemwiseBillScreen(),
        '/credit-details': (context) => const CreditDetailsScreen(),
        '/cash-management': (context) => const CashManagementScreen(),
        '/training-videos': (context) => const TrainingVideosScreen(),
        '/bluetooth-settings': (context) => const BluetoothSettingsScreen(),
        '/printer-settings': (context) => const PrinterSettingsScreen(),
        '/printer-store': (context) => const PrinterStoreScreen(),
        '/barcode-maker': (context) => const BarcodeMakerScreen(),
        '/business-card-maker': (context) => const BusinessCardMakerScreen(),
        '/poster-maker': (context) => const PosterMakerScreen(),
        '/ledger': (context) => const LedgerScreen(),
        '/csv-import-export': (context) => const CsvImportExportScreen(),
        '/customer-catalogue': (context) => const CustomerCatalogueScreen(),
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
        if (settings.name == '/reset-password') {
          final args = settings.arguments as Map<String, String>;
          return MaterialPageRoute(
            builder: (context) => ResetPasswordScreen(email: args['email']!),
          );
        }
        return null;
      },
    );
  }
}
