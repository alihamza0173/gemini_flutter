import 'package:elders_ai_app/application/common/trained_data.dart';
import 'package:elders_ai_app/core/enums/chat_role.dart';
import 'package:elders_ai_app/core/models/chat.dart';
import 'package:elders_ai_app/core/repositry/bard_chat_repositry.dart';
import 'package:elders_ai_app/core/services/bard_chat_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessageProvider extends ChangeNotifier {
  final BardChatRepositry _bardChatRepositry;

  MessageProvider(this._bardChatRepositry);

  final List<Map<String, dynamic>> _contents = trainedData;
  final List<Message> _messages = [
    Message(
      role: ChatRole.model,
      message: 'Howdy! How can I assist you today? 🤝 ',
    ),
  ];
  bool _isLoadingResponse = false;
  bool _isVoiceChat = true;
  // Controller for Chat Screen
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  //getters
  List<Message> get messages => _messages;
  bool get isLoadingResponse => _isLoadingResponse;
  bool get isVoiceChat => _isVoiceChat;
  TextEditingController get textEditingController => _textEditingController;
  ScrollController get scrollController => _scrollController;

  // when user press on send message
  Future<void> sendPrompt([String? message]) async {
    final text = _isVoiceChat ? message ?? ' ' : _textEditingController.text;
    // Add Message to the List of message that shows on the screen
    _messages.add(Message(
      role: ChatRole.user,
      message: text,
    ));
    _isLoadingResponse = true;
    notifyListeners();
    // Add message to the content that is sent to the bard
    _contents.add({
      "role": "user",
      "parts": [
        {"text": text}
      ]
    });
    // to clear the text from textfield after sent
    _textEditingController.clear();
    _goToRecentMessage();

    await _getBardResponse();
  }

  // Get Response from API
  Future<void> _getBardResponse() async {
    try {
      final response = await _bardChatRepositry.getBardResponse(_contents);
      _contents.add(response);
      _messages.add(
          Message(role: ChatRole.model, message: response['parts'][0]['text']));
      _isLoadingResponse = false;
      notifyListeners();
      _goToRecentMessage();
    } catch (e) {
      // if there is any error remove the last message sent to the bard as it is not sent
      _contents.removeLast();
      _isLoadingResponse = false;
      notifyListeners();
      throw Exception(e);
    }
  }

  // to scroll the list of messages so that recent message is always on bottom
  void _goToRecentMessage() {
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

final messagesProvider =
    ChangeNotifierProvider((ref) => MessageProvider(BardChatService()));
