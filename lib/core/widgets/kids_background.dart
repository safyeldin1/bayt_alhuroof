import 'package:flutter/material.dart';

class KidsBackground extends StatelessWidget {
  const KidsBackground({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF64B5F6), Color(0xFF81D4FA)], // سماء زرقاء
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(painter: _CartoonBackgroundPainter()),
          ),
          SafeArea(child: child),
        ],
      ),
    );
  }
}

class _CartoonBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 1. الشمس
    final sunPaint = Paint()..color = const Color(0xFFFFEB3B);
    canvas.drawCircle(Offset(size.width * 0.85, size.height * 0.15), 60, sunPaint);
    
    // 2. السحاب
    final cloudPaint = Paint()..color = Colors.white.withOpacity(0.8);
    _drawCloud(canvas, Offset(size.width * 0.2, size.height * 0.1), 1.0, cloudPaint);
    _drawCloud(canvas, Offset(size.width * 0.6, size.height * 0.25), 0.8, cloudPaint);

    // 3. التلال الخضراء
    final hillPaint1 = Paint()..color = const Color(0xFF81C784);
    final path1 = Path()
      ..moveTo(0, size.height)
      ..quadraticBezierTo(size.width * 0.2, size.height * 0.7, size.width * 0.6, size.height)
      ..close();
    canvas.drawPath(path1, hillPaint1);

    final hillPaint2 = Paint()..color = const Color(0xFF66BB6A);
    final path2 = Path()
      ..moveTo(size.width * 0.4, size.height)
      ..quadraticBezierTo(size.width * 0.8, size.height * 0.6, size.width, size.height)
      ..close();
    canvas.drawPath(path2, hillPaint2);
  }

  void _drawCloud(Canvas canvas, Offset center, double scale, Paint paint) {
    canvas.drawCircle(center, 30 * scale, paint);
    canvas.drawCircle(center.translate(-30 * scale, 10 * scale), 20 * scale, paint);
    canvas.drawCircle(center.translate(30 * scale, 10 * scale), 25 * scale, paint);
    canvas.drawRect(Rect.fromLTRB(center.dx - 30 * scale, center.dy, center.dx + 30 * scale, center.dy + 30 * scale), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
