import 'package:flutter/material.dart';
import '../constants/colors.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    
    return Container(
      height: isSmallScreen ? 70.0 : 80.0, // Smaller, responsive height
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color(0xFFE2E8F0),
            width: 1.0,
          ),
        ),
      ),
      child: Stack(
        children: [
          // Main navigation items
          Positioned(
            bottom: 6.0, // Reduced bottom position
            left: 0,
            right: 0,
            child: Container(
              height: isSmallScreen ? 54.0 : 60.0, // Smaller, responsive height
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 16.0 : 20.0, // Responsive padding
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildNavItem(icon: _HomeIcon(), label: 'Home', index: 0, isSmallScreen: isSmallScreen),
                  _buildNavItem(
                    icon: _InventoryIcon(),
                    label: 'Inventory',
                    index: 1,
                    isSmallScreen: isSmallScreen,
                  ),
                  const SizedBox(width: 48.0), // Smaller space for central button
                  _buildNavItem(
                    icon: _ReportsIcon(),
                    label: 'Reports',
                    index: 3,
                    isSmallScreen: isSmallScreen,
                  ),
                  _buildNavItem(
                    icon: _CategoriesIcon(),
                    label: 'Categories',
                    index: 4,
                    isSmallScreen: isSmallScreen,
                  ),
                ],
              ),
            ),
          ),
          // Central action button
          Positioned(
            bottom: isSmallScreen ? 20.0 : 22.0, // Responsive position for smaller button
            left: 0,
            right: 0,
            child: Center(child: _buildCentralButton(isSmallScreen)),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required Widget icon,
    required String label,
    required int index,
    required bool isSmallScreen,
  }) {
    final isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: isSmallScreen ? 50.0 : 55.0, // Smaller, responsive width
        height: isSmallScreen ? 50.0 : 55.0, // Smaller, responsive height
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: isSmallScreen ? 22.0 : 24.0, // Smaller, responsive icons
              height: isSmallScreen ? 22.0 : 24.0,
              child: isSelected
                  ? ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        AppColors.primaryOrange,
                        BlendMode.srcIn,
                      ),
                      child: icon,
                    )
                  : icon,
            ),
            SizedBox(height: isSmallScreen ? 2.0 : 3.0), // Responsive spacing
            Text(
              label,
              style: TextStyle(
                fontSize: isSmallScreen ? 9.0 : 10.0, // Smaller, responsive font
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? AppColors.primaryOrange
                    : const Color(0xFF2D3748),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCentralButton(bool isSmallScreen) {
    return GestureDetector(
      onTap: () => onTap(2),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: isSmallScreen ? 48.0 : 52.0, // Smaller, responsive size
        height: isSmallScreen ? 48.0 : 52.0,
        decoration: BoxDecoration(
          color: AppColors.primaryOrange,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryOrange.withOpacity(0.25),
              blurRadius: 10.0,
              offset: const Offset(0, 3),
              spreadRadius: 1.5,
            ),
          ],
        ),
        child: Icon(
          Icons.menu, // Changed from Icons.add to Icons.menu
          color: Colors.white,
          size: isSmallScreen ? 20.0 : 22.0, // Smaller, responsive icon size
        ),
      ),
    );
  }
}

// Updated Custom Home Icon with better proportions
class _HomeIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: const Size(26, 26), painter: HomeIconPainter());
  }
}

class HomeIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF6B7280) // Slightly lighter default color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8 // Slightly thicker stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();

    // Roof
    path.moveTo(size.width * 0.5, size.height * 0.12);
    path.lineTo(size.width * 0.85, size.height * 0.42);
    path.lineTo(size.width * 0.15, size.height * 0.42);
    path.close();

    // House body
    path.moveTo(size.width * 0.2, size.height * 0.42);
    path.lineTo(size.width * 0.2, size.height * 0.85);
    path.lineTo(size.width * 0.8, size.height * 0.85);
    path.lineTo(size.width * 0.8, size.height * 0.42);

    // Door
    final doorRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.42,
        size.height * 0.6,
        size.width * 0.16,
        size.width * 0.25,
      ),
      const Radius.circular(2.0),
    );

    canvas.drawPath(path, paint);
    canvas.drawRRect(doorRect, paint);

    // Door handle
    canvas.drawCircle(
      Offset(size.width * 0.52, size.height * 0.72),
      1.0,
      Paint()..color = const Color(0xFF6B7280)..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Updated Custom Inventory Icon
class _InventoryIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(26, 26),
      painter: InventoryIconPainter(),
    );
  }
}

class InventoryIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = const Color(0xFF6B7280)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();

    // Front face of the box
    path.moveTo(size.width * 0.2, size.height * 0.45);
    path.lineTo(size.width * 0.7, size.height * 0.45);
    path.lineTo(size.width * 0.7, size.height * 0.85);
    path.lineTo(size.width * 0.2, size.height * 0.85);
    path.close();

    // Top face
    path.moveTo(size.width * 0.2, size.height * 0.45);
    path.lineTo(size.width * 0.35, size.height * 0.25);
    path.lineTo(size.width * 0.85, size.height * 0.25);
    path.lineTo(size.width * 0.7, size.height * 0.45);

    // Right face
    path.moveTo(size.width * 0.7, size.height * 0.45);
    path.lineTo(size.width * 0.85, size.height * 0.25);
    path.lineTo(size.width * 0.85, size.height * 0.65);
    path.lineTo(size.width * 0.7, size.height * 0.85);

    canvas.drawPath(path, strokePaint);

    // Add some inner details
    canvas.drawLine(
      Offset(size.width * 0.3, size.height * 0.6),
      Offset(size.width * 0.6, size.height * 0.6),
      strokePaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.3, size.height * 0.72),
      Offset(size.width * 0.6, size.height * 0.72),
      strokePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Updated Custom Reports Icon
class _ReportsIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: const Size(26, 26), painter: ReportsIconPainter());
  }
}

class ReportsIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = const Color(0xFF6B7280)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = const Color(0xFF6B7280)
      ..style = PaintingStyle.fill;

    // Document outline
    final docPath = Path();
    docPath.moveTo(size.width * 0.18, size.height * 0.15);
    docPath.lineTo(size.width * 0.65, size.height * 0.15);
    docPath.lineTo(size.width * 0.65, size.height * 0.32);
    docPath.lineTo(size.width * 0.82, size.height * 0.32);
    docPath.lineTo(size.width * 0.82, size.height * 0.85);
    docPath.lineTo(size.width * 0.18, size.height * 0.85);
    docPath.close();

    // Folded corner
    final cornerPath = Path();
    cornerPath.moveTo(size.width * 0.65, size.height * 0.15);
    cornerPath.lineTo(size.width * 0.65, size.height * 0.32);
    cornerPath.lineTo(size.width * 0.82, size.height * 0.32);
    cornerPath.close();

    canvas.drawPath(docPath, strokePaint);
    canvas.drawPath(cornerPath, strokePaint);

    // Text lines with better spacing
    final lineHeight = size.height * 0.025;
    final lineSpacing = size.height * 0.08;
    final startY = size.height * 0.45;

    for (int i = 0; i < 4; i++) {
      final width = i == 3 ? size.width * 0.25 : size.width * 0.45;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            size.width * 0.28,
            startY + (i * lineSpacing),
            width,
            lineHeight,
          ),
          const Radius.circular(1.0),
        ),
        fillPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Updated Custom Categories Icon
class _CategoriesIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(26, 26),
      painter: CategoriesIconPainter(),
    );
  }
}

class CategoriesIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = const Color(0xFF6B7280)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final squareSize = size.width * 0.32;
    final spacing = size.width * 0.08;
    final startX = (size.width - (2 * squareSize + spacing)) / 2;
    final startY = (size.height - (2 * squareSize + spacing)) / 2;

    // 2x2 grid of rounded squares
    final squares = [
      Rect.fromLTWH(startX, startY, squareSize, squareSize), // Top left
      Rect.fromLTWH(startX + squareSize + spacing, startY, squareSize, squareSize), // Top right
      Rect.fromLTWH(startX, startY + squareSize + spacing, squareSize, squareSize), // Bottom left
      Rect.fromLTWH(startX + squareSize + spacing, startY + squareSize + spacing, squareSize, squareSize), // Bottom right
    ];

    for (final square in squares) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(square, const Radius.circular(3.0)),
        strokePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
