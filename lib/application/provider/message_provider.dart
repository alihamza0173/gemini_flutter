import 'package:elders_ai_app/core/enums/chat_role.dart';
import 'package:elders_ai_app/core/models/chat.dart';
import 'package:elders_ai_app/core/repositry/bard_chat_repositry.dart';
import 'package:elders_ai_app/core/services/bard_chat_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessageProvider extends ChangeNotifier {
  final BardChatRepositry _bardChatRepositry;

  MessageProvider(this._bardChatRepositry);

  final List<Map<String, dynamic>> _contents = [
    {
      "role": "user",
      "parts": [
        {
          "text":
              "You are Ali Hamza, living in Lahore, Pakistan. You love solving problems through coding and aspire to become a professional software engineer. Currently, you are working with Flutter and developing various mobile apps that are responsive and look perfect on all devices. You write mobile apps by adhering to the best practices of coding and structure. You are always learning and exploring how you can excel in your software engineering journey.\nYou are currently open to exciting opportunities and are enthusiastic about contributing your skills to innovative app development projects. Whether anyone need individual assistance or a collaborative team member, you're there for it! and you can be contacted throught email: contactalihamza@gmail.com, and on LinkedIn: https://linkedin.com/in/ali-hamza-5b3085260. You are Looking forward to the possibility of working together and achieving great things as a team! 🚀\nYou reply to every query with a short, beautiful way that is more intersting."
        }
      ]
    },
    {
      "role": "model",
      "parts": [
        {"text": "Okay"}
      ]
    },
  ];
  final List<Message> _messages = [
    Message(
      role: ChatRole.model,
      message: 'Hello, how can I help you?',
    ),
  ];
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
  void sendPrompt([String? message]) {
    final text = _isVoiceChat ? message ?? ' ' : _textEditingController.text;
    // Add Message to the List of message that shows on the screen
    _messages.add(Message(
      role: ChatRole.user,
      message: text,
    ));
    notifyListeners();
    // Add message to the content that is sent to the bard
    _contents.add({
      "role": "user",
      "parts": [
        {"text": text}
      ]
    });
    getBardResponse();
    // to clear the text from textfield after sent
    _textEditingController.clear();
    // to scroll the list of messages so that recent message is always on bottom
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent + 100.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  // Get Response from API
  Future<void> getBardResponse() async {
    final response = await _bardChatRepositry.getBardResponse(_contents);
    _contents.add(response);
    _messages.add(
        Message(role: ChatRole.model, message: response['parts'][0]['text']));
    notifyListeners();
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
