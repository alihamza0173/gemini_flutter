import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechToTextProvider extends ChangeNotifier {
  final SpeechToText _speechToText = SpeechToText();
  bool _isAvailable = false;
  String _text = '';
  String _status = 'Listening...';

  String get text => _text;
  String get status => _status;

  Future<bool> isAvailabe() async {
    _isAvailable = await _speechToText.initialize(
      onStatus: (status) {
        debugPrint('Status: $status');
      },
      onError: (error) {
        debugPrint('Error: $error');
        _status = 'Stopped';
        notifyListeners();
      },
      finalTimeout: const Duration(seconds: 5),
    );
    return _isAvailable;
  }

  void startListening() {
    _speechToText.listen(
      onResult: _onSpeechResult,
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 5),
    );
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    if (result.finalResult) {
      debugPrint('Final Result: ${result.recognizedWords}');
      _text = result.recognizedWords;
      _status = 'Done';
    } else {
      debugPrint('Interim Result: ${result.recognizedWords}');
      _text = result.recognizedWords;
    }
    notifyListeners();
  }

  void stopListening() {
    _status = 'Listening...';
    _text = '';
    _speechToText.stop();
  }

  void cancelListening() {
    _status = 'Listening...';
    _text = '';
    _speechToText.cancel();
  }
}

final speechToTextProvider =
    ChangeNotifierProvider((ref) => SpeechToTextProvider());
