import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'shared_preferences_provider.dart';

enum LanguageMode {
  french(name: '프랑스어', englishName: 'French', colorCode: 'pink'),
  spanish(name: '스페인어', englishName: 'Spanish', colorCode: 'yellow'),
  english(name: '영어', englishName: 'English', colorCode: 'blue'),
  japanese(name: '일본어', englishName: 'Japanese', colorCode: 'purple'),
  chinese(name: '중국어', englishName: 'Chinese', colorCode: 'red');

  final String name;
  final String englishName;
  final String colorCode;

  const LanguageMode({
    required this.name,
    required this.englishName,
    required this.colorCode,
  });
}

class LanguageNotifier extends StateNotifier<LanguageMode> {
  final Ref ref;

  LanguageNotifier(this.ref) : super(LanguageMode.japanese) {
    _loadLanguage();
  }

  void _loadLanguage() {
    try {
      final prefs = ref.read(sharedPreferencesProvider);
      final langName = prefs.getString('selected_language');
      if (langName != null) {
        state = LanguageMode.values.firstWhere((e) => e.name == langName);
      }
    } catch (_) {}
  }

  void setLanguage(LanguageMode mode) {
    state = mode;
    try {
      final prefs = ref.read(sharedPreferencesProvider);
      prefs.setString('selected_language', mode.name);
    } catch (_) {}
  }
}

final languageProvider = StateNotifierProvider<LanguageNotifier, LanguageMode>((ref) {
  return LanguageNotifier(ref);
});
