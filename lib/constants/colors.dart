import 'package:flutter/material.dart';

class AppColors {
  // Primary colors from the images
  static const Color primaryOrange = Color(0xFFFF805D);
  static const Color primaryBlue = Color(0xFF5777B5);
  static const Color darkBlue = Color(0xFF26344F);
  
  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF5777B5),
      Color(0xFF26344F),
    ],
  );
  
  // Professional gradient with three colors as requested
  static const LinearGradient professionalGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFF805D), // Orange
      Color(0xFF5777B5), // Blue
      Color(0xFF26344F), // Dark Blue
    ],
    stops: [0.0, 0.6, 1.0],
  );
  
  static const LinearGradient lightGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF5777B5),
      Color(0xFF4A6BA3),
    ],
  );
  
  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFF805D),
      Color(0xFFE57249),
    ],
  );
  
  // Text colors
  static const Color textPrimary = Color(0xFF2D3748);
  static const Color textSecondary = Color(0xFF718096);
  static const Color textLight = Colors.white;
  
  // Background colors
  static const Color backgroundLight = Color(0xFFF7FAFC);
  static const Color backgroundCard = Colors.white;
  static const Color backgroundOverlay = Color(0xFF000000);
  
  // Status colors
  static const Color success = Color(0xFF48BB78);
  static const Color warning = Color(0xFFED8936);
  static const Color error = Color(0xFFE53E3E);
  
  // Shadow
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 10,
      offset: const Offset(0, 5),
    ),
  ];
  
  static List<BoxShadow> buttonShadow = [
    BoxShadow(
      color: primaryOrange.withOpacity(0.3),
      blurRadius: 15,
      offset: const Offset(0, 5),
    ),
  ];
}