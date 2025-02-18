import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// Utilisation de AuthController
import 'package:radar/firebase_options.dart';
import 'package:radar/screens/auth/login_screen.dart';
import 'package:radar/screens/maps/main_maps_screen.dart';
import 'package:radar/utils/constants.dart';
import 'package:radar/utils/functions.dart';
import 'package:radar/utils/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  initializeControllers(); // Initialisation des contrôleurs globalement
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Radar Immobilier - Accueil',
      theme: themeData,
      debugShowCheckedModeBanner: false,
      home:
          const InitialScreen(), // Page d'initialisation qui gère la navigation en fonction de l'authentification
      initialRoute: Routes.home,
      getPages: routesList, // Définition des routes de navigation
    );
  }
}

class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (rxAuthController.firebaseUser.value == null) {
        return const LoginScreen();
      } else {
        return const MainMapsScreen();
      }
    });
  }
}
