import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class SupportChatScreen extends StatefulWidget {
  const SupportChatScreen({super.key});

  @override
  State<SupportChatScreen> createState() => _SupportChatScreenState();
}

class _SupportChatScreenState extends State<SupportChatScreen> {
  final _controller = TextEditingController();
  final List<_ChatMessage> _messages = [
    _ChatMessage(
      text: 'Hi! 👋 Welcome to CrewConnct Support. How can we help you today?',
      isBot: true,
      time: DateTime.now().subtract(const Duration(minutes: 1)),
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      _messages.add(_ChatMessage(
        text: _controller.text,
        isBot: false,
        time: DateTime.now(),
      ));
    });
    _controller.clear();

    // Auto-reply after a delay
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _messages.add(_ChatMessage(
            text:
                'Thanks for reaching out! Our support team will get back to you shortly. In the meantime, check our FAQ for quick answers.',
            isBot: true,
            time: DateTime.now(),
          ));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            const Text('Support Chat'),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              reverse: false,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    mainAxisAlignment: msg.isBot
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (msg.isBot) ...[
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                          child: const Icon(Icons.support_agent_rounded,
                              size: 18, color: AppColors.primaryLight),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: msg.isBot
                                ? AppColors.darkSurface
                                : AppColors.primary,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(16),
                              topRight: const Radius.circular(16),
                              bottomLeft: Radius.circular(msg.isBot ? 4 : 16),
                              bottomRight:
                                  Radius.circular(msg.isBot ? 16 : 4),
                            ),
                          ),
                          child: Text(
                            msg.text,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                  color: msg.isBot
                                      ? AppColors.darkTextPrimary
                                      : Colors.white,
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Input bar
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
            decoration: BoxDecoration(
              color: AppColors.darkSurface,
              border: Border(
                  top: BorderSide(color: AppColors.darkBorder, width: 0.5)),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        fillColor: Colors.transparent,
                        filled: false,
                      ),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send_rounded, color: AppColors.primary),
                    onPressed: _send,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isBot;
  final DateTime time;

  _ChatMessage({required this.text, required this.isBot, required this.time});
}
