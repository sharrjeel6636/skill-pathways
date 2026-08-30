import 'package:flutter/material.dart';
import 'theme.dart';

class RoadmapScreen extends StatelessWidget {
  final List<dynamic> nodes;

  const RoadmapScreen({super.key, required this.nodes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pathway Roadmap', style: Theme.of(context).textTheme.displayLarge), backgroundColor: AppColors.paper),
      body: ListView.builder(
        itemCount: nodes.length,
        itemBuilder: (context, index) {
          final node = nodes[index];
          Color nodeColor;
          switch (node['status']) {
            case 'mastered': nodeColor = AppColors.sage; break;
            case 'active': nodeColor = AppColors.amber; break;
            default: nodeColor = AppColors.teal.withOpacity(0.3);
          }
          return ListTile(
            title: Text(node['title']),
            leading: Icon(Icons.circle, color: nodeColor),
          );
        },
      ),
    );
  }
}
