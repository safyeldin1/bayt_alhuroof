import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

// تفعيل السحب بالماوس
class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}

class BaytApp extends ConsumerWidget {
  const BaytApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    
    return MaterialApp.router(
      title: 'أول خطوة',
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: AppTheme.light,
      routerConfig: router,
      scrollBehavior: AppScrollBehavior(),
      builder: (context, child) {
        // الدرع الواقي: بنحط التطبيق كله في صندوق 1280x800 وبعدين بيتصغر أو بيكبر حسب الشاشة
        return FittedBox(
          fit: BoxFit.contain,
          child: SizedBox(
            width: 1280, // العرض المرجعي (شاشة عرضية كبيرة)
            height: 800, // الطول المرجعي
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.noScaling, // منع تكبير خطوط النظام
              ),
              child: child!,
            ),
          ),
        );
      },
    );
  }
}
