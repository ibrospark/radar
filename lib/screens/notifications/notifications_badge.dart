import 'package:flutter/material.dart';

class NotificationBadge extends StatefulWidget {
  const NotificationBadge({super.key, required this.totalNotifications});
  final int totalNotifications;
  @override
  State<NotificationBadge> createState() => _NotificationBadgeState();
}

class _NotificationBadgeState extends State<NotificationBadge> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20.0,
      height: 20.0,
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.9),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Text(
            '${widget.totalNotifications}',
            style: const TextStyle(color: Colors.white, fontSize: 10),
          ),
        ),
      ),
    );
  }
}
