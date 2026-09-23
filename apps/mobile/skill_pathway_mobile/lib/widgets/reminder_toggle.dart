import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../constants.dart';

class ReminderToggle extends StatefulWidget {
  final String notificationId;
  final String title;
  final DateTime eventDate;
  final List<Duration> reminderOffsets;

  const ReminderToggle({
    super.key,
    required this.notificationId,
    required this.title,
    required this.eventDate,
    required this.reminderOffsets,
  });

  @override
  State<ReminderToggle> createState() => _ReminderToggleState();
}

class _ReminderToggleState extends State<ReminderToggle> {
  bool _isSet = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleReminder,
      child: Icon(
        _isSet ? Icons.notifications_active : Icons.notifications_none,
        color: _isSet ? RoadmapColors.primaryTeal : RoadmapColors.textMuted,
        size: 24,
      ),
    );
  }

  void _toggleReminder() {
    setState(() {
      _isSet = !_isSet;
    });
    // In a real app, schedule/cancel notifications here.
  }
}
