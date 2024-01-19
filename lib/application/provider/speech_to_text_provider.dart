import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechToTextProvider extends ChangeNotifier {
  final SpeechToText _speechToText = SpeechToText();
  bool _isAvailable = false;

  Future<bool> isAvailabe({required ValueChanged<bool> onListening}) async {
    _isAvailable = await _speechToText.initialize(
      onStatus: (status) {
        if (status == 'listening') {
          onListening(true);
        } else {
          onListening(false);
        }
        debugPrint('Status: $status');
      },
      onError: (error) {
        debugPrint('Error: $error');
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
    } else {
      debugPrint('Interim Result: ${result.recognizedWords}');
    }
  }

  void stopListening() {
    _speechToText.stop();
  }

  void cancelListening() {
    _speechToText.cancel();
  }
}

final speechToTextProvider =
    ChangeNotifierProvider((ref) => SpeechToTextProvider());
