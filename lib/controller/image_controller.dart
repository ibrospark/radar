import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:radar/utils/constants.dart';

class ImageController extends GetxController {
  final ImagePicker picker = ImagePicker();
  var pickedImages = <File>[].obs;
  var uploadTask = Rxn<UploadTask>();
  var imagesLinks = <String>[].obs;
  var uploadProgress = 0.0.obs;

  void clearImageController() {
    pickedImages.clear();
    imagesLinks.clear();
    uploadTask.value = null;
    uploadProgress.value = 0.0;
  }

  Future<void> selectGallery(ImageSource imageSource) async {
    try {
      final XFile? imageToPick = await picker.pickImage(source: imageSource);
      if (imageToPick != null) {
        final imageTemporary = File(imageToPick.path);
        pickedImages.add(imageTemporary);
      }
    } on PlatformException catch (e) {
      print("Erreur lors de la sélection de l'image : $e");
      Get.snackbar("Erreur", "Impossible d'ouvrir la caméra ou la galerie.");
    } catch (e) {
      print("Erreur inconnue : $e");
    }
  }

  Future<void> uploadFile({String folder = "uploads/"}) async {
    for (var img in pickedImages) {
      await _uploadImage(img, folder, "Téléchargement en cours");
    }
  }

  Future<void> uploadAvatar(File avatar, {String folder = "avatars/"}) async {
    await _uploadImage(avatar, folder, "Téléchargement de l'avatar");
  }

  Future<void> _uploadImage(
      File image, String folder, String dialogTitle) async {
    final path = "$folder${image.path.split('/').last}";
    final ref = FirebaseStorage.instance.ref().child(path);

    uploadTask.value = ref.putFile(image);

    // Affichage du popup de progression
    Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: Text(dialogTitle),
          content: Obx(() => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Veuillez patienter..."),
                  const SizedBox(height: 20),
                  LinearProgressIndicator(
                    value: uploadProgress.value,
                    backgroundColor: Colors.grey[300],
                    color: primaryColor,
                  ),
                  const SizedBox(height: 10),
                  Text("${(uploadProgress.value * 100).toStringAsFixed(2)} %")
                ],
              )),
        ),
      ),
      barrierDismissible: false,
    );

    // Écoute des changements de l'état du téléchargement
    uploadTask.value!.snapshotEvents.listen((snapshot) {
      uploadProgress.value = snapshot.bytesTransferred / snapshot.totalBytes;
    });

    final snapshot = await uploadTask.value!.whenComplete(() => null);
    final urlDownload = await snapshot.ref.getDownloadURL();

    imagesLinks.add(urlDownload);

    uploadTask.value = null;
    uploadProgress.value = 0.0;
    Get.back();
  }

  Future<void> deleteImageFromBucket(String imageUrl) async {
    try {
      final ref = FirebaseStorage.instance.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      // Gestion des exceptions
    }
  }
}
