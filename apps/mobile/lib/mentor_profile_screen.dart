import 'package:flutter/material.dart';
import 'theme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MentorProfileScreen extends StatefulWidget {
  final int mentorId;
  const MentorProfileScreen({super.key, required this.mentorId});

  @override
  State<MentorProfileScreen> createState() => _MentorProfileScreenState();
}

class _MentorProfileScreenState extends State<MentorProfileScreen> {
  Map<String, dynamic>? data;

  @override
  void initState() {
    super.initState();
    _fetchMentor();
  }

  Future<void> _fetchMentor() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8000/mentors/${widget.mentorId}'));
    if (response.statusCode == 200) {
      setState(() {
        data = jsonDecode(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mentor", style: Theme.of(context).textTheme.displayLarge)),
      body: data == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(data!['mentor'][0]['name'], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(data!['mentor'][0]['bio']),
                ],
              ),
            ),
    );
  }
}
