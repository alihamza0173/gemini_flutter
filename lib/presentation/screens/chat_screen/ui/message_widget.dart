import 'package:elders_ai_app/core/models/chat.dart';
import 'package:flutter/material.dart';

class MessageWidget extends StatelessWidget {
  const MessageWidget({
    super.key,
    required this.message,
  });

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: message.sender == 'Elders AI'
          ? MainAxisAlignment.start
          : MainAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: message.sender == 'Elders AI'
                ? Colors.blue[300]
                : Colors.grey[300],
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(message.message,
              style: TextStyle(
                color:
                    message.sender == 'Elders AI' ? Colors.white : Colors.black,
                fontSize: 16.0,
              )),
        ),
      ],
    );
  }
}
