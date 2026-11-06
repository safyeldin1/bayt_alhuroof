import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/widgets/kids_background.dart';
import '../../core/animations/bounce_in.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KidsBackground(
        child: SafeArea(
          child: Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(iconSize: 40, icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => context.go('/')),
                title: const Text('حول التطبيق', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                centerTitle: true,
              ),
              Expanded(
                child: Center(
                  // أضفنا SingleChildScrollView عشان نمنع أي Overflow
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: BounceIn(
                      child: Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40),
                          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 20, offset: Offset(0, 10))],
                        ),
                        child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.school, size: 100, color: Colors.orange),
                            SizedBox(height: 16),
                            Text('أول خطوة', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF00796B))),
                            SizedBox(height: 8),
                            Text('الإصدار 1.0.0', style: TextStyle(fontSize: 16, color: Colors.grey)),
                            SizedBox(height: 24),
                            Divider(),
                            SizedBox(height: 16),
                            Text('تطبيق تعليمي للأطفال لتعلم الحروف والأرقام والألوان والأشكال والمهن.', textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
                            SizedBox(height: 24),
                            Text('Powered by Safyeldin Abdo © Ghinax', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
                          ],
                        ),
                      ),
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
}
