import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/kids_background.dart';
import '../../../core/widgets/kids_button.dart';

class ProfessionsMenu extends StatelessWidget {
  const ProfessionsMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KidsBackground(
        child: SafeArea(
          child: Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent, elevation: 0, 
                leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => context.go('/')), 
                title: const Text('المهن', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                centerTitle: true,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: KidsButton(
                          color: Colors.green.shade400,
                          onTap: () => context.push('/professions/learn'),
                          child: const FittedBox(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.school, size: 60, color: Colors.white),
                                SizedBox(height: 8),
                                Text('تعلّم المهن', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: KidsButton(
                          color: Colors.blue.shade400,
                          onTap: () => context.push('/professions/choice'),
                          child: const FittedBox(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.touch_app, size: 60, color: Colors.white),
                                SizedBox(height: 8),
                                Text('اختيار الأداة', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: KidsButton(
                          color: Colors.orange.shade400,
                          onTap: () => context.push('/professions/drag'),
                          child: const FittedBox(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.drag_indicator, size: 60, color: Colors.white),
                                SizedBox(height: 8),
                                Text('توصيل الأداة', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
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
