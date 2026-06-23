import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../data/models/translation_result.dart';
import '../data/services/gemini_service.dart';

final geminiServiceProvider = Provider<GeminiService>((ref) {
  return GeminiService();
});

class GeminiNotifier extends AsyncNotifier<TranslationResult?> {
  @override
  Future<TranslationResult?> build() async {
    // Initial state is null (no translation performed yet)
    return null;
  }

  Future<void> translateImage(XFile image) async {
    state = const AsyncLoading();
    
    state = await AsyncValue.guard(() async {
      final bytes = await image.readAsBytes();
      final service = ref.read(geminiServiceProvider);
      return await service.analyzeImage(bytes);
    });
  }

  void reset() {
    state = const AsyncData(null);
  }
}

final geminiNotifierProvider = AsyncNotifierProvider<GeminiNotifier, TranslationResult?>(() {
  return GeminiNotifier();
});
