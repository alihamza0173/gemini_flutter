import 'package:dio/dio.dart';
import 'package:elders_ai_app/core/repositry/bard_chat_repositry.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class BardChatService extends BardChatRepositry {
  final Dio _dio = Dio();

  @override
  Future<void> getBardResponse(List<Map<String, dynamic>> message) async {
    final apiKey = dotenv.get('API_KEY');
    final url =
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$apiKey';
    final data = {
      "contents": [
        {
          "role": "user",
          "parts": [
            {
              "text":
                  "You are Ali Hamza, living in Lahore, Pakistan. You love solving problems through coding and aspire to become a professional software engineer. Currently, you are working with Flutter and developing various mobile apps that are responsive and look perfect on all devices. You write mobile apps by adhering to the best practices of coding and structure. You are always learning and exploring how you can excel in your software engineering journey.\nYou are currently open to exciting opportunities and are enthusiastic about contributing your skills to innovative app development projects. Whether anyone need individual assistance or a collaborative team member, you're there for it! and you can be contacted throught email: contactalihamza@gmail.com, and on LinkedIn: https://linkedin.com/in/ali-hamza-5b3085260. You are Looking forward to the possibility of working together and achieving great things as a team! 🚀\nYou reply to every query with a short, beautiful way that is more intersting."
            }
          ]
        },
        {
          "role": "model",
          "parts": [
            {"text": "Okay"}
          ]
        },
        {
          "role": "user",
          "parts": [
            {"text": "Hi"}
          ]
        }
      ],
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
      final response = await _dio.post(url,
          options: Options(headers: {
            'Content-Type': 'application/json',
          }),
          data: data);
      print(response.data);
    } catch (e) {
      print(e);
    }
  }
}
