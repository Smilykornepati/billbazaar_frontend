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
    return Container(
      height: 80.0,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color(0xFFE2E8F0), // Light gray separator line
            width: 1.0,
          ),
        ),
      ),
      child: Stack(
        children: [
          // Main navigation items
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 60.0,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildNavItem(icon: _HomeIcon(), label: 'Home', index: 0),
                  _buildNavItem(
                    icon: _InventoryIcon(),
                    label: 'Inventory',
                    index: 1,
                  ),
                  const SizedBox(width: 50.0), // Space for central button
                  _buildNavItem(
                    icon: _ReportsIcon(),
                    label: 'Reports',
                    index: 3,
                  ),
                  _buildNavItem(
                    icon: _CategoriesIcon(),
                    label: 'Categories',
                    index: 4,
                  ),
                ],
              ),
            ),
          ),
          // Central action button
          Positioned(
            bottom: 20.0,
            left: 0,
            right: 0,
            child: Center(child: _buildCentralButton()),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required Widget icon,
    required String label,
    required int index,
  }) {
    final isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 50.0,
        height: 50.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 24.0,
              height: 24.0,
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
            const SizedBox(height: 2.0),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.0,
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? AppColors.primaryOrange
                    : const Color(0xFF2D3748),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCentralButton() {
    return GestureDetector(
      onTap: () => onTap(2),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 50.0,
        height: 50.0,
        decoration: BoxDecoration(
          color: AppColors.primaryOrange,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryOrange.withOpacity(0.3),
              blurRadius: 8.0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 20.0),
      ),
    );
  }
}

// Custom Home Icon
class _HomeIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: const Size(24, 24), painter: HomeIconPainter());
  }
}

class HomeIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF2D3748)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    // House outline with curved roof
    path.moveTo(size.width * 0.5, size.height * 0.15);
    path.lineTo(size.width * 0.8, size.height * 0.4);
    path.lineTo(size.width * 0.8, size.height * 0.8);
    path.lineTo(size.width * 0.2, size.height * 0.8);
    path.lineTo(size.width * 0.2, size.height * 0.4);
    path.close();

    // Door
    path.moveTo(size.width * 0.4, size.height * 0.8);
    path.lineTo(size.width * 0.4, size.height * 0.6);
    path.lineTo(size.width * 0.6, size.height * 0.6);
    path.lineTo(size.width * 0.6, size.height * 0.8);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom Inventory Icon
class _InventoryIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(24, 24),
      painter: InventoryIconPainter(),
    );
  }
}

class InventoryIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = const Color(0xFF2D3748)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Simple 3D box outline
    final path = Path();
    // Front face
    path.moveTo(size.width * 0.25, size.height * 0.5);
    path.lineTo(size.width * 0.75, size.height * 0.5);
    path.lineTo(size.width * 0.75, size.height * 0.8);
    path.lineTo(size.width * 0.25, size.height * 0.8);
    path.close();

    // Top face
    path.moveTo(size.width * 0.25, size.height * 0.5);
    path.lineTo(size.width * 0.4, size.height * 0.3);
    path.lineTo(size.width * 0.9, size.height * 0.3);
    path.lineTo(size.width * 0.75, size.height * 0.5);

    // Right face
    path.moveTo(size.width * 0.75, size.height * 0.5);
    path.lineTo(size.width * 0.9, size.height * 0.3);
    path.lineTo(size.width * 0.9, size.height * 0.6);
    path.lineTo(size.width * 0.75, size.height * 0.8);

    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom Reports Icon
class _ReportsIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: const Size(24, 24), painter: ReportsIconPainter());
  }
}

class ReportsIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = const Color(0xFF2D3748)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = const Color(0xFF2D3748)
      ..style = PaintingStyle.fill;

    // Document outline with folded corner
    final path = Path();
    path.moveTo(size.width * 0.2, size.height * 0.2);
    path.lineTo(size.width * 0.7, size.height * 0.2);
    path.lineTo(size.width * 0.7, size.height * 0.35);
    path.lineTo(size.width * 0.8, size.height * 0.35);
    path.lineTo(size.width * 0.8, size.height * 0.8);
    path.lineTo(size.width * 0.2, size.height * 0.8);
    path.close();

    // Folded corner
    path.moveTo(size.width * 0.7, size.height * 0.2);
    path.lineTo(size.width * 0.7, size.height * 0.35);
    path.lineTo(size.width * 0.8, size.height * 0.35);

    canvas.drawPath(path, strokePaint);

    // Text lines inside
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.3,
        size.height * 0.5,
        size.width * 0.4,
        size.height * 0.02,
      ),
      fillPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.3,
        size.height * 0.6,
        size.width * 0.35,
        size.height * 0.02,
      ),
      fillPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.3,
        size.height * 0.7,
        size.width * 0.3,
        size.height * 0.02,
      ),
      fillPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom Categories Icon
class _CategoriesIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(24, 24),
      painter: CategoriesIconPainter(),
    );
  }
}

class CategoriesIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = const Color(0xFF2D3748)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // 2x2 grid of squares
    final path = Path();

    // Top left square
    path.addRect(
      Rect.fromLTWH(
        size.width * 0.2,
        size.height * 0.2,
        size.width * 0.3,
        size.height * 0.3,
      ),
    );

    // Top right square
    path.addRect(
      Rect.fromLTWH(
        size.width * 0.5,
        size.height * 0.2,
        size.width * 0.3,
        size.height * 0.3,
      ),
    );

    // Bottom left square
    path.addRect(
      Rect.fromLTWH(
        size.width * 0.2,
        size.height * 0.5,
        size.width * 0.3,
        size.height * 0.3,
      ),
    );

    // Bottom right square
    path.addRect(
      Rect.fromLTWH(
        size.width * 0.5,
        size.height * 0.5,
        size.width * 0.3,
        size.height * 0.3,
      ),
    );

    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
