import 'package:elders_ai_app/application/provider/message_provider.dart';
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
              ref.read(messagesProvider).isVoiceChat
                  ? showRecordingBottomSheet(context)
                  : ref.read(messagesProvider).addMessage();
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

  Future<dynamic> showRecordingBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(),
      isDismissible: false,
      builder: (context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('cancel')),
          const Text('Recording...'),
          TextButton(onPressed: () {}, child: const Text('send')),
        ],
      ),
    );
  }
}
