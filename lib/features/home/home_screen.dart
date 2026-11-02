import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/animations/bounce_in.dart';
import '../../core/animations/floating.dart';
import '../../core/widgets/kids_background.dart';
import '../../core/widgets/kids_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KidsBackground(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Floating(
                child: BounceIn(
                  child: Text(
                    'بيت الحروف',
                    style: TextStyle(
                      fontSize: 60, 
                      fontWeight: FontWeight.w900, 
                      color: Colors.white,
                      shadows: [
                        Shadow(color: Color(0xFF00796B), offset: Offset(4, 4), blurRadius: 0),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 60),
              
              // زر الحروف (مكعب برتقالي)
              Floating(
                child: BounceIn(
                  child: KidsButton(
                    color: const Color(0xFFFF7043),
                    onTap: () => context.go('/letters'),
                    child: const Text('أ', style: TextStyle(fontSize: 80, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              
              // زر الأرقام (مكعب أزرق)
              Floating(
                child: BounceIn(
                  child: KidsButton(
                    color: const Color(0xFF29B6F6),
                    onTap: () => context.go('/numbers'),
                    child: const Text('١', style: TextStyle(fontSize: 80, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
