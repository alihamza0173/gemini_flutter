import 'package:elders_ai_app/configs/provider/tts_provider.dart';
import 'package:elders_ai_app/configs/enums/chat_role.dart';
import 'package:elders_ai_app/model/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({super.key, required this.message});

  final Message message;

  @override
  Widget build(BuildContext context) {
    final user = message.role == ChatRole.user;
    return Row(
      mainAxisAlignment: user ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.all(6.0),
          constraints: const BoxConstraints(maxWidth: 300),
          decoration: BoxDecoration(
            color: user ? Colors.grey[300] : Colors.blue[300],
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(user ? 14.0 : 4.0),
                topRight: const Radius.circular(14.0),
                bottomLeft: const Radius.circular(14.0),
                bottomRight: Radius.circular(user ? 4.0 : 14.0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              user
                  ? Text(
                      message.message,
                      style: TextStyle(
                        color: user ? Colors.black : Colors.white,
                        fontSize: 16.0,
                      ),
                    )
                  : MarkdownBody(
                      data: message.message,
                      selectable: true,
                      styleSheet:
                          MarkdownStyleSheet.fromTheme(Theme.of(context))
                              .copyWith(
                        p: const TextStyle(
                          color: Colors.white,
                        ),
                        a: const TextStyle(
                          color: Colors.deepPurple,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.deepPurple,
                        ),
                        listBullet: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onTapLink: (text, href, title) {
                        launchUrl(Uri.parse(href!));
                      },
                    ),
              if (!user)
                InkWell(
                  onTap: () => TTSProvider().speak(message.message),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 6.0),
                    child: Icon(
                      Icons.volume_up,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                )
            ],
          ),
        ),
      ],
    );
  }
}
