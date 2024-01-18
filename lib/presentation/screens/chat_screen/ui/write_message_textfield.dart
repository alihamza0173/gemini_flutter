import 'package:elders_ai_app/application/provider/message_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WriteMessageTextField extends StatefulWidget {
  const WriteMessageTextField({
    super.key,
    required this.scrollController,
  });
  final ScrollController scrollController;

  @override
  State<WriteMessageTextField> createState() => _WriteMessageTextFieldState();
}

class _WriteMessageTextFieldState extends State<WriteMessageTextField> {
  late final TextEditingController _textEditingController;

  @override
  void initState() {
    debugPrint('text field initState');
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    debugPrint('text field dispose');
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textEditingController,
              autocorrect: true,
              textCapitalization: TextCapitalization.sentences,
              enableSuggestions: true,
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
          Consumer(builder: (context, ref, _) {
            return IconButton(
              onPressed: () {
                ref
                    .read(messagesProvider)
                    .addMessage(_textEditingController.text);
                _textEditingController.clear();
                widget.scrollController.animateTo(
                  widget.scrollController.position.maxScrollExtent + 100.0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              },
              icon: const Icon(Icons.send),
              iconSize: 22.0,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue),
                iconColor: MaterialStateProperty.all(Colors.white),
              ),
            );
          }),
        ],
      ),
    );
  }
}
