import 'package:flutter/material.dart';

class ResponsiveDialog extends StatelessWidget {
  final String? title;
  final Widget content;
  final List<Widget>? actions;
  final EdgeInsetsGeometry? contentPadding;
  final bool scrollable;
  final Color? backgroundColor;
  final double? maxWidth;
  final double? maxHeight;

  const ResponsiveDialog({
    super.key,
    this.title,
    required this.content,
    this.actions,
    this.contentPadding,
    this.scrollable = true,
    this.backgroundColor,
    this.maxWidth,
    this.maxHeight,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isVerySmallScreen = screenSize.width < 320;
    final isSmallScreen = screenSize.width < 400;
    final isTablet = screenSize.width >= 600;
    
    // Calculate responsive dimensions
    double dialogWidth;
    double dialogMaxHeight;
    EdgeInsets dialogPadding;
    
    if (isVerySmallScreen) {
      dialogWidth = screenSize.width * 0.90; // Reduced from 0.95
      dialogMaxHeight = screenSize.height * 0.85;
      dialogPadding = const EdgeInsets.all(8);
    } else if (isSmallScreen) {
      dialogWidth = screenSize.width * 0.88; // Reduced from 0.92
      dialogMaxHeight = screenSize.height * 0.80;
      dialogPadding = const EdgeInsets.all(12);
    } else if (isTablet) {
      dialogWidth = screenSize.width * 0.55; // Reduced from 0.6
      dialogMaxHeight = screenSize.height * 0.75;
      dialogPadding = const EdgeInsets.all(24);
    } else {
      dialogWidth = screenSize.width * 0.80; // Reduced from 0.85
      dialogMaxHeight = screenSize.height * 0.78;
      dialogPadding = const EdgeInsets.all(16);
    }

    // Override with custom maxWidth if provided
    if (maxWidth != null) {
      dialogWidth = maxWidth!;
    }

    // Override with custom maxHeight if provided
    if (maxHeight != null) {
      dialogMaxHeight = maxHeight!;
    }

    return Dialog(
      backgroundColor: backgroundColor ?? Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isVerySmallScreen ? 8 : 12),
      ),
      insetPadding: dialogPadding,
      child: Container(
        width: dialogWidth,
        constraints: BoxConstraints(
          maxHeight: dialogMaxHeight,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title section
            if (title != null) ...[
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(
                  isVerySmallScreen ? 16 : (isSmallScreen ? 18 : 20)
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF5777B5).withOpacity(0.1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(isVerySmallScreen ? 8 : 12),
                    topRight: Radius.circular(isVerySmallScreen ? 8 : 12),
                  ),
                ),
                child: Text(
                  title!,
                  style: TextStyle(
                    fontSize: isVerySmallScreen ? 16 : (isSmallScreen ? 17 : 18),
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF26344F),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
            
            // Content section
            Flexible(
              child: Container(
                width: double.infinity,
                padding: contentPadding ?? EdgeInsets.all(
                  isVerySmallScreen ? 16 : (isSmallScreen ? 18 : 20)
                ),
                child: scrollable 
                    ? SingleChildScrollView(
                        child: content,
                      )
                    : content,
              ),
            ),
            
            // Actions section
            if (actions != null && actions!.isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(
                  isVerySmallScreen ? 16 : (isSmallScreen ? 18 : 20),
                  isVerySmallScreen ? 12 : 16,
                  isVerySmallScreen ? 16 : (isSmallScreen ? 18 : 20),
                  isVerySmallScreen ? 16 : (isSmallScreen ? 18 : 20),
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(isVerySmallScreen ? 8 : 12),
                    bottomRight: Radius.circular(isVerySmallScreen ? 8 : 12),
                  ),
                ),
                child: _buildResponsiveActions(context, actions!, isVerySmallScreen, isSmallScreen),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResponsiveActions(BuildContext context, List<Widget> actions, bool isVerySmallScreen, bool isSmallScreen) {
    // For small screens, stack buttons vertically if there are more than 2
    if ((isVerySmallScreen && actions.length > 1) || (isSmallScreen && actions.length > 2)) {
      return Column(
        children: actions.map((action) => 
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 8),
            child: action,
          )
        ).toList(),
      );
    }
    
    // For larger screens or fewer actions, use horizontal layout
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: actions.map((action) => 
        Padding(
          padding: EdgeInsets.only(left: isVerySmallScreen ? 6 : 8),
          child: action,
        )
      ).toList(),
    );
  }
}

// Helper function to show responsive dialog
Future<T?> showResponsiveDialog<T>({
  required BuildContext context,
  required Widget child,
  bool barrierDismissible = true,
  Color? barrierColor,
  String? barrierLabel,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor,
    barrierLabel: barrierLabel,
    builder: (context) => child,
  );
}

// Responsive button widget for dialogs
class ResponsiveDialogButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? textColor;
  final bool isPrimary;
  final IconData? icon;

  const ResponsiveDialogButton({
    super.key,
    required this.text,
    this.onPressed,
    this.color,
    this.textColor,
    this.isPrimary = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isVerySmallScreen = screenWidth < 320;
    final isSmallScreen = screenWidth < 400;
    
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? (isPrimary ? const Color(0xFF5777B5) : Colors.grey.shade200),
        foregroundColor: textColor ?? (isPrimary ? Colors.white : const Color(0xFF26344F)),
        padding: EdgeInsets.symmetric(
          horizontal: isVerySmallScreen ? 12 : (isSmallScreen ? 16 : 20),
          vertical: isVerySmallScreen ? 10 : (isSmallScreen ? 12 : 14),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: isPrimary ? 2 : 1,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: isVerySmallScreen ? 16 : (isSmallScreen ? 18 : 20),
            ),
            SizedBox(width: isVerySmallScreen ? 4 : 6),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: isVerySmallScreen ? 13 : (isSmallScreen ? 14 : 15),
              fontWeight: isPrimary ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// Responsive text field widget for dialogs
class ResponsiveDialogTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final TextInputType? keyboardType;
  final int? maxLines;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;

  const ResponsiveDialogTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.keyboardType,
    this.maxLines = 1,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isVerySmallScreen = screenWidth < 320;
    final isSmallScreen = screenWidth < 400;
    
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      obscureText: obscureText,
      validator: validator,
      style: TextStyle(
        fontSize: isVerySmallScreen ? 14 : (isSmallScreen ? 15 : 16),
      ),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: isVerySmallScreen ? 12 : (isSmallScreen ? 14 : 16),
          vertical: isVerySmallScreen ? 12 : (isSmallScreen ? 14 : 16),
        ),
        labelStyle: TextStyle(
          fontSize: isVerySmallScreen ? 13 : (isSmallScreen ? 14 : 15),
        ),
        hintStyle: TextStyle(
          fontSize: isVerySmallScreen ? 13 : (isSmallScreen ? 14 : 15),
        ),
      ),
    );
  }
}