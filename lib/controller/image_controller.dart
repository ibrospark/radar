import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImageController extends GetxController {
  final ImagePicker picker = ImagePicker();
  var pickedImages = <File>[].obs;
  var uploadTask = Rxn<UploadTask>();
  var imagesLinks = <String>[].obs;
  var uploadProgress = 0.0.obs;

  Future<void> selectGallery(ImageSource imageSource) async {
    try {
      final XFile? imageToPick = await picker.pickImage(source: imageSource);
      if (imageToPick != null) {
        final imageTemporary = File(imageToPick.path);
        pickedImages.add(imageTemporary); // Ajout direct à la liste observable
      }
    } on PlatformException {
      // Gestion des exceptions
    }
  }

  Future<void> uploadFile({
    String folder = "uploads/",
  }) async {
    for (var img in pickedImages) {
      final path = "$folder${img.path.split('/').last}";
      final ref = FirebaseStorage.instance.ref().child(path);

      uploadTask.value = ref.putFile(img);

      // Affichage du popup de progression
      Get.dialog(
        WillPopScope(
          onWillPop: () async => false, // Empêche la fermeture du popup
          child: AlertDialog(
            title: const Text("Téléchargement en cours"),
            content: Obx(() => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Veuillez patienter..."),
                    const SizedBox(height: 20),
                    LinearProgressIndicator(
                      value: uploadProgress.value,
                      backgroundColor: Colors.grey[300],
                      color: Colors.green,
                    ),
                    const SizedBox(height: 10),
                    Text("${(uploadProgress.value * 100).toStringAsFixed(2)} %")
                  ],
                )),
          ),
        ),
        barrierDismissible:
            false, // Empêche de fermer en cliquant à l'extérieur
      );

      // Écoute des changements de l'état du téléchargement
      uploadTask.value!.snapshotEvents.listen((snapshot) {
        uploadProgress.value = snapshot.bytesTransferred / snapshot.totalBytes;
      });

      final snapshot = await uploadTask.value!.whenComplete(() => null);
      final urlDownload = await snapshot.ref.getDownloadURL();

      imagesLinks.add(urlDownload); // Ajout direct à la liste observable
    }

    uploadTask.value = null; // Réinitialisation de la tâche après l'upload
    uploadProgress.value = 0.0; // Réinitialisation de la progression
    Get.back(); // Ferme le popup après l'upload
  }
}
