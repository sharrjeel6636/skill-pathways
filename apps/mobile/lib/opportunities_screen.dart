import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'theme.dart';

class OpportunitiesScreen extends StatefulWidget {
  const OpportunitiesScreen({super.key});

  @override
  State<OpportunitiesScreen> createState() => _OpportunitiesScreenState();
}

class _OpportunitiesScreenState extends State<OpportunitiesScreen> {
  List<dynamic> opportunities = [];

  @override
  void initState() {
    super.initState();
    _fetchOpportunities();
  }

  Future<void> _fetchOpportunities() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8000/opportunities'));
    if (response.statusCode == 200) {
      setState(() {
        opportunities = jsonDecode(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Opportunities", style: Theme.of(context).textTheme.displayLarge), backgroundColor: AppColors.paper),
      body: ListView.builder(
        itemCount: opportunities.length,
        itemBuilder: (context, index) {
          final opp = opportunities[index];
          final deadline = DateTime.parse(opp['deadline']);
          final isUrgent = deadline.difference(DateTime.now()).inDays < 5;

          return ListTile(
            title: Text(opp['title']),
            subtitle: Text("Deadline: ${opp['deadline']}", style: TextStyle(color: isUrgent ? Colors.red : Colors.black)),
          );
        },
      ),
    );
  }
}
