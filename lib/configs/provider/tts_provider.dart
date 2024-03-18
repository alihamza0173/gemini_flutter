import 'package:flutter_tts/flutter_tts.dart';

class TTSProvider {
  static final TTSProvider _instance = TTSProvider._internal();

  factory TTSProvider() => _instance;

  TTSProvider._internal();

  final FlutterTts _flutterTts = FlutterTts();

  Future<void> speak(String text) async {
    await _flutterTts.setPitch(0.8);
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.speak(text);
  }
}
