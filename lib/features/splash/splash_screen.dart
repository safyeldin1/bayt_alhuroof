import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/animations/bounce_in.dart';
import '../../core/widgets/kids_background.dart';
import '../../providers/audio_providers.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});
  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // تشغيل الموسيقى
    ref.read(audioServiceProvider).playVoice('music/splash', force: true);
    
    // الانتقال للشاشة الرئيسية بعد 4 ثواني (عشان الموسيقى تخلص)
    Timer(const Duration(seconds: 4), () {
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
                  width: 150,
                  height: 150,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 20, offset: Offset(0, 10))],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/icon/icon.png', // اللوجو الجديد
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(Icons.star, size: 80, color: Colors.amber),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const BounceIn(
                child: Text(
                  'أول خطوة',
                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              const SizedBox(height: 32),
              const CircularProgressIndicator(color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
