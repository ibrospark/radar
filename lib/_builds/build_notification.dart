import 'package:flutter/material.dart';
import 'package:radar/_builds/build_all_elements.dart';
import 'package:radar/_builds/build_house.dart';
import 'package:radar/models/notification_model.dart';
import 'package:radar/utils/constants.dart';

buildNotificationBadge(final int totalNotifications) {
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
          '${totalNotifications}',
          style: const TextStyle(color: Colors.white, fontSize: 10),
        ),
      ),
    ),
  );
}

Widget buildNotificationList() {
  return rxNotificationController.notifications.isEmpty
      ? SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: buildInfoBlock(
              text: "Vous n'avez aucune notification pour le moment !",
            ),
          ),
        )
      : ListView.builder(
          itemCount: rxNotificationController.notifications.length,
          itemBuilder: (context, index) {
            NotificationModel notification =
                rxNotificationController.notifications[index];
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: buildListTile(
                title: Text(notification.title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white)),
                subtitle: Text(notification.body,
                    style: TextStyle(color: Colors.white)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${notification.timestamp.hour}:${notification.timestamp.minute}",
                      style: TextStyle(color: Colors.grey),
                    ),
                    buildIconButton(Icons.mark_email_read, Colors.blue, () {
                      rxNotificationController.markAsRead(notification);
                    }),
                    buildIconButton(Icons.mark_email_unread, Colors.orange, () {
                      rxNotificationController.markAsUnread(notification);
                    }),
                    buildIconButton(Icons.delete, Colors.red, () {
                      rxNotificationController.deleteNotification(notification);
                    }),
                  ],
                ),
              ),
            );
          },
        );
}

void simulerNotifications() {
  rxNotificationController.notifications.addAll([
    NotificationModel(
      title: "Nouvelle recherche de maison",
      body: "Une nouvelle recherche de maison a été lancée.",
      timestamp: DateTime.now().subtract(Duration(minutes: 5)),
    ),
    NotificationModel(
      title: "Mise à jour de la recherche de maison",
      body: "Une mise à jour est disponible pour votre recherche de maison.",
      timestamp: DateTime.now().subtract(Duration(hours: 1)),
    ),
    NotificationModel(
      title: "Résultat de recherche de maison",
      body: "Un nouveau résultat de recherche de maison est disponible.",
      timestamp: DateTime.now().subtract(Duration(days: 1)),
    ),
    NotificationModel(
      title: "Nouvelle recherche de maison",
      body: "Une nouvelle recherche de maison a été lancée.",
      timestamp: DateTime.now().subtract(Duration(minutes: 10)),
    ),
  ]);
}

Widget buildIconButton(IconData icon, Color color, VoidCallback onPressed) {
  return IconButton(
    icon: Icon(icon, color: color),
    onPressed: onPressed,
  );
}
