import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:radar/utils/constants.dart';
import '../models/push_notification_model.dart';
import '../screens/notifications/notifications_badge.dart';
import 'package:cloud_functions/cloud_functions.dart';

class NotificationController extends GetxController {
  RxInt totalNotifications = 0.obs;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  PushNotification? _notificationInfo;
  RxString fcmToken = "".obs;

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    if (kDebugMode) {
      print("Handling a background message: ${message.messageId}");
    }
  }

  void registerNotification() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print('User granted permission');
      }

      RemoteMessage? initialMessage =
          await FirebaseMessaging.instance.getInitialMessage();
      if (initialMessage != null) {
        // Handle the initial message here
      }

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        // Handle the opened message here
      });

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        String title = message.notification?.title ?? '';
        String body = message.notification?.body ?? '';
        FirebaseFirestore.instance.collection('notifications').add({
          'title': title,
          'body': body,
          'timestamp': DateTime.now(),
        });

        PushNotification notification = PushNotification(
          title: message.notification?.title,
          body: message.notification?.body,
        );

        _notificationInfo = notification;
        totalNotifications++;
        update();

        if (_notificationInfo != null) {
          showSimpleNotification(
            Text(
              _notificationInfo!.title!,
              style: const TextStyle(color: primaryColor),
            ),
            leading:
                NotificationBadge(totalNotifications: totalNotifications.value),
            subtitle: Text(
              _notificationInfo!.body!,
              style: const TextStyle(color: secondaryColor),
            ),
            background: Colors.white,
            duration: const Duration(seconds: 10),
            slideDismiss: true,
          );
        }
      });
    } else {
      if (kDebugMode) {
        print('User declined or has not accepted permission');
      }
    }
    update();
  }

  Future<void> sendNotifToAllUsers(String title, String body) async {
    final HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('sendNotifToAllUsers');

    try {
      final result = await callable.call({
        'title': title,
        'body': body,
      });

      final success = result.data['success'];
      final message = result.data['message'];

      if (success) {
        print('Notification sent successfully.');
      } else {
        print('Failed to send notification: $message');
      }
    } catch (error) {
      print('Error sending notification: $error');
    }
  }

  void saveDeviceTokenToFirestore(String userId) async {
    try {
      fcmToken.value = (await FirebaseMessaging.instance.getToken())!;
      update();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'fcmToken': fcmToken.value});
    } catch (error) {
      print('Error saving device token: $error');
    }
  }
}
