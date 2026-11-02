import 'package:flutter/material.dart';

class KidsButton extends StatefulWidget {
  const KidsButton({
    super.key,
    required this.onTap,
    required this.color,
    required this.child,
    this.width = 180, // مربع افتراضي
    this.height = 180,
  });
  final VoidCallback onTap;
  final Color color;
  final Widget child;
  final double width;
  final double height;

  @override
  State<KidsButton> createState() => _KidsButtonState();
}

class _KidsButtonState extends State<KidsButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: widget.color.withOpacity(0.8),
              offset: Offset(0, _isPressed ? 4 : 12),
              blurRadius: 0,
            ),
          ],
          border: Border.all(color: Colors.white.withOpacity(0.5), width: 6),
        ),
        transform: Matrix4.translationValues(0, _isPressed ? 8 : 0, 0),
        child: Center(child: widget.child),
      ),
    );
  }
}
