import 'package:elders_ai_app/application/common/chat_data.dart';
import 'package:elders_ai_app/core/models/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessageProvider extends ChangeNotifier {
  final List<Message> _messages = testChatMessages;
  bool _isVoiceChat = true;
  // Controller for Chat Screen
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  //getters
  List<Message> get messages => _messages;
  bool get isVoiceChat => _isVoiceChat;
  TextEditingController get textEditingController => _textEditingController;
  ScrollController get scrollController => _scrollController;

  // when user press on send message
  void addMessage([String? message]) {
    _messages.add(Message(
      sender: 'User',
      receiver: 'Elders AI',
      message: message ?? _textEditingController.text,
    ));
    notifyListeners();
    // to clear the text from textfield after sent
    _textEditingController.clear();
    // to scroll the list of messages so that recent message is always on bottom
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent + 100.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  // Add Listners to so that we can switch to voice chat or text
  void initController() {
    _textEditingController.addListener(() {
      if (_textEditingController.text.isEmpty) {
        // if there is nothing in textfield switch to voice chat
        _isVoiceChat = true;
        notifyListeners();
      } else if (_textEditingController.text.isNotEmpty) {
        // if there is something written in textfield switch to text field
        // if condition is written so that it should not notify all time
        if (_isVoiceChat) {
          _isVoiceChat = false;
          notifyListeners();
        }
      }
    });
  }

  // Dispose The Controllers
  void disposeControllers() {
    _textEditingController.dispose();
    _scrollController.dispose();
  }
}

final messagesProvider = ChangeNotifierProvider((ref) => MessageProvider());
