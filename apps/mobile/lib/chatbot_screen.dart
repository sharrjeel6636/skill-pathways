import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'theme.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> messages = [];

  Future<void> _sendMessage() async {
    final text = _controller.text;
    setState(() {
      messages.add({"sender": "user", "text": text});
      _controller.clear();
    });

    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/chatbot/message'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'text': text}),
    );

    if (response.statusCode == 200) {
      final reply = jsonDecode(response.body)['reply'];
      setState(() {
        messages.add({"sender": "bot", "text": reply});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chatbot", style: Theme.of(context).textTheme.displayLarge), backgroundColor: AppColors.paper),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(messages[index]['text']!),
                tileColor: messages[index]['sender'] == 'bot' ? AppColors.sage.withOpacity(0.2) : null,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(child: TextField(controller: _controller)),
                IconButton(icon: const Icon(Icons.send), onPressed: _sendMessage),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
