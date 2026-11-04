import 'package:flutter/material.dart';

class HoldToOpen extends StatefulWidget {
  const HoldToOpen({super.key, required this.onOpen, this.duration = const Duration(seconds: 3)});
  final VoidCallback onOpen;
  final Duration duration;
  @override
  State<HoldToOpen> createState() => _HoldToOpenState();
}

class _HoldToOpenState extends State<HoldToOpen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onOpen();
          _controller.reset();
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return SizedBox(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(
                    value: _controller.value,
                    color: Colors.white,
                    backgroundColor: Colors.white24,
                    strokeWidth: 4,
                  ),
                );
              },
            ),
            const Icon(Icons.lock_outline, color: Colors.white, size: 24),
          ],
        ),
      ),
    );
  }
}
