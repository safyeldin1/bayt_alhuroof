import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/arabic_numbers.dart';

class AppSettings {
  const AppSettings({this.voiceVolume = 1.0, this.numeralStyle = NumeralStyle.arabicIndic});
  final double voiceVolume;
  final NumeralStyle numeralStyle;

  AppSettings copyWith({double? voiceVolume, NumeralStyle? numeralStyle}) => AppSettings(
        voiceVolume: voiceVolume ?? this.voiceVolume,
        numeralStyle: numeralStyle ?? this.numeralStyle,
      );
}

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) => throw UnimplementedError());

class SettingsController extends Notifier<AppSettings> {
  static const _kVolume = 'voice_volume';
  static const _kNumerals = 'numeral_style';

  @override
  AppSettings build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final name = prefs.getString(_kNumerals);
    return AppSettings(
      voiceVolume: prefs.getDouble(_kVolume) ?? 1.0,
      numeralStyle: NumeralStyle.values.firstWhere((s) => s.name == name, orElse: () => NumeralStyle.arabicIndic),
    );
  }

  Future<void> setVolume(double v) async {
    state = state.copyWith(voiceVolume: v);
    await ref.read(sharedPreferencesProvider).setDouble(_kVolume, v);
    // تحديث الصوت في الخدمة
    // ref.read(audioServiceProvider).voiceVolume = v; // سنحتاج نمررها لاحقاً
  }

  Future<void> setNumerals(NumeralStyle s) async {
    state = state.copyWith(numeralStyle: s);
    await ref.read(sharedPreferencesProvider).setString(_kNumerals, s.name);
  }
}

final settingsProvider = NotifierProvider<SettingsController, AppSettings>(SettingsController.new);
