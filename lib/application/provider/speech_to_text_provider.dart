import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechToTextProvider extends ChangeNotifier {
  final SpeechToText _speechToText = SpeechToText();
  void startListening(BuildContext context,
      {required ValueChanged<bool> onListening}) async {
    if (await _speechToText.initialize(
      onStatus: (status) => onListening(_speechToText.isListening),
    )) {
      _speechToText.listen(
        onResult: _onSpeechResult,
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 5),
      );
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Speech recognition unavailable'),
        ),
      );
    }
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
