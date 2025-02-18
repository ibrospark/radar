import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:radar/_builds/build_all_elements.dart';
import 'package:radar/_builds/build_form.dart';
import 'package:radar/utils/constants.dart';
import 'package:radar/utils/functions.dart';
import 'package:country_code_picker/country_code_picker.dart';

// Fonction pour construire le champ du nom de famille
Widget buildLastNameField() {
  return Obx(() => buildTextFormField(
        controller: rxUserController.lastNameController.value,
        labelText: 'Nom de famille',
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Veuillez saisir un nom de famille';
          }
          return null;
        },
      ));
}

// Fonction pour construire le champ du prénom
Widget buildFirstNameField() {
  return Obx(() => buildTextFormField(
        controller: rxUserController.firstNameController.value,
        labelText: 'Prénom',
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Veuillez saisir un prénom';
          }
          return null;
        },
      ));
}

// Fonction pour construire le champ du pseudo
Widget buildPseudoField() {
  return Obx(() => buildTextFormField(
        controller: rxUserController.pseudoController.value,
        labelText: 'Pseudo',
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Veuillez saisir un pseudo';
          }
          return null;
        },
      ));
}

// Fonction pour construire le champ de l'email
Widget buildEmailField() {
  return Obx(() => buildTextFormField(
        controller: rxUserController.emailController.value,
        labelText: 'Email',
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Veuillez saisir un email';
          }
          return null;
        },
      ));
}

// Fonction pour construire le champ de l'adresse
Widget buildAddressField() {
  return Obx(() => buildTextFormField(
        controller: rxUserController.addressController.value,
        labelText: 'Adresse',
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Veuillez saisir une adresse';
          }
          return null;
        },
      ));
}

// Fonction pour construire le champ de la date de naissance
Widget buildBirthdayField() {
  return Obx(() => buildTextFormField(
        controller: rxUserController.birthdayController.value,
        labelText: 'Date de naissance',
        keyboardType: TextInputType.datetime,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Veuillez saisir une date de naissance';
          }
          return null;
        },
      ));
}

// Fonction pour construire le champ du numéro de téléphone
buildPhoneNumber() {
  return Obx(() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: buildText(
              text: 'Numéro de téléphone',
              fontSize: 16,
              fontWeight: FontWeight.w800,
              textAlign: TextAlign.left,
            ),
          ),
          buildWrapTextFormField(
            child: Row(
              children: [
                Expanded(
                  child: CountryCodePicker(
                    onChanged: print,
                    initialSelection: 'SN',
                    favorite: ['+221', 'FR'],
                    showCountryOnly: false,
                    showOnlyCountryWhenClosed: false,
                    alignLeft: false,
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: rxUserController.phoneController.value,
                    decoration: InputDecoration(
                      labelText: 'Numéro de téléphone',
                      labelStyle: buildTextStyle(
                        color: thirdColor,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez saisir un numéro de téléphone';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ));
}

// FOnction pour construire le champs Genre
buildGender() {
  return Obx(() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: buildText(
            text: 'Genre',
            fontSize: 16,
            fontWeight: FontWeight.w800,
            textAlign: TextAlign.left,
          ),
        ),
        buildWrapTextFormField(
          child: buildDropdownButton(
            selectedItem: rxUserController.selectedGender.value,
            items: genderList,
            onChanged: (value) {
              rxUserController.selectedGender.value = value!;
            },
          ),
        ),
      ],
    );
  });
}

// Fonction pour construire le champ du type de compte
Widget buildAccountTypeField() {
  return Obx(() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: buildText(
            text: 'Type de compte',
            fontSize: 16,
            fontWeight: FontWeight.w800,
            textAlign: TextAlign.left,
          ),
        ),
        buildWrapTextFormField(
          child: buildDropdownButton(
            selectedItem: rxUserController.selectedAccountType.value,
            items: accountTypeList,
            onChanged: (value) {
              rxUserController.selectedAccountType.value = value!;
            },
          ),
        ),
      ],
    );
  });
}

buildAvatarPicker() {
  return Center(
    child: InkWell(
      child: Stack(
        children: [
          buildImageCircle(
            user?.photoURL ?? '',
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
  );
}
