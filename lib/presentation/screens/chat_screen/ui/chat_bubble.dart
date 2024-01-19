import 'package:elders_ai_app/application/provider/tts_provider.dart';
import 'package:elders_ai_app/core/models/chat.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.message,
  });

  final Message message;

  @override
  Widget build(BuildContext context) {
    final isSentByUser = message.sender == 'User';
    return Row(
      mainAxisAlignment:
          isSentByUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.all(6.0),
          constraints: const BoxConstraints(maxWidth: 300),
          decoration: BoxDecoration(
            color: isSentByUser ? Colors.grey[300] : Colors.blue[300],
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(isSentByUser ? 14.0 : 4.0),
                topRight: const Radius.circular(14.0),
                bottomLeft: const Radius.circular(14.0),
                bottomRight: Radius.circular(isSentByUser ? 4.0 : 14.0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message.message,
                style: TextStyle(
                  color: isSentByUser ? Colors.black : Colors.white,
                  fontSize: 16.0,
                ),
              ),
              if (!isSentByUser)
                InkWell(
                  onTap: () => TTSProvider().speak(message.message),
                  child: const Icon(
                    Icons.volume_up,
                    size: 18,
                    color: Colors.white,
                  ),
                )
            ],
          ),
        ),
      ],
    );
  }
}
