import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:radar/_builds/build_all_elements.dart';
import 'package:radar/models/notification_model.dart';
import 'package:radar/utils/constants.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(title: "Notifications"),
      body: Container(
        decoration: BoxDecoration(gradient: gradient),
        child: Column(
          children: [
            Expanded(child: Obx(() => _buildNotificationList())),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationList() {
    return ListView.builder(
      itemCount: rxNotificationController.notifications.length,
      itemBuilder: (context, index) {
        NotificationModel notification =
            rxNotificationController.notifications[index];
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: buildListTile(
            title: Text(notification.title,
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(notification.body),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${notification.timestamp.hour}:${notification.timestamp.minute}",
                  style: TextStyle(color: Colors.grey),
                ),
                _buildIconButton(Icons.mark_email_read, Colors.blue, () {
                  rxNotificationController.markAsRead(notification);
                }),
                _buildIconButton(Icons.mark_email_unread, Colors.orange, () {
                  rxNotificationController.markAsUnread(notification);
                }),
                _buildIconButton(Icons.delete, Colors.red, () {
                  rxNotificationController.deleteNotification(notification);
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildIconButton(IconData icon, Color color, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(icon, color: color),
      onPressed: onPressed,
    );
  }
}
