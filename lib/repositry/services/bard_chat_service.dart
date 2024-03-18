import 'package:dio/dio.dart';
import 'package:elders_ai_app/repositry/repositry/bard_chat_repositry.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class BardChatService extends BardChatRepositry {
  final Dio _dio = Dio();

  @override
  Future<Map<String, dynamic>> getBardResponse(
      List<Map<String, dynamic>> contents) async {
    final apiKey = dotenv.get('API_KEY');
    final url =
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$apiKey';
    final data = {
      "contents": contents,
      "generationConfig": {
        "temperature": 0.9,
        "topK": 1,
        "topP": 1,
        "maxOutputTokens": 2048,
        "stopSequences": []
      },
      "safetySettings": [
        {
          "category": "HARM_CATEGORY_HARASSMENT",
          "threshold": "BLOCK_MEDIUM_AND_ABOVE"
        },
        {
          "category": "HARM_CATEGORY_HATE_SPEECH",
          "threshold": "BLOCK_MEDIUM_AND_ABOVE"
        },
        {
          "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
          "threshold": "BLOCK_MEDIUM_AND_ABOVE"
        },
        {
          "category": "HARM_CATEGORY_DANGEROUS_CONTENT",
          "threshold": "BLOCK_MEDIUM_AND_ABOVE"
        }
      ]
    };
    try {
      final response = await _dio.post(
        url,
        options: Options(headers: {
          'Content-Type': 'application/json',
        }),
        data: data,
      );
      return response.data['candidates'][0]['content'];
    } catch (e) {
      throw Exception(e);
    }
  }
}
