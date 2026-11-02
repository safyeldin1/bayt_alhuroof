import 'package:flutter/material.dart';

class PulseHint extends StatefulWidget {
  const PulseHint({super.key, required this.child});
  final Widget child;

  @override
  State<PulseHint> createState() => _PulseHintState();
}

class _PulseHintState extends State<PulseHint> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat(reverse: true);
    _animation = Tween<double>(begin: 1.0, end: 1.15).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ScaleTransition(scale: _animation, child: widget.child);
}
