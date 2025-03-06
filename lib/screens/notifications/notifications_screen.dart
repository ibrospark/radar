import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:radar/_builds/build_all_elements.dart';
import 'package:radar/_builds/build_notification.dart';
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
    simulerNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(title: "Notifications"),
      body: Container(
        decoration: BoxDecoration(gradient: gradient),
        child: Column(
          children: [
            Expanded(child: Obx(() => buildNotificationList())),
          ],
        ),
      ),
    );
  }
}
