import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/animations/bounce_in.dart';
import '../../core/animations/floating.dart';
import '../../core/widgets/kids_background.dart';
import '../../core/widgets/kids_button.dart';
import '../parent_zone/hold_to_open.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // معرفة إذا كانت الشاشة عرضية أم طولية
    final isLandscape = MediaQuery.of(context).size.width > MediaQuery.of(context).size.height;

    // تصميم الزر
    Widget buildMenuButton(String title, String letter, String route, Color color) {
      return Floating(
        child: BounceIn(
          child: KidsButton(
            width: isLandscape ? 220 : 180,
            height: isLandscape ? 160 : 160,
            color: color,
            onTap: () => context.go(route),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(letter, style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: Colors.white, height: 1.0)),
                const SizedBox(height: 8),
                Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: KidsBackground(
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // صورة البومة
                      Floating(
                        child: BounceIn(
                          child: Container(
                            width: isLandscape ? 120 : 140,
                            height: isLandscape ? 120 : 140,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 15, offset: Offset(0, 8))],
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/ui/mascot.png',
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Icon(Icons.school, size: 80, color: Colors.blue),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: isLandscape ? 16 : 24),
                      // العنوان
                      const Floating(
                        child: BounceIn(
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
                      ),
                      SizedBox(height: isLandscape ? 32 : 48),
                      
                      // الأزرار (عرضية أو طولية)
                      if (isLandscape)
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 32,
                          runSpacing: 24,
                          children: [
                            Floating(child: buildMenuButton('الحروف', 'أ', '/letters', const Color(0xFFFF7043))),
                            Floating(child: buildMenuButton('الأرقام', '١', '/numbers', const Color(0xFF29B6F6))),
                            Floating(child: buildMenuButton('الألوان', '🎨', '/colors', const Color(0xFF9C27B0))),
                            Floating(child: buildMenuButton('الأشكال', '🔺', '/shapes', const Color(0xFF4CAF50))),
                            Floating(child: buildMenuButton('التلوين', '🖍️', '/coloring', const Color(0xFFFF9800))),
                            Floating(child: buildMenuButton('المهن', '👷', '/professions', const Color(0xFF607D8B))),
                          ],
                        )
                      else
                        Column(
                          children: [
                            Floating(child: buildMenuButton('الحروف', 'أ', '/letters', const Color(0xFFFF7043))),
                            const SizedBox(height: 24),
                            Floating(child: buildMenuButton('الأرقام', '١', '/numbers', const Color(0xFF29B6F6))),
                            const SizedBox(height: 24),
                            Floating(child: buildMenuButton('الألوان', '🎨', '/colors', const Color(0xFF9C27B0))),
                            const SizedBox(height: 24),
                            Floating(child: buildMenuButton('الأشكال', '🔺', '/shapes', const Color(0xFF4CAF50))),
                            const SizedBox(height: 24),
                            Floating(child: buildMenuButton('التلوين', '🖍️', '/coloring', const Color(0xFFFF9800))),
                            Floating(child: buildMenuButton('المهن', '👷', '/professions', const Color(0xFF607D8B))),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
            // الحقوق في الأسفل
            Positioned(
              bottom: 4,
              left: 0,
              right: 0,
              child: const Center(
                child: Text(
                  'Powered by Safyeldin Abdo © Ghinax',
                  style: TextStyle(fontSize: 11, color: Colors.white70),
                ),
              ),
            ),
            // زر القفل
            PositionedDirectional(
              top: 10,
              end: 10,
              child: SafeArea(
                child: HoldToOpen(
                  onOpen: () => context.push('/parent-gate'),
                ),
              ),
            ),
            PositionedDirectional(
              top: 10,
              start: 10,
              child: SafeArea(
                child: Row(
                  children: [
                    IconButton(
                      iconSize: 40,
                      icon: const Icon(Icons.emoji_events, color: Colors.amber),
                      onPressed: () => context.push('/rewards'),
                    ),
                    IconButton(
                      iconSize: 40,
                      icon: const Icon(Icons.info_outline, color: Colors.white),
                      onPressed: () => context.push('/about'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
