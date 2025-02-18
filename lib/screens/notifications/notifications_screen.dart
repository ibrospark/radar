import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:radar/_builds/build_all_elements.dart';
import 'package:radar/utils/constants.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        title: "Notifications",
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('notifications').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          List<QueryDocumentSnapshot> notifications = snapshot.data!.docs;

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (BuildContext context, int index) {
              String title = notifications[index].get('title');
              String body = notifications[index].get('body');

              return Container(
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: <Color>[
                        thirdColor,
                        secondaryColor,
                      ],
                      tileMode: TileMode.mirror,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.3), blurRadius: 3),
                    ]),
                child: ListTile(
                  leading: SvgPicture.asset(
                    'assets/svg/bell.svg',
                    width: 20,
                    color: primaryColor,
                  ),
                  title: Text(title,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: Colors.white)),
                  subtitle: Text(body,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.white)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       title: 'House App',
//       initialRoute: '/',
//       getPages: [
//         GetPage(name: '/', page: () => HomeScreen()),
//         GetPage(name: '/houseDetails', page: () => HouseDetailsScreen()),
//       ],
//     );
//   }
// }


// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   final AndroidInitializationSettings initializationSettingsAndroid =
//       AndroidInitializationSettings('@mipmap/ic_launcher');
//   final InitializationSettings initializationSettings =
//       InitializationSettings(android: initializationSettingsAndroid);
//   await flutterLocalNotificationsPlugin.initialize(initializationSettings);

//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       title: 'House App',
//       initialRoute: '/',
//       getPages: [
//         GetPage(name: '/', page: () => HomeScreen()),
//         GetPage(name: '/houseDetails', page: () => HouseDetailsScreen()),
//       ],
//     );
//   }
// }

// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           child: Text('Show Notification'),
//           onPressed: () => _showNotification(context),
//         ),
//       ),
//     );
//   }

//   Future<void> _showNotification(BuildContext context) async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
//       'channel_id',
//       'channel_name',
//       'channel_description',
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//     const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
//     await flutterLocalNotificationsPlugin.show(
//       0,
//       'New House Available',
//       'A new house is available. Tap to view details.',
//       platformChannelSpecifics,
//       payload: '/houseDetails', // Définissez le chemin de navigation correspondant à la page de détails de la maison
//     );
//   }
// }



// class HouseDetailsScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final houseId = Get.arguments as String;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('House Details'),
//       ),
//       body: Center(
//         child: Text('House ID: $houseId'),
//       ),
//     );
//   }
// }
// Dans votre Application ou MainActivity pour chaque plateforme (Android et iOS), configurez le traitement des notifications en utilisant flutter_local_notifications :
// Android (dans votre Application dans le dossier android/app/src/main):
// java
// Copy code
// package com.example.your_app_package_name;

// import android.app.Application;
// import io.flutter.app.FlutterApplication;
// import io.flutter.plugin.common.PluginRegistry;
// import io.flutter.plugins.GeneratedPluginRegistrant;
// import com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin;

// public class MainApplication extends FlutterApplication implements PluginRegistry.PluginRegistrantCallback {

//   @Override
//   public void onCreate() {
//     super.onCreate();
//     FlutterLocalNotificationsPlugin.setPluginRegistrantCallback(this);
//   }

//   @Override
//   public void registerWith(PluginRegistry registry) {
//     FlutterLocalNotificationsPlugin.registerWith(registry.registrarFor("com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin"));
//   }
// }
// iOS (dans votre AppDelegate dans le dossier ios/Runner):
// swift
// Copy code
// import UIKit
// import Flutter
// import Firebase
// import flutter_local_notifications

// @UIApplicationMain
// @objc class AppDelegate: FlutterAppDelegate {
//   override func application(
//     _ application: UIApplication,
//     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//   ) -> Bool {
//     GeneratedPluginRegistrant.register(with: self)
//     FirebaseApp.configure()
//     if #available(iOS 10.0, *) {
//       UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
//     }
//     return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//   }
// }