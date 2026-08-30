import 'package:flutter/material.dart';
import 'theme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Map<String, dynamic>? data;

  @override
  void initState() {
    super.initState();
    _fetchDashboard();
  }

  Future<void> _fetchDashboard() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8000/dashboard/mock-user-id'));
    if (response.statusCode == 200) {
      setState(() {
        data = jsonDecode(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dashboard", style: Theme.of(context).textTheme.displayLarge), backgroundColor: AppColors.paper),
      body: data == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Pathway: ${data!['pathways'][0]['pathways']['title']}"),
                  Text("Progress: ${data!['progress'].length}%"),
                ],
              ),
            ),
    );
  }
}
