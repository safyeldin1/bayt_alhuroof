import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/home_screen.dart';
import '../../features/letters/presentation/letters_screen.dart';
import '../../features/letters/presentation/letter_lesson_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (c, s) => const HomeScreen()),
      GoRoute(path: '/letters', builder: (c, s) => const LettersScreen()),
      GoRoute(
        path: '/letters/:id',
        builder: (c, s) =>
            LetterLessonScreen(letterId: s.pathParameters['id']!),
      ),
      GoRoute(
        path: '/numbers',
        builder: (c, s) => Scaffold(
          appBar: AppBar(title: const Text('الأرقام')),
          body: const Center(child: Text('قريباً')),
        ),
      ),
    ],
  );
});
