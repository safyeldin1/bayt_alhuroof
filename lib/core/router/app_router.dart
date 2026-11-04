import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/splash/splash_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/letters/presentation/letters_screen.dart';
import '../../features/letters/presentation/letter_lesson_screen.dart';
import '../../features/games/presentation/choice_games.dart';
import '../../features/games/presentation/drag_match_game.dart';
import '../../features/games/presentation/counting_game.dart';
import '../../features/games/presentation/colors_shapes_games.dart';
import '../../features/games/presentation/shape_shadow_game.dart';
import '../../features/games/presentation/letter_shadow_game.dart';
import '../../features/tracing/presentation/tracing_screen.dart';
import '../../features/numbers/presentation/numbers_screen.dart';
import '../../features/numbers/presentation/number_lesson_screen.dart';
import '../../features/parent_zone/parent_gate_screen.dart';
import '../../features/parent_zone/parent_screen.dart';
import '../../features/rewards/presentation/rewards_screen.dart';
import '../../features/colors/presentation/colors_screen.dart';
import '../../features/shapes/presentation/shapes_screen.dart';
import '../../features/coloring/presentation/coloring_gallery.dart';
import '../../features/about/about_screen.dart';
import '../../providers/parent_providers.dart';

// === ملفات المهن ===
import '../../features/games/presentation/professions_menu.dart';
import '../../features/games/presentation/professions_choice_game.dart';
import '../../features/games/presentation/professions_drag_game.dart';
import '../../features/games/presentation/professions_learn.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(path: '/splash', builder: (c, s) => const SplashScreen()),
      GoRoute(path: '/', builder: (c, s) => const HomeScreen()),
      
      // الحروف
      GoRoute(path: '/letters', builder: (c, s) => const LettersScreen()),
      GoRoute(path: '/letters/shadow_game', builder: (c, s) => const LetterShadowGame()),
      GoRoute(path: '/letters/:id', builder: (c, s) => LetterLessonScreen(letterId: s.pathParameters['id']!)),
      GoRoute(path: '/letters/:id/recognize', builder: (c, s) => RecognizeLetterGame(letterId: s.pathParameters['id']!)),
      GoRoute(path: '/letters/:id/match', builder: (c, s) => MatchImageGame(letterId: s.pathParameters['id']!)),
      GoRoute(path: '/letters/:id/drag', builder: (c, s) => DragMatchGame(letterId: s.pathParameters['id']!)),
      GoRoute(path: '/letters/:id/trace', builder: (c, s) => TracingScreen(letterId: s.pathParameters['id']!)),
      
      // الأرقام
      GoRoute(path: '/numbers', builder: (c, s) => const NumbersScreen()),
      GoRoute(path: '/numbers/:id', builder: (c, s) => NumberLessonScreen(numberId: s.pathParameters['id']!)),
      GoRoute(path: '/numbers/:id/pick', builder: (c, s) => PickNumberGame(numberId: s.pathParameters['id']!)),
      GoRoute(path: '/numbers/:id/count_game', builder: (c, s) => CountingGame(numberId: s.pathParameters['id']!)),
      
      // الألوان والأشكال
      GoRoute(path: '/colors', builder: (c, s) => const ColorsScreen()),
      GoRoute(path: '/colors/game', builder: (c, s) => const ColorGame()),
      GoRoute(path: '/shapes', builder: (c, s) => const ShapesScreen()),
      GoRoute(path: '/shapes/game', builder: (c, s) => const ShapeGame()),
      GoRoute(path: '/shapes/shadow_game', builder: (c, s) => const ShapeShadowGame()),
      
      // التلوين
      GoRoute(path: '/coloring', builder: (c, s) => const ColoringGallery()),
      
      // المهن (الـ 4 مسارات)
      GoRoute(path: '/professions', builder: (c, s) => const ProfessionsMenu()),
      GoRoute(path: '/professions/learn', builder: (c, s) => const ProfessionsLearn()),
      GoRoute(path: '/professions/choice', builder: (c, s) => const ProfessionsChoiceGame()),
      GoRoute(path: '/professions/drag', builder: (c, s) => const ProfessionsDragGame()),
      
      // حول التطبيق
      GoRoute(path: '/about', builder: (c, s) => const AboutScreen()),
      
      // المكافآت
      GoRoute(path: '/rewards', builder: (c, s) => const RewardsScreen()),
      
      // ولي الأمر
      GoRoute(path: '/parent-gate', builder: (c, s) => const ParentGateScreen()),
      GoRoute(
        path: '/parent',
        builder: (c, s) => const ParentScreen(),
        redirect: (c, s) => ref.read(parentGateProvider.notifier).isUnlocked ? null : '/parent-gate',
      ),
    ],
  );
});
