import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'quiz_model.dart';
import 'providers/QuizStateProvider.dart';
import 'services/api_client.dart';

enum MessageSender { bot, user }

class ChatMessage {
  final String text;
  final MessageSender sender;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.sender,
    required this.timestamp,
  });
}

class ChatbotScreen extends StatefulWidget {
  final bool isParentMode;
  final bool isMockInterview;
  const ChatbotScreen({
    super.key,
    this.isParentMode = false,
    this.isMockInterview = false,
  });

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;
  final bool _isUrdu = false;

  @override
  void initState() {
    super.initState();
    _seedGreeting();
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _seedGreeting() {
    final String greeting;
    if (widget.isParentMode) {
      greeting = _isUrdu
          ? "السلام علیکم! میں آپ کے بچے کی رہنمائی میں آپ کی مدد کے لیے حاضر ہوں۔ کوئی سوال ہو تو پوچھیں۔"
          : "Assalam-o-Alaikum! I'm here to support you in guiding your child. Feel free to ask any questions.";
    } else if (widget.isMockInterview) {
      greeting =
          "Assalam-o-Alaikum! I'm your mock interviewer. Let's start! Please tell me about yourself.";
    } else {
      greeting = _isUrdu
          ? "السلام علیکم! میں آپ کی رہنمائی کے لیے حاضر ہوں۔ میں آپ کی کیسے مدد کر سکتا ہوں؟"
          : "Assalam-o-Alaikum! I'm here to guide you. How can I help you today?";
    }
    _addMessage(greeting, MessageSender.bot);
  }

  void _addMessage(String text, MessageSender sender) {
    if (!mounted) return;
    setState(() {
      _messages.add(
        ChatMessage(text: text, sender: sender, timestamp: DateTime.now()),
      );
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
    if (_isTyping) return; // Prevent double trigger
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    _addMessage(text, MessageSender.user);
    _textController.clear();
    setState(() {}); // Re-disable send button immediately

    _simulateBotResponse(text);
  }

  Future<void> _sendMessageToApi(String text) async {
    final quizProvider = Provider.of<QuizStateProvider>(context, listen: false);
    final Map<String, dynamic> contextData = {
      "mode": widget.isParentMode
          ? "parent"
          : (widget.isMockInterview ? "mock_interview" : "student"),
      "student_name": "Sharjeel",
      "field_of_interest": quizProvider.fieldOfInterest ?? "Pre-Engineering",
      "quiz_top_field": quizProvider.completedResult?.topField ?? "Computer Science",
    };

    try {
      final response = await ApiClient.post('/chatbot/message', {
        'message': text,
        'text': text,
        'context': contextData,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data['reply'] ?? data['response'] ?? data['message'];
        if (reply != null && reply.toString().trim().isNotEmpty) {
          _addMessage(reply.toString(), MessageSender.bot);
          return;
        }
      }
    } catch (_) {
      // API call failure handled below
    }

    // Contextual fallback response so conversation always progresses
    final lower = text.toLowerCase();
    String fallbackReply;

    if (lower.contains("universit") || lower.contains("uni") || lower.contains("college")) {
      fallbackReply = "For engineering and computing in Pakistan, top-ranked institutions include NUST (Islamabad), FAST-NUCES, GIKI, UET Lahore, and NED Karachi. Check their specific eligibility criteria and entry test deadlines.";
    } else if (lower.contains("fee") || lower.contains("cost") || lower.contains("scholarship")) {
      fallbackReply = "Tuition varies by institution. Public universities like NED and UET are cost-effective, while private institutions offer need-based and merit scholarships (such as HEC Ehsaas and internal university grants).";
    } else if (lower.contains("merit") || lower.contains("ecat") || lower.contains("test")) {
      fallbackReply = "Most engineering and computing universities weigh entry test scores (ECAT, NET, or university-specific tests) at 50% or more, combined with intermediate/matriculation marks.";
    } else {
      fallbackReply = "Based on your academic profile, focusing on strong preparation in Mathematics and Physics along with early entry test registration will keep your career pathways flexible across Software Engineering, CS, and core Engineering.";
    }

    _addMessage(fallbackReply, MessageSender.bot);
  }

  void _simulateBotResponse(String userText) {
    setState(() => _isTyping = true);
    _sendMessageToApi(userText).then((_) {
      if (!mounted) return;
      setState(() => _isTyping = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAF9),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: ListView.separated(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
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
      ),
    );
  }

  Widget _buildHeader() => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          color: Color(0xFF0F766E),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: Color(0xFFF59E0B),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.support_agent_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Guidance Assistant",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Online · Answers in EN or Urdu",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: const Color(0xFFD9EDEA),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _buildMessageBubble(ChatMessage message) {
    final isBot = message.sender == MessageSender.bot;
    final alignment = isBot ? Alignment.centerLeft : Alignment.centerRight;

    return Align(
      alignment: alignment,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isBot ? const Color(0xFFFFFFFF) : const Color(0xFF0F766E),
          borderRadius: BorderRadius.circular(16),
          border: isBot ? Border.all(color: const Color(0xFFE7E5E4)) : null,
        ),
        child: Text(
          message.text,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: isBot ? const Color(0xFF1C1917) : Colors.white,
            height: 1.4,
          ),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() => Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE7E5E4)),
          ),
          child: const Text(
            "● ● ●",
            style: TextStyle(
              color: Color(0xFF0F766E),
              fontSize: 11,
              letterSpacing: 2.0,
            ),
          ),
        ),
      );

  Widget _buildInputBar() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFE7E5E4))),
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  controller: _textController,
                  onChanged: (_) => setState(() {}),
                  onSubmitted: (_) => _handleSend(),
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: const Color(0xFF1C1917),
                  ),
                  decoration: InputDecoration(
                    hintText: "Type your question...",
                    hintStyle: GoogleFonts.inter(
                      fontSize: 13,
                      color: const Color(0xFF6B7280),
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: (_textController.text.trim().isEmpty || _isTyping)
                  ? null
                  : _handleSend,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: (_textController.text.trim().isEmpty || _isTyping)
                      ? const Color(0xFFE7E5E4)
                      : const Color(0xFF0F766E),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      );
}