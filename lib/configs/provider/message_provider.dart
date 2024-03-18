import 'package:elders_ai_app/configs/common/trained_data.dart';
import 'package:elders_ai_app/configs/enums/chat_role.dart';
import 'package:elders_ai_app/model/chat.dart';
import 'package:elders_ai_app/repositry/repositry/bard_chat_repositry.dart';
import 'package:elders_ai_app/repositry/services/bard_chat_service.dart';
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
  // Controller for Chat Screen
  final ScrollController _scrollController = ScrollController();

  //getters
  List<Message> get messages => _messages;
  ScrollController get scrollController => _scrollController;

  // when user press on send message
  Future<void> sendPrompt(String message) async {
    // Add Message to the List of message that shows on the screen
    _messages.add(Message(
      role: ChatRole.user,
      message: message,
    ));
    notifyListeners();
    // Add message to the content that is sent to the bard
    _contents.add({
      "role": "user",
      "parts": [
        {
          "text": message,
        }
      ]
    });
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
      notifyListeners();
      _goToRecentMessage();
    } catch (e) {
      // if there is any error remove the last message sent to the bard as it is not sent
      _contents.removeLast();
      throw Exception(e);
    }
  }

  // to scroll the list of messages so that recent message is always on bottom
  void _goToRecentMessage() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent +
          _scrollController.position.viewportDimension,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
}

final messagesProvider =
    ChangeNotifierProvider((ref) => MessageProvider(BardChatService()));
