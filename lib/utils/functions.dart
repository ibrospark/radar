import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:radar/_builds/build_all_elements.dart';
import 'package:radar/_builds/build_image_picker.dart';
import 'package:radar/controller/auth_controller.dart';
import 'package:radar/controller/conversation_controller.dart';
import 'package:radar/controller/message_controller.dart';
import 'package:radar/controller/draggable_scrollable_sheet_controller.dart';
// import 'package:radar/controller/auth_controller.dart';
import 'package:radar/controller/house_controller.dart';
import 'package:radar/controller/image_controller.dart';
import 'package:radar/controller/maps_controller.dart';
import 'package:radar/controller/notification_controller.dart';
import 'package:radar/controller/place_controller.dart';
import 'package:radar/controller/offer_controller.dart';
import 'package:radar/controller/offer_subscription_controller.dart';
// import 'package:radar/controller/image_controller.dart';
// import 'package:radar/controller/map_controller.dart';
// import 'package:radar/controller/countries_controller.dart';
// import 'package:radar/controller/subscription_offer_controller.dart';
import 'package:radar/controller/user_controller.dart';
import 'package:radar/utils/constants.dart';
import 'dart:ui' as ui;

void initializeControllers() {
  Get.put(AuthController());
  Get.put(UserController());
  Get.put(OfferController());
  Get.put(OfferSubscriptionController());
  Get.put(HouseController());
  Get.put(UserController());
  Get.put(ConversationController());
  Get.put(MessageController());
  Get.put(ImageController());
  Get.put(MapController());
  Get.put(SearchPlaceController());
  Get.put(DraggableScrollableSheetController());
  Get.put(NotificationController());
}

String screenDeviceType(BuildContext context) {
  double deviceWidth = MediaQuery.of(context).size.width;
  if (deviceWidth > 950) {
    return 'Desktop';
  } else if (deviceWidth > 600) {
    return 'Tablet';
  } else {
    return 'Mobile';
  }
}

int calculateColums(BuildContext context) {
  double largeur = MediaQuery.of(context).size.width;

  if (largeur > 950) {
    return 4;
  } else if (largeur > 600) {
    return 3;
  } else {
    return 2;
  }
}

Future<Uint8List> getBytesFromAsset(String path, int width) async {
  final data = await rootBundle.load(path);
  final codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
      targetWidth: width);
  final frameInfo = await codec.getNextFrame();
  return (await frameInfo.image.toByteData(format: ui.ImageByteFormat.png))!
      .buffer
      .asUint8List();
}

void openModalBottomSheet(Widget content) {
  Get.bottomSheet(
    // Contraintes similaires à celles de votre code Flutter
    ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(Get.context!).size.width,
          maxHeight: MediaQuery.of(Get.context!).size.height * 0.85,
        ),
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: secondaryColor,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              content,
            ],
          ),
        ),
      ),
    ),
    // Propriétés supplémentaires pour personnaliser l'apparence du bottom sheet
    isScrollControlled: true,
    enableDrag: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    backgroundColor: Colors.white,
  );
}

void showDeleteConfirmationDialog(BuildContext context, String title,
    String content, void Function()? functionDelete) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: white,
        title: buildText(
          text: title,
          fontSize: 30,
          fontWeight: FontWeight.w800,
          color: white,
        ),
        content: buildText(
          text: content,
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: white,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Fermer la boîte de dialogue
            },
            child: const Text("Annuler"),
          ),
          TextButton(
            onPressed: functionDelete,
            child: const Text("Supprimer"),
          ),
        ],
      );
    },
  );
}

void showImagePickerBottomSheet() {
  Get.bottomSheet(
    Container(
      height: 200,
      decoration: const BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildPickerButton(
              'Prendre une photo',
              'assets/svg/camera.svg',
              ImageSource.camera,
            ),
            buildPickerButton(
              'Sélectionner de la galerie',
              'assets/svg/image_picker.svg',
              ImageSource.gallery,
            ),
          ],
        ),
      ),
    ),
  );
}
