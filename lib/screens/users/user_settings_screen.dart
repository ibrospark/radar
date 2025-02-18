import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:radar/_builds/build_all_elements.dart';
import 'package:radar/_builds/build_form.dart';
import 'package:radar/_builds/build_user.dart';
import 'package:radar/models/user_model.dart';
import 'package:radar/utils/constants.dart';
import 'package:radar/utils/functions.dart';

class UserSettingsScreen extends StatefulWidget {
  const UserSettingsScreen({super.key});

  @override
  State<UserSettingsScreen> createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {
  @override
  void initState() {
    rxImageController.pickedImages.clear();
    // TODO: implement initState
    super.initState();
    rxUserController.avatar.value =
        rxUserController.currentUser.value!.avatar.toString();
    rxUserController.lastName.value =
        rxUserController.currentUser.value!.lastName.toString();
    rxUserController.lastName.value =
        rxUserController.currentUser.value!.firstName.toString();
    rxUserController.gender.value =
        rxUserController.currentUser.value!.gender.toString();
    rxUserController.email.value =
        rxUserController.currentUser.value!.email.toString();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    rxImageController.pickedImages.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(title: "Modifier vos informations personnelles"),
      body: Obx(
        () => CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate([
                buildGrandTitle(
                  text: "Modifier vos informations personnelles",
                ),
                Center(
                  child: InkWell(
                    child: Stack(
                      children: [
                        rxImageController.pickedImages.isNotEmpty
                            ? buildImageCircle(
                                rxImageController.pickedImages.last
                                    .path, // Utilisation de la première image si elle existe
                                imageType: "File",
                                radius: 80,
                              )
                            : buildImageCircle(
                                rxUserController.currentUser.value!.avatar ==
                                            null ||
                                        rxUserController
                                            .currentUser.value!.avatar!.isEmpty
                                    ? ''
                                    : rxUserController.currentUser.value!.avatar
                                        .toString(),
                                radius: 80,
                              ),
                        const Positioned(
                          bottom: 30,
                          right: 30,
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      showImagePickerBottomSheet();
                    },
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: buildFirstNameField(),
                    ),
                    Expanded(
                      child: buildLastNameField(),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: buildGender(),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: buildEmailField(),
                    ),
                    Expanded(
                      child: buildAddressField(),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: buildElevatedButtonIcon(
                      label: 'Modifier mon compte',
                      backgroundColor: primaryColor,
                      onPressed: () async {
                        // Uploader limage
                        await rxImageController.uploadFile();
                        rxUserController.updateUser(
                          UserModel(
                            id: user!.uid,
                            firstName:
                                rxUserController.firstNameController.value.text,
                            lastName:
                                rxUserController.lastNameController.value.text,
                            gender: rxUserController.selectedGender.value,
                            email: rxUserController.emailController.value.text,
                            address:
                                rxUserController.addressController.value.text,
                          ),
                        );
                      }),
                )
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
