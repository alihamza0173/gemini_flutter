import 'package:elders_ai_app/application/common/chat_data.dart';
import 'package:elders_ai_app/core/models/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessageProvider extends ChangeNotifier {
  List<Message> _messages = testChatMessages;

  List<Message> get messages => _messages;

  void addMessage(String message) {
    _messages.add(Message(
      sender: 'User',
      receiver: 'Elders AI',
      message: message,
    ));
    notifyListeners();
  }
}

final messagesProvider = ChangeNotifierProvider((ref) => MessageProvider());
