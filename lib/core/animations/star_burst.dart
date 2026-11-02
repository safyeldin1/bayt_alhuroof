import 'dart:math';
import 'package:flutter/material.dart';

class StarBurst extends StatefulWidget {
  const StarBurst({super.key, required this.stars});
  final int stars;

  @override
  State<StarBurst> createState() => _StarBurstState();
}

class _StarBurstState extends State<StarBurst> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: List.generate(widget.stars * 4, (index) {
            final angle = (index / (widget.stars * 4)) * 2 * pi;
            final distance = 120 * _controller.value;
            final dx = cos(angle) * distance;
            final dy = sin(angle) * distance;
            return Transform.translate(
              offset: Offset(dx, dy),
              child: Opacity(
                opacity: 1.0 - _controller.value,
                child: Icon(Icons.star, color: Colors.amber.shade400, size: 40),
              ),
            );
          }),
        );
      },
    );
  }
}
