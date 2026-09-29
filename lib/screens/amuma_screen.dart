import 'package:flutter/material.dart';

import '../services/nav_controller.dart';
import '../theme/app_colors.dart';

/// Amuma chatbot tab (Ai_Chatbot_start_chat.png).
/// Sending works: typed messages (and suggestion chips) appear as bubbles.
/// No AI response yet — this only wires up the chat UI itself.
class AmumaScreen extends StatefulWidget {
  const AmumaScreen({super.key});

  @override
  State<AmumaScreen> createState() => _AmumaScreenState();
}

class _ChatMessage {
  final String text;
  final bool fromUser;
  const _ChatMessage(this.text, this.fromUser);
}

class _AmumaScreenState extends State<AmumaScreen> {
  static const Color _bubbleFill = Color(0xFFFFEBF2);
  static const Color _bubbleBorder = Color(0xFFB3A8AC);
  static const Color _bubbleText = Color(0xFF615E5E);
  static const Color _avatarPink = Color(0xFFF07EA6);
  static const Color _userBubbleFill = Color(0xFF63263B);

  static const List<String> _suggestions = [
    'How to budget a my income this month?',
    'What are signs of labor?',
    'What to do if my baby has a fever?',
    'Can you explain the breastfeeding?',
  ];

  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<_ChatMessage> _messages = [];

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _send([String? text]) {
    final message = (text ?? _inputController.text).trim();
    if (message.isEmpty) return;

    setState(() {
      _messages.add(_ChatMessage(message, true));
      _inputController.clear();
    });

    // Scroll to the latest message once the frame settles.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasChat = _messages.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _circleButton(
                    Icons.arrow_back_ios_new_rounded,
                    () => NavController.instance.open('home'),
                  ),
                  _circleButton(Icons.menu_rounded, null),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView(
                  controller: _scrollController,
                  children: [
                    _greetingRow(),
                    const SizedBox(height: 24),
                    for (final m in _messages) _messageBubble(m),
                    if (!hasChat) ...[
                      const SizedBox(height: 100),
                      Padding(
                        padding: const EdgeInsets.only(left: 47),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (final text in _suggestions) _chip(text),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _inputBar(),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _circleButton(IconData icon, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: 18, color: Colors.black),
      ),
    );
  }

  Widget _greetingRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ColorFiltered(
          colorFilter: const ColorFilter.mode(_avatarPink, BlendMode.srcIn),
          child: Image.asset(
            'assets/images/amuma_mark.png',
            width: 46,
            height: 46,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              color: _bubbleFill,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _bubbleBorder),
            ),
            child: const Text(
              'Hi, I am AMUMA! Your personal AI companion how can I help you today?',
              style: TextStyle(
                fontSize: 13,
                height: 1.25,
                fontWeight: FontWeight.w700,
                color: _bubbleText,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _messageBubble(_ChatMessage message) {
    // User messages: right-aligned, maroon fill, no avatar (matches the
    // Login/Home maroon accent). No bot reply bubble is shown yet.
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              decoration: BoxDecoration(
                color: _userBubbleFill,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
              child: Text(
                message.text,
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.25,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () => _send(text),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
          decoration: BoxDecoration(
            color: _bubbleFill,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _bubbleBorder),
          ),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: _bubbleText,
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _inputController,
            minLines: 1,
            maxLines: 4,
            textInputAction: TextInputAction.send,
            onSubmitted: (_) => _send(),
            style: const TextStyle(fontSize: 15),
            decoration: const InputDecoration(
              hintText: 'Chat with Amuma',
              hintStyle: TextStyle(fontSize: 17, color: Color(0xFF6B6B6B)),
              border: InputBorder.none,
              isDense: true,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.add, size: 24, color: Colors.black87),
              const Spacer(),
              const Icon(Icons.mic_none_rounded, size: 20, color: Colors.black87),
              const SizedBox(width: 14),
              const Icon(Icons.document_scanner_outlined,
                  size: 20, color: Colors.black87),
              const SizedBox(width: 14),
              GestureDetector(
                onTap: () => _send(),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: AppColors.maroon,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_upward_rounded,
                      size: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}