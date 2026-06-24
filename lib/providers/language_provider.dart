import 'package:flutter_riverpod/flutter_riverpod.dart';

enum LanguageMode {
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
  LanguageNotifier() : super(LanguageMode.japanese);

  void setLanguage(LanguageMode mode) {
    state = mode;
  }
}

final languageProvider = StateNotifierProvider<LanguageNotifier, LanguageMode>((ref) {
  return LanguageNotifier();
});
