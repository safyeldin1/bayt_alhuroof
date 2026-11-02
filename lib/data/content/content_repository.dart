import '../models/letter.dart';
import '../models/word.dart';
import 'content_loader.dart';

class ContentRepository {
  ContentRepository(this._loader);
  final ContentLoader _loader;

  List<Letter> letters = [];
  List<Word> words = [];

  Future<void> load() async {
    letters = await _loader.loadLetters();
    words = await _loader.loadWords();
  }

  Letter? letterById(String id) {
    for (final l in letters) { if (l.id == id) return l; }
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
