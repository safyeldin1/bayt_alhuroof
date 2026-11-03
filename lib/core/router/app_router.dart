import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/home_screen.dart';
import '../../features/letters/presentation/letters_screen.dart';
import '../../features/letters/presentation/letter_lesson_screen.dart';
import '../../features/games/presentation/choice_games.dart';
import '../../features/tracing/presentation/tracing_screen.dart';
import '../../features/numbers/presentation/numbers_screen.dart';
import '../../features/numbers/presentation/number_lesson_screen.dart';
import '../../features/parent_zone/parent_gate_screen.dart';
import '../../features/parent_zone/parent_screen.dart';
import '../../providers/parent_providers.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (c, s) => const HomeScreen()),
      GoRoute(path: '/letters', builder: (c, s) => const LettersScreen()),
      GoRoute(
        path: '/letters/:id',
        builder: (c, s) => LetterLessonScreen(letterId: s.pathParameters['id']!),
      ),
      GoRoute(
        path: '/letters/:id/recognize',
        builder: (c, s) => RecognizeLetterGame(letterId: s.pathParameters['id']!),
      ),
      GoRoute(
        path: '/letters/:id/trace',
        builder: (c, s) => TracingScreen(letterId: s.pathParameters['id']!),
      ),
      GoRoute(path: '/numbers', builder: (c, s) => const NumbersScreen()),
      GoRoute(
        path: '/numbers/:id',
        builder: (c, s) => NumberLessonScreen(numberId: s.pathParameters['id']!),
      ),
      GoRoute(
        path: '/numbers/:id/pick',
        builder: (c, s) => PickNumberGame(numberId: s.pathParameters['id']!),
      ),
      GoRoute(path: '/parent-gate', builder: (c, s) => const ParentGateScreen()),
      GoRoute(
        path: '/parent',
        builder: (c, s) => const ParentScreen(),
        redirect: (c, s) => ref.read(parentGateProvider.notifier).isUnlocked ? null : '/parent-gate',
      ),
    ],
  );
});
