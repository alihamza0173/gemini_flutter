import 'package:elders_ai_app/core/enums/chat_role.dart';

class Message {
  final ChatRole role;
  final String message;

  Message({
    required this.role,
    required this.message,
  });
}
