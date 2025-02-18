import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:radar/_builds/build_form.dart';
import 'package:radar/utils/constants.dart';
import 'package:radar/utils/functions.dart';

Widget buildImagePicker() {
  return Obx(() => GridView.builder(
        shrinkWrap: true,
        itemCount: rxImageController.pickedImages.length + 1,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemBuilder: (context, index) {
          return index == 0
              ? _buildAddImageButton(context)
              : _buildImageContainer(index - 1);
        },
      ));
}

Widget _buildAddImageButton(BuildContext context) {
  return Center(
    child: Container(
      width: double.infinity,
      height: double.infinity,
      margin: const EdgeInsets.all(3),
      decoration: _boxDecoration(),
      child: IconButton(
        onPressed: () {
          showImagePickerBottomSheet();
        },
        icon: Icon(
          Icons.add_a_photo,
          color: white,
        ),
      ),
    ),
  );
}

Widget _buildImageContainer(int index) {
  return Obx(
    () => Stack(
      children: [
        Container(
          margin: const EdgeInsets.all(3),
          decoration: _boxDecoration(
            image: DecorationImage(
              image: FileImage(rxImageController.pickedImages[index]),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 5,
          right: 5,
          child: ElevatedButton(
            onPressed: () {
              rxImageController.pickedImages.removeAt(index);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(0),
            ),
            child: Icon(
              Icons.cancel,
              size:
                  30, // Réduit la taille de l'icône pour un meilleur ajustement
              color: white,
            ),
          ),
        ),
      ],
    ),
  );
}

BoxDecoration _boxDecoration({DecorationImage? image}) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    color: thirdColor,
    border: Border.all(
      color: Colors.transparent,
      width: 3,
    ),
    image: image,
    boxShadow: [
      // Ajout d'ombre pour un effet esthétique
      BoxShadow(
        color: Colors.black.withOpacity(0.2),
        blurRadius: 5.0,
        spreadRadius: 2.0,
        offset: const Offset(0, 3), // Position de l'ombre
      ),
    ],
  );
}

Widget buildPickerButton(String text, String iconPath, ImageSource source) {
  return Padding(
    padding: const EdgeInsets.all(20),
    child: buildElevatedButtonIcon(
      label: text,
      icon: SvgPicture.asset(
        iconPath,
        height: 20,
        color: white,
      ),
      onPressed: () async {
        Get.back(); // Fermer le BottomSheet avec GetX
        try {
          await rxImageController
              .selectGallery(source); // Gérer les exceptions ici
        } catch (e) {
          // Afficher une notification d'erreur avec GetX
          Get.snackbar("Erreur", "Impossible de sélectionner l'image : $e",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white);
        }
      },
      backgroundColor: primaryColor,
      fixedSize: Size(
        Get.size.width * 0.8,
        30,
      ),
    ),
  );
}
