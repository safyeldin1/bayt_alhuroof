import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/animations/bounce_in.dart';
import '../../core/widgets/kids_background.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // الانتقال للشاشة الرئيسية بعد ثانيتين ونصف
    Timer(const Duration(milliseconds: 2500), () {
      if (mounted) context.go('/');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KidsBackground(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BounceIn(
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 20, offset: Offset(0, 10))],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/ui/mascot.png',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(Icons.school, size: 100, color: Colors.blue),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const BounceIn(
                child: Text(
                  'أول خطوة',
                  style: TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    shadows: [Shadow(color: Color(0xFF00796B), offset: Offset(4, 4), blurRadius: 0)],
                  ),
                ),
              ),
              const SizedBox(height: 48),
              const CircularProgressIndicator(color: Colors.white),
              const SizedBox(height: 24),
              const Text('Powered by Safyeldin Abdo © Ghinax', style: TextStyle(fontSize: 11, color: Colors.white70)),
            ],
          ),
        ),
      ),
    );
  }
}
