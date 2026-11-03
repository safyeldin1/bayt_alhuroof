import '../models/letter.dart';
import '../models/word.dart';
import '../models/number_item.dart';
import 'content_loader.dart';

class ContentRepository {
  ContentRepository(this._loader);
  final ContentLoader _loader;

  List<Letter> letters = [];
  List<Word> words = [];
  List<NumberItem> numbers = [];

  Future<void> load() async {
    letters = await _loader.loadLetters();
    words = await _loader.loadWords();
    numbers = await _loader.loadNumbers();
  }

  Letter? letterById(String id) {
    for (final l in letters) { if (l.id == id) return l; }
    return null;
  }

  NumberItem? numberById(String id) {
    for (final n in numbers) { if (n.id == id) return n; }
    return null;
  }

  NumberItem? numberByValue(int val) {
    for (final n in numbers) { if (n.value == val) return n; }
    return null;
  }

  Word? wordById(String id) {
    for (final w in words) { if (w.id == id) return w; }
    return null;
  }

  Letter? nextOf(Letter l) {
    final i = letters.indexWhere((x) => x.id == l.id);
    return (i >= 0 && i < letters.length - 1) ? letters[i + 1] : null;
  }

  Letter? previousOf(Letter l) {
    final i = letters.indexWhere((x) => x.id == l.id);
    return i > 0 ? letters[i - 1] : null;
  }
}
