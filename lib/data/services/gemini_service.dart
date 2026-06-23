import 'dart:typed_data';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/translation_result.dart';
import '../../core/constants/env_keys.dart';

class GeminiService {
  final GenerativeModel _model;

  GeminiService() : _model = GenerativeModel(
          model: 'gemini-1.5-flash',
          apiKey: dotenv.env[EnvKeys.geminiApiKey] ?? '',
          generationConfig: GenerationConfig(
            responseMimeType: 'application/json',
          ),
        );

  Future<TranslationResult> analyzeImage(Uint8List imageBytes) async {
    final apiKey = dotenv.env[EnvKeys.geminiApiKey];
    if (apiKey == null || apiKey.isEmpty || apiKey == 'your_gemini_api_key_here') {
      throw Exception('Gemini API key is not configured. Please set your key in the .env file.');
    }

    final prompt = '너는 도쿄를 여행하는 한국인을 위한 현지 문화 가이드야. '
        '첨부된 이미지에서 일본어 텍스트(세로쓰기, 손글씨, 간판, 메뉴판 포함)를 인식하고, '
        '한국인이 직관적으로 이해할 수 있게 다음 JSON 형식으로만 답변해 줘.\n\n'
        '{\n'
        '  "original_text": "인식한 일본어 원문",\n'
        '  "translation": "자연스러운 한국어 번역",\n'
        '  "context": "메뉴나 간판 단어의 유래, 역사, 맛이나 먹는 방법 등의 문화적 해설",\n'
        '  "tip": "주문 시 유용한 팁 또는 여행자 맞춤형 팁"\n'
        '}';

    final content = [
      Content.multi([
        TextPart(prompt),
        DataPart('image/jpeg', imageBytes),
      ]),
    ];

    try {
      final response = await _model.generateContent(content);
      final rawText = response.text;
      if (rawText == null || rawText.isEmpty) {
        throw Exception('Gemini API가 빈 응답을 반환했습니다.');
      }
      return TranslationResult.fromRawJson(rawText);
    } catch (e) {
      throw Exception('Gemini 분석에 실패했습니다: $e');
    }
  }
}
