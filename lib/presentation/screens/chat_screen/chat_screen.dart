import 'package:elders_ai_app/application/provider/message_provider.dart';
import 'package:elders_ai_app/application/provider/theme_provider.dart';
import 'package:elders_ai_app/presentation/screens/chat_screen/ui/chat_bubble.dart';
import 'package:elders_ai_app/presentation/screens/chat_screen/ui/write_message_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  @override
  void initState() {
    // from message provider it add listner to controller so that
    //can switch from voice to text and vice verse
    ref.read(messagesProvider).initController();
    ref.read(messagesProvider).getBardResponse();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(messagesProvider).messages;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wise Companion'),
        actions: [
          IconButton(
            onPressed: () => ref.read(themeProvider).toggleTheme(),
            icon: const Icon(Icons.brightness_4_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          // List of all the messages
          Expanded(
            child: ListView.builder(
                controller: ref.read(messagesProvider).scrollController,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return ChatBubble(message: messages[index]);
                }),
          ),
          // TextField for writing message and button
          const WriteMessageTextField(),
        ],
      ),
    );
  }
}
