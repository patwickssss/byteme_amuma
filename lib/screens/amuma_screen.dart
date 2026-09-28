import 'package:flutter/material.dart';

import '../services/nav_controller.dart';
import '../theme/app_colors.dart';

/// Amuma chatbot tab (Ai_Chatbot_start_chat.png).
/// LOOKS ONLY: no AI, no sending messages. Buttons don't do anything yet
/// (except Back, which returns to Home).
class AmumaScreen extends StatelessWidget {
  const AmumaScreen({super.key});

  static const Color _bubbleFill = Color(0xFFFFEBF2);
  static const Color _bubbleBorder = Color(0xFFB3A8AC);
  static const Color _bubbleText = Color(0xFF615E5E);
  static const Color _avatarPink = Color(0xFFF07EA6);

  static const List<String> _suggestions = [
    'How to budget a my income this month?',
    'What are signs of labor?',
    'What to do if my baby has a fever?',
    'Can you explain the breastfeeding?',
  ];

  @override
  Widget build(BuildContext context) {
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
              const SizedBox(height: 32),
              _greetingRow(),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(left: 47),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final text in _suggestions) _chip(text),
                  ],
                ),
              ),
              const SizedBox(height: 24),
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

  Widget _chip(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
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
    );
  }

  Widget _inputBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 20, 16, 14),
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
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chat with Amuma',
            style: TextStyle(fontSize: 17, color: Color(0xFF6B6B6B)),
          ),
          SizedBox(height: 14),
          Row(
            children: [
              Icon(Icons.add, size: 24, color: Colors.black87),
              Spacer(),
              Icon(Icons.mic_none_rounded, size: 20, color: Colors.black87),
              SizedBox(width: 18),
              Icon(Icons.document_scanner_outlined,
                  size: 20, color: Colors.black87),
            ],
          ),
        ],
      ),
    );
  }
}
