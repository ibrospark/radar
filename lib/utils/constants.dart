import 'dart:core';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:radar/controller/activity_zone_controller.dart';
import 'package:radar/controller/chat/message_controller.dart';
import 'package:radar/controller/user/auth_controller.dart';
import 'package:radar/controller/chat/discussion_controller.dart';
import 'package:radar/controller/draggable_scrollable_sheet_controller.dart';
import 'package:radar/controller/house_controller.dart';
import 'package:radar/controller/image_controller.dart';
import 'package:radar/controller/maps/maps_controller.dart';
import 'package:radar/controller/notification_controller.dart';
import 'package:radar/controller/maps/place_controller.dart';
import 'package:radar/controller/offer/offer_controller.dart';
import 'package:radar/controller/offer/offer_subscription_controller.dart';
import 'package:radar/controller/user/user_controller.dart';

final auth = FirebaseAuth.instance;
User? get user => auth.currentUser;
const MaterialColor primaryColor = MaterialColor(
  0xFFBCE566,
  <int, Color>{
    50: Color(0xFFF4FDE7),
    100: Color(0xFFEAFBCC),
    200: Color(0xFFD9F899),
    300: Color(0xFFC8F566),
    400: Color(0xFFBBF344),
    500: Color(0xFFBCE566), // Couleur primaire
    600: Color(0xFFB0D350),
    700: Color(0xFFA3C039),
    800: Color(0xFF95AE23),
    900: Color(0xFF829A00),
  },
);
const secondaryColor = Color(0xFF88A3A6); // #88A3A6
const thirdColor = Color(0xFF445760); // #445760
const fourthColor = Color(0xFF3A3A3A); // #3A3A3A

const gradient = LinearGradient(
  colors: [thirdColor, secondaryColor],
  begin: Alignment.bottomLeft,
  end: Alignment.topRight,
);
const boxShadow = BoxShadow(
  color: Color(0x33000000), // Utilisation d'une couleur avec opacité (20% ici)
  spreadRadius: 2, // Étendue de l'ombre
  blurRadius: 5, // Rayon du flou de l'ombre
  offset: Offset(0, 3), // Décalage de l'ombre (horizontal, vertical)
);
const divider = Divider(
  color: thirdColor,
  thickness: 0.5, // Épaisseur de la ligne
  indent: 10.0, // Espace avant la ligne
  endIndent: 10.0, // Espace après la ligne
);

// -----------------------------------------------
Color backgroundColor1 = const Color.fromRGBO(136, 163, 166, 1);
const colorText = Color.fromRGBO(58, 58, 58, 1);
// -----------------------------------------------
Color white = Colors.white;
const yellowColor = Color.fromRGBO(255, 192, 0, 1);
// -----------------------------------------------
AuthController rxAuthController = Get.find();
UserController rxUserController = Get.find();
HouseController rxHouseController = Get.find();
MapController rxMapController = Get.find();
DiscussionController rxDiscussionController = Get.find();
MessageController rxMessageController = Get.find();
SearchPlaceController rxSearchPlaceController = Get.find();
ImageController rxImageController = Get.find();
DraggableScrollableSheetController rxDraggableScrollableSheetController =
    Get.find();
OfferController rxOfferController = Get.find();
OfferSubscriptionController rxOfferSubscriptionController = Get.find();
NotificationController rxNotificationController = Get.find();
ActivityZoneController rxActivityZoneController = Get.find();

// -----------------------------------------------
String googleMapApiKey = 'AIzaSyAONca6NEPKGnm_GSXAr3wDfKsnfbevES4';
// -----------------------------------------------

ThemeData? themeData = ThemeData(
  primaryColor: primaryColor,
  colorScheme: ColorScheme.fromSeed(
    seedColor: primaryColor,
  ),
  useMaterial3: true,
  canvasColor: primaryColor,
  scaffoldBackgroundColor: backgroundColor1,
  textTheme: GoogleFonts.sourceSans3TextTheme(),
  fontFamily: GoogleFonts.sourceSans3(
    fontWeight: FontWeight.w600,
  ).fontFamily,
);

// -----------------------------------------------
final Map<String, String> markerIcons = {
  'default': 'assets/mapicons/default.png',
  'currentPosition': 'assets/mapicons/current_user_position2.png',
  'destination': 'assets/mapicons/destination.png',
  'origin': 'assets/mapicons/default.png',
  'pin': 'assets/mapicons/pin.png',
  'other': 'assets/mapicons/default.png',
};

// -----------------------------------------------
List<String> categoriesList = <String>[
  'Appartement',
  'Chambre',
  'Commerce',
  "Bureau",
  'Villa',
  'Immeuble',
  'Maison',
  'Maison de vacance',
  'Studio',
  'Terrain'
];
List<String> optionsList = <String>[
  "Buanderie",
  "Garage",
  "Balcon",
  "Cours",
  "Dépendance",
  "Salle à manger",
  "Espace Familliale",
  "Piscine",
];
List<String> regionsList = <String>[
  'Dakar',
  'Diourbel',
  'Fatick',
  'Kaffrine',
  'Kaolack',
  'Kedougou',
  'Kolda',
  'Louga',
  'Matam',
  'Saint-Louis',
  'Sédhiou',
  'Tambacounda',
  'Thiès',
  'Ziguinchor',
];
List<String> statusList = <String>[
  'En cours de validation',
  'Actif',
  'Désactivé'
];
// -----------------------------------------------

List<String> rentalDurationList = <String>[
  '/Mois',
  '/Jour',
];
List<String> currenciesList = <String>[
  "XOF(CFA)",
  "XAF(CFA)",
  "€",
  "\$",
  "£",
  "¥ ",
];
List<String> transactionsTypeList = [
  'A louer',
  'A vendre',
];

List<String> accountTypeList = <String>[
  'Particulier',
  'Propriétaire',
  'Bailleur',
  'Courtier',
  'Agence immobilière',
];
List<String> genderList = <String>[
  'Homme',
  'Femme',
];
