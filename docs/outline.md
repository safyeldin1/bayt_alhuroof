# 🏛️ الوثيقة المعمارية — بيت الحروف
> آخر تحديث: 2026-11-08 21:08:28

## الفكرة
تطبيق أندرويد عربي لتعليم الأطفال (4-6 سنوات) الحروف والأرقام، بدون إنترنت وإعلانات.

## التقنيات
Flutter, Riverpod, go_router, Drift (SQLite), just_audio, path_drawing.

## المعمارية
Screens → Riverpod Providers → Domain (Engines) → Data (JSON/SQLite/Audio).

## المراحل
1. التأسيس (RTL + Router): ✅
2. المحتوى (Models + JSON): ✅
3. الصوت (AudioService): ✅
4. دروس الحروف (LetterLessonScreen): ✅
5. محرك الألعاب (GameShell): ⏳ التالي
6. التتبع (Tracing): ⏸️
