import 'package:flutter/material.dart';
import 'theme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  Map<String, dynamic>? stats;

  @override
  void initState() {
    super.initState();
    _fetchStats();
  }

  Future<void> _fetchStats() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8000/admin/analytics'));
    if (response.statusCode == 200) {
      setState(() {
        stats = jsonDecode(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Admin Analytics", style: Theme.of(context).textTheme.displayLarge), backgroundColor: AppColors.paper),
      body: stats == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ListTile(title: Text("Active Users"), trailing: Text("${stats!['active_users']}")),
                  ListTile(title: Text("Completion Rate"), trailing: Text("${stats!['completion_rate']}")),
                ],
              ),
            ),
    );
  }
}
