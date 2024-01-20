import 'package:elders_ai_app/core/enums/chat_role.dart';
import 'package:elders_ai_app/core/models/chat.dart';

List<Message> testChatMessages = [
  Message(
    role: ChatRole.model,
    message: 'Hello, how can I help you?',
  ),
  Message(
    role: ChatRole.user,
    message: 'I need help with my phone',
  ),
  Message(
    role: ChatRole.model,
    message: 'What is the problem?',
  ),
  Message(
    role: ChatRole.user,
    message: 'I cannot make a call',
  ),
  Message(
    role: ChatRole.model,
    message: 'Please restart your phone',
  ),
  Message(
    role: ChatRole.user,
    message: 'Thank you',
  ),
  Message(
    role: ChatRole.model,
    message: 'You are welcome',
  ),
];
