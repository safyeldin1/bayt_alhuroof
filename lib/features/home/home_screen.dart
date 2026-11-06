import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/animations/bounce_in.dart';
import '../../core/widgets/kids_background.dart';
import '../../core/widgets/kids_button.dart';
import '../parent_zone/hold_to_open.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KidsBackground(
        child: SafeArea(
          child: Stack(
            children: [
              // المحتوى الأساسي (العنوان والسكرول)
              Column(
                children: [
                  // العنوان والصورة
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 60, height: 60,
                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                          child: ClipOval(
                            child: Image.asset('assets/images/ui/mascot.png', fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.school, size: 40, color: Colors.blue)),
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Text('أول خطوة', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white)),
                      ],
                    ),
                  ),
                  
                  // السكرول الأفقي للكروت
                  Expanded(
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      children: [
                        // استخدام أيقونات فلاتر بدل الحروف
                        _buildCard(context, 'الحروف', Icons.sort_by_alpha, '/letters', const Color(0xFFFF7043)),
                        _buildCard(context, 'الأرقام', Icons.numbers, '/numbers', const Color(0xFF29B6F6)),
                        _buildCard(context, 'الألوان', Icons.palette, '/colors', const Color(0xFF9C27B0)),
                        _buildCard(context, 'الأشكال', Icons.category, '/shapes', const Color(0xFF4CAF50)),
                        _buildCard(context, 'التلوين', Icons.brush, '/coloring', const Color(0xFFFF9800)),
                        _buildCard(context, 'المهن', Icons.engineering, '/professions', const Color(0xFF607D8B)),
                      ],
                    ),
                  ),
                ],
              ),
              
              // زر القفل (يمين)
              PositionedDirectional(
                top: 8, end: 8,
                child: HoldToOpen(onOpen: () => context.push('/parent-gate')),
              ),
              
              // أزرار المكافآت و"حول" (شمال)
              PositionedDirectional(
                top: 8, start: 8,
                child: Row(
                  children: [
                    IconButton(
                      iconSize: 32, 
                      icon: const Icon(Icons.emoji_events, color: Colors.amber), 
                      onPressed: () => context.push('/rewards'),
                    ),
                    IconButton(
                      iconSize: 32, 
                      icon: const Icon(Icons.info_outline, color: Colors.white), 
                      onPressed: () => context.push('/about'),
                    ),
                  ],
                ),
              ),

              // الحقوق في الأسفل (خافتة وشفافة)
              const Positioned(
                bottom: 8,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    'Powered by Safyeldin Abdo © Ghinax',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white70, // لون شفاف
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // تعديل الدالة عشان تستقبل IconData بدل String
  Widget _buildCard(BuildContext context, String title, IconData icon, String route, Color color) {
    return Container(
      width: 260, // عرض الكارت
      margin: const EdgeInsets.only(right: 16),
      child: BounceIn(
        child: KidsButton(
          color: color,
          onTap: () => context.go(route),
          child: FittedBox( // عشان نمنع أي overflow
            fit: BoxFit.scaleDown,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 90, color: Colors.white), // استخدام Icon
                const SizedBox(height: 16),
                Text(title, style: const TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
