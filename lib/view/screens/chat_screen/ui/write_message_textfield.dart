import 'package:elders_ai_app/view/common/snack_bar.dart';
import 'package:elders_ai_app/configs/provider/message_provider.dart';
import 'package:elders_ai_app/configs/provider/speech_to_text_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WriteMessageTextField extends ConsumerStatefulWidget {
  const WriteMessageTextField({super.key});

  @override
  ConsumerState<WriteMessageTextField> createState() =>
      _WriteMessageTextFieldState();
}

class _WriteMessageTextFieldState extends ConsumerState<WriteMessageTextField> {
  late final TextEditingController _controller;
  bool _isVoiceChat = true;
  bool _isLoading = false;

  @override
  void initState() {
    _controller = TextEditingController();
    _controller.addListener(() {
      if (_controller.text.isEmpty) {
        // if there is nothing in textfield switch to voice chat
        setState(() {
          _isVoiceChat = true;
        });
      } else if (_controller.text.isNotEmpty) {
        // if there is something written in textfield switch to text field
        // if condition is written so that it should not setState all time
        if (_isVoiceChat && _controller.text.trim().isNotEmpty) {
          setState(() {
            _isVoiceChat = false;
          });
        }
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              textCapitalization: TextCapitalization.sentences,
              minLines: 1,
              maxLines: 5,
              style: const TextStyle(color: Colors.black, fontSize: 16.0),
              decoration: InputDecoration(
                hintText: 'Type your message here...',
                hintStyle: const TextStyle(color: Colors.black),
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
          // Button For Sending Prompt, Will show loading after sending message otherwise voice or send message icon
          Container(
            margin: const EdgeInsets.only(left: 8.0),
            constraints: const BoxConstraints(maxHeight: 42.0, maxWidth: 42.0),
            decoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            child: _isLoading
                ? const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2.0),
                  )
                : IconButton(
                    onPressed: () => _sendPrompt(),
                    icon: Icon(
                      _isVoiceChat ? Icons.mic : Icons.send,
                      color: Colors.white,
                    ),
                    iconSize: 22.0,
                  ),
          ),
        ],
      ),
    );
  }

  void _sendPrompt() async {
    if (_isVoiceChat) {
      ref.read(speechToTextProvider).isAvailabe().then((available) {
        if (available) {
          _showRecordingBottomSheet();
          ref.read(speechToTextProvider).startListening();
        } else {
          showSnackBarMessage(context, 'Speech recognition unavailable');
        }
      });
    } else {
      _sendPromptProvider(_controller.text.trim());
    }
  }

  Future<dynamic> _showRecordingBottomSheet() {
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
            child: Consumer(builder: (_, ref, __) {
              return Text(ref.watch(speechToTextProvider).text);
            }),
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
              Consumer(builder: (_, ref, __) {
                return Text(ref.watch(speechToTextProvider).status);
              }),
              // send button
              TextButton(
                  onPressed: () async {
                    final text = ref.read(speechToTextProvider).text;
                    ref.read(speechToTextProvider).stopListening();
                    Navigator.of(context).pop();
                    if (text.trim().isNotEmpty) {
                      _sendPromptProvider(text);
                    }
                  },
                  child: const Text('send')),
            ],
          ),
        ],
      ),
    );
  }

  void _sendPromptProvider(String prompt) async {
    setState(() {
      _isLoading = true;
      _controller.clear();
    });
    try {
      await ref.read(messagesProvider).sendPrompt(prompt);
    } catch (e) {
      // ignore: use_build_context_synchronously
      showSnackBarMessage(context, 'Something Went Wrong!');
    }
    setState(() {
      _isLoading = false;
    });
  }
}
