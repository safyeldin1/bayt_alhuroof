#!/bin/bash
set -e
PROJECT_DIR="$HOME/bayt_alhuroof"
DOCS_DIR="$HOME/Desktop/bayt_alhuroof_docs"
COMMIT_MSG="${1:-auto: sync project}"
DATE_NOW=$(date '+%Y-%m-%d %H:%M:%S')

cd "$PROJECT_DIR"
mkdir -p "$DOCS_DIR"

# ============================================
# 1. Outline
# ============================================
cat << EOF > "$DOCS_DIR/outline.md"
# 🏛️ الوثيقة المعمارية — بيت الحروف
> آخر تحديث: $DATE_NOW

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
EOF

# ============================================
# 2. Progress
# ============================================
DART_COUNT=$(find lib -name "*.dart" | wc -l)
DART_LINES=$(find lib -name "*.dart" -exec cat {} + 2>/dev/null | wc -l)
cat << EOF > "$DOCS_DIR/progress.md"
# 📊 تقرير التقدم — بيت الحروف
> آخر تحديث: $DATE_NOW

## إحصائيات
- ملفات Dart: $DART_COUNT
- أسطر الكود: $DART_LINES

## ✅ ما تم إنجازه
- [x] تهيئة Flutter (Android)
- [x] RTL + العربية
- [x] ContentRepository + JSON
- [x] AudioService
- [x] الشاشة الرئيسية وقائمة الحروف
- [x] شاشة درس الحرف

## ⏳ الخطوة التالية
- [ ] محرك الألعاب المشترك (GameShell)
- [ ] نشاط "التعرف على الحرف"
EOF

# ============================================
# 3. Code
# ============================================
echo "# 💻 كود المشروع الكامل" > "$DOCS_DIR/code.md"
echo "> آخر تحديث: $DATE_NOW" >> "$DOCS_DIR/code.md"
echo '```yaml' >> "$DOCS_DIR/code.md"
cat pubspec.yaml >> "$DOCS_DIR/code.md"
echo '```' >> "$DOCS_DIR/code.md"
for f in $(find lib -name "*.dart" | sort); do
  echo "## 📄 \`$f\`" >> "$DOCS_DIR/code.md"
  echo '```dart' >> "$DOCS_DIR/code.md"
  cat "$f" >> "$DOCS_DIR/code.md"
  echo '```' >> "$DOCS_DIR/code.md"
done

# ============================================
# 4. Database
# ============================================
cat << EOF > "$DOCS_DIR/database.md"
# 🗄️ قاعدة البيانات والمحتوى
> آخر تحديث: $DATE_NOW

## جداول SQLite
- ItemProgress (contentId, bestStars, status)
- ActivityResults (activityId, stars, attempts)

## ملفات JSON
- letters.json (الحروف)
- words.json (الكلمات)
EOF

# ============================================
# نسخ للريبو والرفع على جيت هاب
# ============================================
mkdir -p docs
cp "$DOCS_DIR"/*.md docs/

git add -A
if git diff --cached --quiet; then
  echo "ℹ️ لا توجد تغييرات جديدة"
else
  git commit -m "$COMMIT_MSG"
fi
git push origin main || echo "⚠️ فشل الرفع، تأكد من الاتصال والصلاحيات"
echo "✅ تم تحديث الملفات الأربعة على الديسكتوب ورفعها على جيت هاب!"
