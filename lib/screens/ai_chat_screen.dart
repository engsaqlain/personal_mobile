import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/app_colors.dart';

// Simple model representing one chat message
class ChatMessage {
  final String text;
  final bool isUser; // true = sent by user, false = AI reply

  ChatMessage({required this.text, required this.isUser});
}

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<ChatMessage> _messages = [
    ChatMessage(
      text: 'Hi! I\'m your Personal AI stylist. Ask me for outfit advice, style tips, or color combinations!',
      isUser: false,
    ),
  ];

  bool _isTyping = false;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Sends the user's message and gets an AI reply.
  // TODO: Replace the placeholder logic below with a real call to
  // POST /api/ai/chat (Section 10.1) once Momina shares the live API URL.
  void _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
      _isTyping = true;
    });
    _messageController.clear();
    _scrollToBottom();

    // Placeholder delay to simulate an API call
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _messages.add(ChatMessage(
          text: 'This is a placeholder reply. Once connected to the AI API, '
              'I\'ll give you real fashion advice based on: "$text"',
          isUser: false,
        ));
        _isTyping = false;
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.elegantBlack),
        title: Text(
          'AI Stylist',
          style: GoogleFonts.playfairDisplay(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.elegantBlack,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length + (_isTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  // Show a "typing..." bubble as the last item while waiting
                  if (_isTyping && index == _messages.length) {
                    return _buildTypingBubble();
                  }
                  return _buildMessageBubble(_messages[index]);
                },
              ),
            ),

            // Input bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, -2)),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: InputDecoration(
                        hintText: 'Ask for style advice...',
                        hintStyle: GoogleFonts.inter(color: AppColors.lightGray, fontSize: 14),
                        filled: true,
                        fillColor: AppColors.softGray,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: AppColors.goldAccent,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: AppColors.elegantBlack, size: 18),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: message.isUser ? AppColors.elegantBlack : AppColors.softGray,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(message.isUser ? 16 : 4),
            bottomRight: Radius.circular(message.isUser ? 4 : 16),
          ),
        ),
        child: Text(
          message.text,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: message.isUser ? AppColors.white : AppColors.elegantBlack,
          ),
        ),
      ),
    );
  }

  Widget _buildTypingBubble() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.softGray,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const SizedBox(
          width: 30,
          height: 14,
          child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
        ),
      ),
    );
  }
}