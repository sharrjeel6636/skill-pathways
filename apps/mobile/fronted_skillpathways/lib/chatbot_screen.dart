import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum MessageSender { bot, user }

class ChatMessage {
  final String text;
  final MessageSender sender;
  final DateTime timestamp;

  ChatMessage({required this.text, required this.sender, required this.timestamp});
}
class ChatbotScreen extends StatefulWidget {
  final bool isParentMode;
  final bool isMockInterview;
  const ChatbotScreen({super.key, this.isParentMode = false, this.isMockInterview = false});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;
  bool _isUrdu = false; // Should be fetched from app settings/localization

  @override
  void initState() {
    super.initState();
    _seedGreeting();
  }

  void _seedGreeting() {
    final String greeting;
    if (widget.isParentMode) {
      greeting = _isUrdu
          ? "السلام علیکم! میں آپ کے بچے کی رہنمائی میں آپ کی مدد کے لیے حاضر ہوں۔ کوئی سوال ہو تو پوچھیں۔"
          : "Assalam-o-Alaikum! I'm here to support you in guiding your child. Feel free to ask any questions.";
    } else if (widget.isMockInterview) {
      greeting = "Assalam-o-Alaikum! I'm your mock interviewer. Let's start! Please tell me about yourself.";
    } else {
      greeting = _isUrdu
          ? "السلام علیکم! میں آپ کی رہنمائی کے لیے حاضر ہوں۔ میں آپ کی کیسے مدد کر سکتا ہوں؟"
          : "Assalam-o-Alaikum! I'm here to guide you. How can I help you today?";
    }
    _addMessage(greeting, MessageSender.bot);
  }

  void _addMessage(String text, MessageSender sender) {
    setState(() {
      _messages.add(ChatMessage(text: text, sender: sender, timestamp: DateTime.now()));
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleSend() {
    if (_textController.text.isEmpty) return;
    
    final text = _textController.text;
    _addMessage(text, MessageSender.user);
    _textController.clear();
    
    _simulateBotResponse(text);
  }

  void _simulateBotResponse(String userText) {
    setState(() => _isTyping = true);
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() => _isTyping = false);
      
      // Simulate potential error
      bool success = true; // Set to false to test error
      if (success) {
        _addMessage("I'm a placeholder bot. You said: $userText", MessageSender.bot);
      } else {
        _addMessage("Sorry, I couldn't process that — please try again", MessageSender.bot);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAF9),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView.separated(
              controller: _scrollController,
              padding: const EdgeInsets.all(20),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              separatorBuilder: (context, index) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                if (_isTyping && index == _messages.length) {
                  return _buildTypingIndicator();
                }
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildHeader() => Container(
    height: 110,
    padding: const EdgeInsets.fromLTRB(24, 56, 24, 18),
    decoration: const BoxDecoration(color: Color(0xFF0F766E)),
    child: Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: const BoxDecoration(color: Color(0xFFF59E0B), shape: BoxShape.circle),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Guidance Assistant", style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
            Text("Online · Answers in EN or Urdu", style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFFD9EDEA))),
          ],
        ),
      ],
    ),
  );

  Widget _buildMessageBubble(ChatMessage message) {
    final isBot = message.sender == MessageSender.bot;
    final alignment = _isUrdu ? (isBot ? Alignment.centerRight : Alignment.centerLeft) 
                              : (isBot ? Alignment.centerLeft : Alignment.centerRight);
    
    return Align(
      alignment: alignment,
      child: Container(
        constraints: BoxConstraints(maxWidth: isBot ? 230 : 220),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isBot ? const Color(0xFFFFFFFF) : const Color(0xFF0F766E),
          borderRadius: BorderRadius.circular(16),
          border: isBot ? Border.all(color: const Color(0xFFE7E5E4)) : null,
        ),
        child: Text(
          message.text,
          style: _isUrdu 
            ? GoogleFonts.notoNastaliqUrdu(fontSize: 13, color: isBot ? const Color(0xFF1C1917) : Colors.white)
            : GoogleFonts.inter(fontSize: 13, color: isBot ? const Color(0xFF1C1917) : Colors.white),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() => Align(
    alignment: _isUrdu ? Alignment.centerRight : Alignment.centerLeft,
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE7E5E4)),
      ),
      child: const Text("..."), // Replace with animated dots
    ),
  );

  Widget _buildInputBar() => Container(
    height: 80,
    padding: const EdgeInsets.fromLTRB(16, 14, 16, 26),
    decoration: const BoxDecoration(
      color: Colors.white,
      border: Border(top: BorderSide(color: Color(0xFFE7E5E4))),
    ),
    child: Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(color: const Color(0xFFF5F5F3), borderRadius: BorderRadius.circular(20)),
            child: TextField(
              controller: _textController,
              onChanged: (_) => setState(() {}),
              style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF1C1917)),
              decoration: InputDecoration(
                hintText: "Type your question...",
                hintStyle: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF6B7280)),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: _textController.text.isEmpty ? null : _handleSend,
          child: Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: _textController.text.isEmpty ? const Color(0xFFE7E5E4) : const Color(0xFF0F766E),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
          ),
        ),
      ],
    ),
  );
}
