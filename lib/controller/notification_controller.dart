import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import '../models/notification_model.dart';

class NotificationController extends GetxController {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var notifications = <NotificationModel>[].obs; // Liste des notifications
  var latestNotification =
      Rx<NotificationModel?>(null); // Dernière notification

  @override
  void onInit() {
    super.onInit();
    _initializeFirebaseMessaging();
    _setupFirebaseListeners();
  }

  // Initialiser Firebase Messaging
  Future<void> _initializeFirebaseMessaging() async {
    // Demander la permission (iOS)
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Obtenir le token FCM et l'enregistrer dans Firestore
    String? token = await _firebaseMessaging.getToken();
    print("FCM Token: $token");
    await _saveTokenToFirestore(token);
  }

  // Configurer les écouteurs Firebase Messaging
  void _setupFirebaseListeners() {
    // Écouter les messages en foreground
    FirebaseMessaging.onMessage.listen(_handleNotification);

    // Écouter les notifications ouvertes
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationOpened);
  }

  // Gérer une notification reçue
  Future<void> _handleNotification(RemoteMessage message) async {
    final notification = NotificationModel(
      title: message.notification?.title ?? "Nouvelle notification",
      body: message.notification?.body ?? "",
      timestamp: DateTime.now(),
    );

    // Mettre à jour l'état
    notifications.add(notification);
    latestNotification.value = notification;

    // Enregistrer la notification dans Firestore
    await _saveNotificationToFirestore(notification);
  }

  // Gérer une notification ouverte
  Future<void> _handleNotificationOpened(RemoteMessage message) async {
    final notification = NotificationModel(
      title: message.notification?.title ?? "Notification ouverte",
      body: message.notification?.body ?? "",
      timestamp: DateTime.now(),
    );

    // Mettre à jour l'état
    latestNotification.value = notification;

    // Enregistrer la notification dans Firestore
    await _saveNotificationToFirestore(notification);

    // Naviguer vers un écran spécifique
    Get.toNamed('/details', arguments: notification);
  }

  // Enregistrer la notification dans Firestore
  Future<void> _saveNotificationToFirestore(
      NotificationModel notification) async {
    await _firestore.collection('notifications').add({
      'title': notification.title,
      'body': notification.body,
      'timestamp': notification.timestamp,
    });
  }

  // Enregistrer le token FCM dans Firestore
  Future<void> _saveTokenToFirestore(String? token) async {
    if (token != null) {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'fcmToken': token,
        });
      }
    }
  }

  // Gérer les messages en arrière-plan
  static Future<void> backgroundHandler(RemoteMessage message) async {
    print("Traitement en arrière-plan: ${message.notification?.title}");
  }

  // Supprimer une notification spécifique
  Future<void> deleteNotification(NotificationModel notification) async {
    // Supprimer de la liste locale
    notifications.remove(notification);

    // Supprimer de Firestore
    final snapshot = await _firestore
        .collection('notifications')
        .where('title', isEqualTo: notification.title)
        .where('body', isEqualTo: notification.body)
        .where('timestamp', isEqualTo: notification.timestamp)
        .get();

    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  // Supprimer toutes les notifications
  Future<void> deleteAllNotifications() async {
    // Vider la liste locale
    notifications.clear();

    // Supprimer toutes les notifications de Firestore
    final snapshot = await _firestore.collection('notifications').get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  // Marquer une notification comme lue
  Future<void> markAsRead(NotificationModel notification) async {
    // Mettre à jour l'état local
    notification.isRead = true;
    notifications.refresh();

    // Mettre à jour Firestore
    final snapshot = await _firestore
        .collection('notifications')
        .where('title', isEqualTo: notification.title)
        .where('body', isEqualTo: notification.body)
        .where('timestamp', isEqualTo: notification.timestamp)
        .get();

    for (var doc in snapshot.docs) {
      await doc.reference.update({'isRead': true});
    }
  }

  // Marquer une notification comme non lue
  Future<void> markAsUnread(NotificationModel notification) async {
    // Mettre à jour l'état local
    notification.isRead = false;
    notifications.refresh();

    // Mettre à jour Firestore
    final snapshot = await _firestore
        .collection('notifications')
        .where('title', isEqualTo: notification.title)
        .where('body', isEqualTo: notification.body)
        .where('timestamp', isEqualTo: notification.timestamp)
        .get();

    for (var doc in snapshot.docs) {
      await doc.reference.update({'isRead': false});
    }
  }

  // Envoyer une notification spécifique
  Future<void> sendNotification(
      String userId, String title, String body) async {
    final userDoc = await _firestore.collection('users').doc(userId).get();
    final fcmToken = userDoc['fcmToken'];

    if (fcmToken != null) {
      await _firebaseMessaging.sendMessage(
        to: fcmToken,
        data: {
          'title': title,
          'body': body,
        },
      );
    }
  }

  // Envoyer une notification à tous les utilisateurs
  Future<void> sendNotificationToAll(String title, String body) async {
    final snapshot = await _firestore.collection('users').get();
    for (var doc in snapshot.docs) {
      final fcmToken = doc['fcmToken'];
      if (fcmToken != null) {
        await _firebaseMessaging.sendMessage(
          to: fcmToken,
          data: {
            'title': title,
            'body': body,
          },
        );
      }
    }
  }
}
