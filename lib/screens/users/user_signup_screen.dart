// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:radar/_builds/build_all_elements.dart';
import 'package:radar/_builds/build_form.dart';
import 'package:radar/screens/offer/offer_index_screen.dart';
import 'package:radar/utils/constants.dart';

class UserSignUpScreen extends StatefulWidget {
  const UserSignUpScreen({super.key});

  @override
  State<UserSignUpScreen> createState() => _UserSignUpScreenState();
}

class _UserSignUpScreenState extends State<UserSignUpScreen> {
  late var _subscriptionPlanId;
  late var _userId;
  // Upload Image Var
  File? pickedImage;
  late String _lienImage = '';

  // --------------------------------Formulaire begin ----------------------------------
  List<String> sexeItems = <String>[
    'Homme',
    'Femme',
  ];
  List<String> typeDeCompteItems = <String>[
    'Propriétaire',
    'Bailleur',
    'Courtier',
    'Agence immobilière',
  ];
  @override
  void dispose() {
    // cameraController?.dispose();
    // timer.cancel();
    super.dispose();
  }

  String _nom = '';
  String _prenom = '';
  late var _sexe = sexeItems.first;
  late String sexeDropdownValue = sexeItems.first;
  late String typeDeCompteDropdownValue = typeDeCompteItems.first;
  late var _typeDeCompte = typeDeCompteDropdownValue;
  Widget _buildSexe() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: const Color.fromRGBO(107, 107, 107, 0.973),
        ),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: const Color.fromRGBO(107, 107, 107, 0.973),
              ),
          value: sexeDropdownValue,
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down),
          elevation: 16,
          onChanged: (String? value) {
            setState(() {
              sexeDropdownValue = value!;
              _sexe = value;
            });
          },
          items: sexeItems.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTypeDeCompte() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: const Color.fromRGBO(107, 107, 107, 0.973),
        ),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: const Color.fromRGBO(107, 107, 107, 0.973),
              ),
          value: typeDeCompteDropdownValue,
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down),
          elevation: 16,
          onChanged: (String? value) {
            setState(() {
              typeDeCompteDropdownValue = value!;
              _typeDeCompte = value;
            });
          },
          items:
              typeDeCompteItems.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildNom() {
    return buildTextFormField(
      labelText: 'Nom',
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      onChanged: (value) {
        setState(() {
          _nom = value;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Veuillez saisir un nom';
        }
        return null;
      },
    );
  }

  Widget _buildPrenom() {
    return buildTextFormField(
      labelText: 'Prenom',
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      onChanged: (value) {
        setState(() {
          _prenom = value;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Veuillez saisir un prénom';
        }
        return null;
      },
    );
  }

  Widget _buildValidationButtonForm() {
    return buildElevatedButtonIcon(
      label: 'Valider mes informations',
      icon: const Icon(Icons.check),
      onPressed: () {
        Future(() async {
          _userId = await getUserId();
          RecapitulatifUser();
          setState(() {});
          // updateuser();
        });
        buildSnackbar(
          title: "Succès !",
          message: "Profil activé avec succès !",
        );
      },
      backgroundColor: primaryColor,
    );
  }

  _buildProgress() async {
    return StreamBuilder<TaskSnapshot>(
        stream: uploadTask!.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            double progress = data.bytesTransferred / data.totalBytes;
            return SizedBox(
              height: 50,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey,
                    color: Colors.green,
                  ),
                  Center(
                    child: Text(
                      '${(100 * progress.roundToDouble())}%',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const SizedBox(
              height: 50,
            );
          }
        });
  }

  // ignore: non_constant_identifier_names
  Future<void> RecapitulatifUser() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 400),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Récapitulatif".toUpperCase(),
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Text(
                            'Nom(s) :',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    fontWeight: FontWeight.w800,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 15),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            _nom,
                            style: const TextStyle(
                                fontStyle: FontStyle.italic, fontSize: 15),
                          ),
                        ],
                      ),
                      const Divider(
                        height: 20,
                        thickness: 1,
                        indent: 0,
                        endIndent: 0,
                        color: Colors.grey,
                      ),
                      Row(
                        children: [
                          Text(
                            'Prénom(s) :',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    fontWeight: FontWeight.w800,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 15),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            _prenom,
                            style: const TextStyle(
                                fontStyle: FontStyle.italic, fontSize: 15),
                          ),
                        ],
                      ),
                      const Divider(
                        height: 20,
                        thickness: 1,
                        indent: 0,
                        endIndent: 0,
                        color: Colors.grey,
                      ),
                      Row(
                        children: [
                          Text(
                            'Votre statut :',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    fontWeight: FontWeight.w800,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 15),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            _typeDeCompte,
                            style: const TextStyle(
                                fontStyle: FontStyle.italic, fontSize: 15),
                          ),
                        ],
                      ),
                      const Divider(
                        height: 20,
                        thickness: 1,
                        indent: 0,
                        endIndent: 0,
                        color: Colors.grey,
                      ),
                      Row(
                        children: [
                          Text(
                            'Votre sexe :',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    fontWeight: FontWeight.w800,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 15),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            _sexe,
                            style: const TextStyle(
                                fontStyle: FontStyle.italic, fontSize: 15),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (uploadTask != null) _buildProgress(),
                      const SizedBox(
                        height: 20,
                      ),
                      buildElevatedButtonIcon(
                        label: "J'ai fais une erreur",
                        icon: const Icon(Icons.cancel),
                        backgroundColor: Colors.red,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      buildElevatedButtonIcon(
                          label: "Je confirme mes informations",
                          icon: const Icon(Icons.check),
                          backgroundColor: Colors.green,
                          onPressed: () async {
                            await uploadFile();
                            updateuser();
                            await user?.updateDisplayName(
                                "$_prenom ${_nom.toUpperCase()}");

                            await user?.updatePhotoURL(_lienImage);

                            setState(() {});
                            // ignore: use_build_context_synchronously
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const PlansSubscriptionsScreen()),
                            );

                            // Navigator.pop(context);
                            buildSnackbar(
                              title: "Succès !",
                              message: "Compte mis à jour avec succès !",
                            );
                          }),
                    ]),
              ),
            ),
          );
        });
  }

// --------------------------------Formulaire End ----------------------------------
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 100,
              ),
              buildLogo(),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Devenir un membre actif'.toUpperCase(),
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontSize: 25),
              ),
              const SizedBox(
                height: 30,
              ),
              Center(
                child: InkWell(
                  onTap: () {
                    showModalBottomSheet<void>(
                      enableDrag: true,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      )),
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height: 200,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    children: [
                                      buildElevatedButtonIcon(
                                        label: 'Prendre une photo',
                                        icon: SvgPicture.asset(
                                          'assets/svg/camera.svg',
                                          height: 20,
                                          color: Colors.black,
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          selectGallery(ImageSource.camera);
                                        },
                                        backgroundColor: secondaryColor,
                                      ),
                                      buildElevatedButtonIcon(
                                        label: 'Sélectionner de la galerie',
                                        icon: SvgPicture.asset(
                                          'assets/svg/image_picker.svg',
                                          height: 20,
                                          color: Colors.black,
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          selectGallery(ImageSource.gallery);
                                        },
                                        backgroundColor: secondaryColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Stack(
                    children: [
                      if (pickedImage == null)
                        const CircleAvatar(
                            radius: 70,
                            backgroundColor: Colors.grey,
                            backgroundImage: AssetImage(
                              'assets/images/empty_avatar.png',
                            )),
                      if (pickedImage != null)
                        CircleAvatar(
                          radius: 70,
                          backgroundColor: Colors.grey,
                          backgroundImage: FileImage(
                            File(pickedImage!.path),
                          ),
                        ),
                      const Positioned(
                          bottom: 10,
                          right: 0,
                          child: IconButton(
                              onPressed: null, icon: Icon(Icons.edit))),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  'Votre sexe'.toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontSize: 15),
                ),
              ),
              _buildSexe(),
              Row(
                children: [
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          'Nom'.toUpperCase(),
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(fontSize: 15),
                        ),
                      ),
                      _buildNom(),
                    ],
                  )),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          'Prénom'.toUpperCase(),
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(fontSize: 15),
                        ),
                      ),
                      _buildPrenom(),
                    ],
                  ))
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  'Votre statut'.toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontSize: 15),
                ),
              ),
              _buildTypeDeCompte(),
              const SizedBox(
                height: 20,
              ),
              _buildValidationButtonForm(),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }

  //  selectGallery(ImageSource.camera);
  Future selectGallery(imageSource) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? imageToPick = await picker.pickImage(source: imageSource);
      if (imageToPick == null) return;
      final imageTemporary = File(imageToPick.path);
      setState(() {
        pickedImage = imageTemporary;
      });
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("Failed to pick image : $e");
      }
    }
  }

  UploadTask? uploadTask;
  Future uploadFile() async {
    final path = "files/${pickedImage!.path.split('/').last}";
    final file = File(pickedImage!.path);
    final ref = FirebaseStorage.instance.ref().child(path);
    setState(() {
      uploadTask = ref.putFile(file);
    });
    final snapshot = await uploadTask!.whenComplete(() => null);
    final urlDownload = await snapshot.ref.getDownloadURL();

    setState(() {
      _lienImage = urlDownload.toString();
    });
    setState(() {
      uploadTask = null;
    });
  }

  getUserId() async {
    var result = await FirebaseFirestore.instance
        .collection('users')
        .where('Id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((snapshots) {
      if (snapshots.docs.isNotEmpty) {
        for (var i = 0; i < snapshots.docs.length;) {
          setState(() {
            _subscriptionPlanId = snapshots.docs[i].get('Id');
          });
          return snapshots.docs[i].get('Id');
        }
      }
    });
    return result;
  }

  Future<void> updateuser() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(_userId)
        .update({
          "Nom": _nom,
          "Prenom": _prenom,
          "Type de compte": _typeDeCompte,
          "Sexe": _sexe,
          "Avatar": _lienImage
        })
        // ignore: avoid_print
        .then((value) => print("offers subscriptions Updated"))
        .catchError(
            // ignore: avoid_print
            (error) => print("Failed to update offers subscriptions : $error"));
  }
}
