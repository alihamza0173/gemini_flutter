import 'package:elders_ai_app/application/provider/message_provider.dart';
import 'package:elders_ai_app/application/provider/theme_provider.dart';
import 'package:elders_ai_app/presentation/screens/chat_screen/ui/message_widget.dart';
import 'package:elders_ai_app/presentation/screens/chat_screen/ui/write_message_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    debugPrint('chat screen initState');
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    debugPrint('chat screen dispose');
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(messagesProvider).messages;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wise Companion'),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(themeProvider).toggleTheme();
            },
            icon: const Icon(Icons.brightness_4_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                controller: _scrollController,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return MessageWidget(message: messages[index]);
                }),
          ),
          WriteMessageTextField(
            scrollController: _scrollController,
          ),
        ],
      ),
    );
  }
}
