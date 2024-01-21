import 'package:elders_ai_app/application/provider/message_provider.dart';
import 'package:elders_ai_app/application/provider/speech_to_text_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WriteMessageTextField extends ConsumerWidget {
  const WriteMessageTextField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: ref.read(messagesProvider).textEditingController,
              textCapitalization: TextCapitalization.sentences,
              minLines: 1,
              maxLines: 5,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16.0,
              ),
              decoration: InputDecoration(
                hintText: 'Type your message here...',
                hintStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                ),
                filled: true,
                fillColor: const Color.fromARGB(255, 218, 238, 255),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  gapPadding: 0,
                  borderRadius: BorderRadius.circular(26.0),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              if (ref.read(messagesProvider).isVoiceChat) {
                ref.read(speechToTextProvider).isAvailabe().then((available) {
                  if (available) {
                    showRecordingBottomSheet(context, ref);
                    ref.read(speechToTextProvider).startListening();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Speech recognition unavailable'),
                      ),
                    );
                  }
                });
              } else {
                ref.read(messagesProvider).sendPrompt();
              }
            },
            icon: Icon(ref.watch(messagesProvider).isVoiceChat
                ? Icons.mic
                : Icons.send),
            iconSize: 22.0,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blue),
              iconColor: MaterialStateProperty.all(Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> showRecordingBottomSheet(
      BuildContext context, WidgetRef ref) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(),
      isDismissible: false,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Shows the text from speech
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Consumer(
              builder: (context, ref, child) {
                final text = ref.watch(speechToTextProvider).text;
                return Text(text);
              },
            ),
          ),
          // shows the option to cancel, send
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // cancel button
              TextButton(
                  onPressed: () {
                    ref.read(speechToTextProvider).cancelListening();
                    Navigator.of(context).pop();
                  },
                  child: const Text('cancel')),
              // shows the status of speech
              Consumer(builder: (context, ref, child) {
                return Text(ref.watch(speechToTextProvider).status);
              }),
              // send button
              TextButton(
                  onPressed: () {
                    final text = ref.read(speechToTextProvider).text;
                    ref.read(messagesProvider).sendPrompt(text);
                    ref.read(speechToTextProvider).stopListening();
                    Navigator.of(context).pop();
                  },
                  child: const Text('send')),
            ],
          ),
        ],
      ),
    );
  }
}
