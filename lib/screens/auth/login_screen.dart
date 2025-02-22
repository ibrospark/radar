import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:radar/_builds/build_all_elements.dart';
import 'package:radar/_builds/build_form.dart';
import 'package:radar/utils/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    dispose() {
      rxAuthController.isLoading.value = false;
      super.dispose();
    }

    return Scaffold(
      body: Obx(() {
        return SingleChildScrollView(
          child: Container(
            height: Get.size.height,
            decoration: const BoxDecoration(
              gradient: gradient, // Dégradé défini dans constants.dart
            ),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/svg/locked.svg',
                    width: Get.size.width * 0.5,
                  ),
                  buildLogo(),
                  buildGrandTitle(
                    text: "Connectez-vous à votre compte !",
                    color: white,
                    fontSize: 25,
                  ),
                  buildText(
                    text: "Saisissez votre numéro de téléphone pour continuer.",
                    fontSize: 18,
                    color: primaryColor,
                    overflow: TextOverflow.visible,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  IntlPhoneField(
                    controller: rxAuthController.phoneNumberController.value,
                    initialCountryCode: "SN", // Code pays pour le Sénégal
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                      labelText: 'Numéro de téléphone',
                      labelStyle: const TextStyle(color: Colors.white),
                    ),
                    onChanged: (value) {
                      rxAuthController.phoneNumber.value = value.completeNumber;
                    },
                  ),
                  const SizedBox(height: 20),
                  Obx(() {
                    return buildElevatedButtonIcon(
                      label: "Connexion",
                      icon: rxAuthController.isLoading.value == true
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.black,
                                strokeWidth: 2.0,
                              ),
                            )
                          : const Icon(
                              Icons.login,
                              color: Colors.black,
                            ),
                      backgroundColor: primaryColor,
                      fixedSize: Size(
                        Get.size.width,
                        50,
                      ),
                      onPressed: rxAuthController.isLoading.value == true
                          ? null
                          : () {
                              final String phoneNumber =
                                  rxAuthController.phoneNumber.value.trim();

                              if (isValidPhoneNumber(phoneNumber)) {
                                rxAuthController.verifyPhoneNumber(phoneNumber);
                              } else {
                                Get.snackbar(
                                  'Erreur',
                                  'Veuillez entrer un numéro de téléphone valide au format E.164.',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                );
                              }
                            },
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  /// Fonction pour valider le format du numéro de téléphone
  bool isValidPhoneNumber(String phoneNumber) {
    final regex = RegExp(r'^\+\d{1,3}\d{9,}$'); // Format E.164
    return regex.hasMatch(phoneNumber);
  }
}
