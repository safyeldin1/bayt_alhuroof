import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Widget bigButton(String label, String route) => SizedBox(
          width: double.infinity,
          height: 120,
          child: FilledButton(
            onPressed: () => context.go(route),
            child: Text(label, style: const TextStyle(fontSize: 36)),
          ),
        );

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('بيت الحروف',
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 32),
              bigButton('الحروف', '/letters'),
              const SizedBox(height: 16),
              bigButton('الأرقام', '/numbers'),
            ],
          ),
        ),
      ),
    );
  }
}
