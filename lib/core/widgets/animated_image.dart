import 'package:flutter/material.dart';

class AnimatedImage extends StatefulWidget {
  const AnimatedImage({super.key, required this.imagePath, required this.emoji, required this.onTap});
  final String imagePath;
  final String emoji;
  final VoidCallback onTap;

  @override
  State<AnimatedImage> createState() => _AnimatedImageState();
}

class _AnimatedImageState extends State<AnimatedImage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat(reverse: true);
    _bounceAnimation = Tween<double>(begin: 0.0, end: -15.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
        _controller.repeat(reverse: true);
      },
      child: AnimatedBuilder(
        animation: _bounceAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _bounceAnimation.value),
            child: Container(
              width: 160,
              height: 160,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withValues(alpha: 0.4),
                    blurRadius: 25,
                    spreadRadius: 5,
                  )
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  widget.imagePath,
                  fit: BoxFit.cover,
                  // لو الصورة مش موجودة، بنعرض الإيموجي
                  errorBuilder: (context, error, stackTrace) => Center(
                    child: Text(widget.emoji, style: const TextStyle(fontSize: 80)),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
